////
////  MMStore.m
////  BandIt
////
////  Created by Kelly Huberty on 7/13/12.
////  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
////
//
#import "MMSchema.h"
#import "MMORMUtility.h"
#import "MMRecord.h"
#import "MMRecordSet.h"


static NSMutableDictionary * storesByThread;
static NSMutableDictionary * activeRecords;


@interface MMService(){
    
    
}

//-(void)initializeStore:(NSURL*)url;

@end

@implementation MMService


-(instancetype)initWithSchema:(MMSchema *)schema;
{
    self = [super init];
    if (self) {

        _schema = MMRetain(schema);
        
    }
    return self;
}


+(void)initialize{
    
    //MMRelease(storesByThread);
    storesByThread = [[NSMutableDictionary alloc]init];
    
    activeRecords = [[NSMutableDictionary alloc]init];
    
}

-(NSOperationQueue *)operationQueue{
    
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc]init];
    }
    
    return _operationQueue;
}


+(MMService *)storeWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
    
    return [self serviceWithSchemaName:schemaName type:@"store" version:ver];
    
}

//+(MMService *)cloudWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
//    
//    return [self storeWithSchemaName:schemaName version:ver type:@"cloud"];
//    
//}

+(MMService *)serviceWithSchemaName:(NSString *)schemaName type:(NSString *)storeType version:(MMVersionString *)ver{

    
    if (ver == nil) {
        MMSchema * sc = [MMSchema currentSchemaWithName:schemaName];
        ver = sc.version;
    
    }
    
    NSMutableDictionary * threadDict;
    NSMutableDictionary * storeDict;
    
    NSString * storeName = [NSString stringWithFormat:@"%@__%@__%@", schemaName, ver, storeType];
    MMService * store = nil;
    
    if ((threadDict = storesByThread[MMORMThreadNSNumber()])) {
    //    storesByThread[MMORMThreadNSNumber()] = threadDict = [[NSMutableDictionary alloc]init];
        storesByThread[@1] = threadDict = [[NSMutableDictionary alloc]init];
    }
    
    if (!(storeDict = threadDict[storeName])) {
        threadDict[storeName] = storeDict = [[NSMutableDictionary alloc]init];
    }
    
    if (!(store = storeDict[storeName])) {
        storeDict[storeName] = store = [MMService newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)storeType  version:ver];
    }

    NSLog(@"thread dict %@", store);
    
    return store;
}

+(MMService *)newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)serviceType version:ver{
    
    MMSchema * schema = [MMSchema schemaFromName:schemaName version:ver];
    
    //+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    
    return [[NSClassFromString([schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]]) alloc]initWithSchema:schema];
    
}





+(MMService *)newStoreWithSchemaName:(NSString *)schemaName version:ver{
    
    MMSchema * schema = [MMSchema schemaFromName:schemaName version:ver];
    
    //+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{

    
    return [[NSClassFromString(schema.storeClassName) alloc]initWithSchema:schema];

}


-(MMSet *)wrapData:(NSArray *)array intoRecordsOfType:(NSString *)classname inSet:(MMSet *)set created:(BOOL)created{
    
    if (!set) {
        set = [MMSet array];
    }
    
    for (NSDictionary * values in array) {
        
        //[MMRecord idHashWithIdValues:[MMRecord idValuesWithValues:values]]
        
//        MMRecord * rec = [[self class] retrieveActiveRecord:[MMRecord idHashWithIdValues:[MMRecord idValuesWithValues:values]]];
//        
//        if (rec == nil) {
//            rec = [[NSClassFromString(classname) alloc] initWithFillValues:values created:created fromStore:self];
//            [[self class] addRecordToActiveRecords:rec];
//        }

        MMRecord * rec = [self wrapValues:values intoRecordOfType:classname created:(BOOL)created];
        
        
        [set addObject:rec];
        
        MMRelease(set);
        
    }
    
    return set;

}

-(MMRequest *)newRequestForClassname:(NSString *)className{
    
        //MMSchema * schema = [MMSchema schemaFromName:schemaName version:ver];
    
        //+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    
        //return [[NSClassFromString([schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]]) alloc]initWithSchema:schema];
    
    return nil;
    
}



-(MMRecord *)wrapValues:(NSDictionary *)values intoRecordOfType:(NSString *)classname created:(BOOL)created{
    
    Class class = NSClassFromString(classname);
    
    MMRecord * rec = [[self class] retrieveActiveRecord:[class idHashWithIdValues:[class idValuesWithValues:values]]];
        
    if (rec == nil) {
        rec = [[NSClassFromString(classname) alloc] initWithFillValues:values created:created fromStore:self];
        [[self class] addRecordToActiveRecords:rec];
    }

    return rec;
    
}


+(void)addRecordToActiveRecords:(MMRecord *)rec{
    
    @synchronized(activeRecords){
        return [activeRecords setObject:rec forKey:[rec idHash]];
    }
    
}

+(void)removeRecordFromActiveRecords:(MMRecord *)rec{
    
    @synchronized(activeRecords){
        return [activeRecords removeObjectForKey:[rec idHash]];
    }
    
}

+(MMRecord *)retrieveActiveRecord:(NSString *)hash{

    @synchronized(activeRecords){
        return activeRecords[hash];
    }
    
}

+(void)clearActiveRecordCache{
    
    @synchronized(activeRecords){
        [activeRecords removeAllObjects];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MMActiveRecordCacheClear" object:self];

}



@end

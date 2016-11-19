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
#import "MMOrmManager.h"
#import "MMPreferences.h"
#import "MMEntity.h"
#import "MMRelationshipSet.h"
#import "MMVersionString.h"

//static NSMutableDictionary * storesByThread;

NSString * MMStringFromCrudOperation(MMCrudOperation op){
    switch (op) {
        case MMCrudOperationCreate:
            return @"Create";
            break;
        case MMCrudOperationRead:
            return @"Read";
            break;
        case MMCrudOperationUpdate:
            return @"Update";
            break;
        case MMCrudOperationDelete:
            return @"Destroy";
            break;
        default:
            break;
    }
    
}



static NSMutableDictionary * activeRecords;
static dispatch_queue_t activeRecordDispatchQueue;



@interface MMService(){
    
    
}

//-(void)initializeStore:(NSURL*)url;

@end

@implementation MMService


-(instancetype)initWithSchema:(MMSchema *)schema;
{
    self = [super init];
    if (self) {

        _schema = schema;
        
    }
    return self;
}


+(void)initialize{
    
    activeRecordDispatchQueue = dispatch_queue_create("MMActiveRecordQueue", NULL);
    
    activeRecords = [[NSMutableDictionary alloc]init];
    
}

-(NSOperationQueue *)operationQueue{
    
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc]init];
    }
    
    return _operationQueue;
}

//
//+(MMService *)storeWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
//    
//    return [self serviceWithSchemaName:schemaName type:@"store" version:ver];
//    
//}

//+(MMService *)cloudWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
//    
//    return [self storeWithSchemaName:schemaName version:ver type:@"cloud"];
//    
//}

//+(MMService *)serviceWithSchemaName:(NSString *)schemaName type:(NSString *)storeType version:(MMVersionString *)ver{
//
//    if (ver == nil) {
//        MMSchema * sc = [MMSchema currentSchemaWithName:schemaName];
//        
//        NSLog(@"schema with name %@", schemaName);
//
//        ver = sc.version;
//    
//    }
//    
//    MMOrmamentManager * manager = [MMOrmamentManager sharedManager];
//    
//    NSMutableDictionary * storesByThread = manager.services;
//    
//    NSMutableDictionary * threadDict;
//    NSMutableDictionary * storeDict;
//    
//    NSString * storeName = [NSString stringWithFormat:@"%@__%@__%@", schemaName, ver, storeType];
//    MMService * store = nil;
//    
////    if ((threadDict = storesByThread[MMORMThreadNSNumber()])) {
////        storesByThread[MMORMThreadNSNumber()] = threadDict = [[NSMutableDictionary alloc]init];
////    }
//    
//    if (!(storeDict = storesByThread[@1])) {
//        storesByThread[@1] = storeDict = [NSMutableDictionary dictionary];
//    }
//    
////    if (!(storeDict = threadDict[storeName])) {
////        threadDict[storeName] = storeDict = [[NSMutableDictionary alloc]init];
////    }
//    
//    if (!(store = storeDict[storeName])) {
//        
//        store = [MMService newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)storeType  version:ver];
//    
//        NSLog(@"store with name %@", store);
//
//        
//        
//        storeDict[storeName] = store;
//    
//    }
//
//    NSLog(@"thread dict %@", store);
//    
//    return store;
//        
//}


//+(MMService *)serviceWithSchemaName:(NSString *)schemaName type:(NSString *)storeType version:(MMVersionString *)ver{
//    
//    if (ver == nil) {
//        MMSchema * sc = [MMSchema registeredSchemaWithName:schemaName];
//        
//        NSLog(@"schema with name %@", schemaName);
//        
//        ver = sc.version;
//        
//    }
//    
//    MMOrmManager * manager = [MMOrmManager manager];
//    
//    NSMutableDictionary * services = manager.services;
//    
//    NSString * storeName = [NSString stringWithFormat:@"%@__%@__%@", schemaName, ver, storeType];
//    MMService * service = nil;
//    
//    if (!(service = services[storeName])) {
//        
//        service = [MMService newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)storeType  version:ver];
//        
//        NSLog(@"store with name %@", service);
//        
//        
//        
//        services[storeName] = service;
//        
//    }
//    
//    NSLog(@"thread dict %@", service);
//    
//    return service;
//    
//}
//
//
//+(MMService *)newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)serviceType version:(MMVersionString *)ver{
//    
//    //MMSchema * schema = [MMSchema registeredSchemaWithName:schemaName version:ver];
//    
//    if (ver == nil) {
//        ver = [MMService currentVersionForSchemaName:schemaName type:serviceType];
//    
//    }
//    
//    
//        MMSchema * schema = [MMSchema schemaFromName:schemaName version:ver];
//    
//    NSLog(@"schema with name: %@, %@, %@", schemaName, ver, schema);
//    return [[NSClassFromString([schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]]) alloc]initWithSchema:schema];
//    
//}
//
//
//+(MMService *)newStoreWithSchemaName:(NSString *)schemaName version:ver{
//    
//    MMSchema * schema = [[MMOrmManager manager] schemaWithName:schemaName];
//    
//    //+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
//
//    
//    return [[NSClassFromString(schema.storeClassName) alloc]initWithSchema:schema];
//
//}


-(void)prepareForMigrationAttemptFromVersion:(MMVersionString *)versionString{
    
    
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
        
        
    }
    
    return set;

}

-(MMRequest *)newRequestForClassname:(NSString *)className{
    
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in class %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
        //return [[NSClassFromString([schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]]) alloc]initWithSchema:schema];
    
    return nil;
    
}



-(MMRecord *)wrapValues:(NSDictionary *)values intoRecordOfType:(NSString *)classname created:(BOOL)created{
    
    Class class = NSClassFromString(classname);
    
    MMRecord * rec = [[self class] retrieveActiveRecord:[class idHashWithIdValues:[class idValuesWithValues:values]]];
    
    MMEntity * entity = [NSClassFromString(classname) entity];
    
    NSArray * dateObjects = [entity.attributes objectsWithValue:@"NSDate" forKey:@"classname"];
    
    NSMutableDictionary * newValues = [values mutableCopy];
    
    for (MMAttribute * attr in dateObjects) {
        
        NSObject * obj = newValues[attr.name];
        
        if ([obj isKindOfClass:[NSNumber class]]) {
            obj = [NSDate dateWithTimeIntervalSince1970:[(NSNumber*)obj integerValue]];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            //obj = [NSDate dateWithTimeIntervalSince1970:[ integerValue]];
        }
        
        newValues[attr.name] = obj;
        
    }
    
    
    
    
    if (rec == nil) {
        rec = [[NSClassFromString(classname) alloc] initWithFillValues:newValues created:created fromStore:self];
        [[self class] addRecordToActiveRecords:rec];
    }

    return rec;
    
}



-(BOOL)build:(NSError **)error{
    

    return YES;
    
}




+(void)addRecordToActiveRecords:(MMRecord *)rec{
    
    dispatch_barrier_sync(activeRecordDispatchQueue, ^(){
        [activeRecords setObject:rec forKey:[rec idHash]];
    });
    
}

+(void)removeRecordFromActiveRecords:(MMRecord *)rec{
    
    dispatch_barrier_sync(activeRecordDispatchQueue, ^(){
        return [activeRecords removeObjectForKey:[rec idHash]];
    });
    
}

+(MMRecord *)retrieveActiveRecord:(NSString *)hash{
    MMRecord * __block rec;
    dispatch_sync(activeRecordDispatchQueue, ^(){
         rec = activeRecords[hash];
    });
    return rec;
}

+(void)clearActiveRecordCache{
    
    dispatch_barrier_sync(activeRecordDispatchQueue, ^(){
        [activeRecords removeAllObjects];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MMActiveRecordCacheClear" object:self];

}






+(MMVersionString *)currentVersionForSchemaName:(NSString *)schemaName type:(NSString *)type{
    
    NSUserDefaults * shared = [NSUserDefaults standardUserDefaults];

    
    NSDictionary * dict = [[shared dictionaryForKey:@"MMServiceVersions"] mutableCopy];
    
    NSString * key = [NSString stringWithFormat:@"%@_%@",schemaName, type];
    
    if (dict[key]) {
        return [MMVersionString stringWithString:dict[key]];
    }
    return nil;
    
}

+(void)setCurrentVersion:(MMVersionString *)version forSchemaName:(NSString *)schemaName type:(NSString *)type{
    
    NSUserDefaults * shared = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * dict = [[shared dictionaryForKey:@"MMServiceVersions"] mutableCopy ];
        
    NSString * key = [NSString stringWithFormat:@"%@_%@",schemaName, type];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[key] = version;
    
    [shared setObject:dict forKey:@"MMServiceVersions"];
    [shared synchronize];
    
}

+(void)unsetVersionForSchemaName:(NSString *)schemaName type:(NSString *)type{
    
    NSMutableDictionary * dict = [[MMPreferences valueForKey:@"MMServiceVersions"] mutableCopy];
    
    NSString * key = [NSString stringWithFormat:@"%@_%@",schemaName, type];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    [dict removeObjectForKey:key];
    
    [MMPreferences setValue:dict forKey:@"MMServiceVersions"];
    
}


@end

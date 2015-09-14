//
//  MMModel.m
//  Marshmallow
//
//  Created by Kelly Huberty on 4/24/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import "MMRecord.h"
    //#import "MMService.h"
    //#import "MMEntity.h"
#import "MMUtility.h"
#import "MMService.h"

#import "MMSet.h"

#import "MMORMUtility.h"

#import "MMRequest.h"

#import <objc/runtime.h>
#import "MMAdapter.h"

#import "MMAttribute.h"

static void setValueIMP(id self, SEL _cmd, id aValue);


@interface MMRecord ()

-(MMRelationshipSet *)_fetchRelationshipSetWithRelationshipName:(NSString *)relationshipName;
-(MMRelationshipSet *)_fetchRelationshipSetWithRelationship:(MMRelationship *)relationship;

@end



// generic getter
id valueIMP(id self, SEL _cmd) {

    id value;
    @synchronized(self) {

        //[self willAccessValueForKey:NSStringFromSelector(_cmd)];
        Ivar ivar = class_getInstanceVariable([self class], "_values");
        //[self didAccessValueForKey:NSStringFromSelector(_cmd)];
        value = [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];
            
    }
    return value;

}

static void setValueIntIMP(id self, SEL _cmd, int intValue) {
    setValueIMP(self, _cmd, [NSNumber numberWithInt:intValue] );
}
static void setValueBoolIMP(id self, SEL _cmd, BOOL boolValue) {
    setValueIMP(self, _cmd, [NSNumber numberWithBool:boolValue] );
}
static void setValueFloatIMP(id self, SEL _cmd, float floatValue) {
    setValueIMP(self, _cmd, [NSNumber numberWithFloat:floatValue] );
}
static void setValueDoubleIMP(id self, SEL _cmd, double floatValue) {
    setValueIMP(self, _cmd, [NSNumber numberWithDouble:floatValue] );
}
static void setValueLongIMP(id self, SEL _cmd, float longValue) {
    setValueIMP(self, _cmd, [NSNumber numberWithLong:longValue] );
}
static void setValueCharIMP(id self, SEL _cmd, char charValue) {
    setValueIMP(self, _cmd, [NSValue value:&charValue withObjCType:@encode(char)] );
}




int valueIntIMP(id self, SEL _cmd) {
    return [((NSNumber*)valueIMP(self, _cmd)) intValue];
}
BOOL valueBoolIMP(id self, SEL _cmd) {
    return [((NSNumber*)valueIMP(self, _cmd)) boolValue];
}
float valueFloatIMP(id self, SEL _cmd) {
    return [((NSNumber*)valueIMP(self, _cmd)) floatValue];
}
double valueDoubleIMP(id self, SEL _cmd) {
    return [((NSNumber*)valueIMP(self, _cmd)) doubleValue];
}
long valueLongIMP(id self, SEL _cmd) {
    return [((NSNumber*)valueIMP(self, _cmd)) longValue];
}
char valueCharIMP(id self, SEL _cmd) {
    char * value;
    [((NSValue*)valueIMP(self, _cmd)) getValue:value];
    return *value;
}





// generic setter
static void setValueIMP(id self, SEL _cmd, id aValue) {
    
    
    id value = [aValue copy];
    
    @synchronized(self){
    
        NSString *key;
        key = [NSStringFromSelector(_cmd) mutableCopy];
        
        
        MMDebug(@"settingggg");
        
        // delete "set" and ":" and lowercase first letter
        //[key deleteCharactersInRange:NSMakeRange(0, 3)];
    //    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
    //    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    //    NSString *firstChar = [key substringToIndex:1];
    //    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
        
        
        key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
        key = [key stringByReplacingCharactersInRange:NSMakeRange([key length] - 1, 1) withString:@""];
        NSString *firstChar = [key substringToIndex:1];
        key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];

        
        
        
        [self willChangeValueForKey:key];
        
        
        
        Ivar ivar = class_getInstanceVariable([self class], "_values");
        
        NSMutableDictionary * dict = ((NSMutableDictionary *)object_getIvar(self, ivar));
        
        @synchronized(dict){
            [dict setObject:(value) forKey:key];
        }
        
        ((MMRecord *)self).dirty = true;
        
        //void * dirty;
        //object_getInstanceVariable([self class], "_dirty", &dirty);
        
        
        
        
        [self didChangeValueForKey:key];

    }
}



// generic getter
id relationValueIMP(id self, SEL _cmd) {
    
    //NSString * key = cleanSelectorIntoKeyName();
    
    //Ivar ivar = class_getInstanceVariable([self class], "_relationValues");
    //id obj = [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];

    MMEntity * entity = [[((MMRecord *)self) class] entity];
    MMRelationship * relationship = [entity relationshipWithName:NSStringFromSelector(_cmd)];
//    
//    if (!obj) {
//        
//        MMStore * store = [[((MMRecord *)self) class] store];
//        //Ivar ivar = class_getInstanceVariable([self class], "_values");
//        
//        if (!relationship) {
//            [NSException raise:@"MMInvalidRecordPropertyException" format:@"The property tried to access was invalid..."];
//        }
//        
//        obj = [(MMRecord *)self _fetchRelationshipSetWithRelationshipName:key];
//        
//        [((NSMutableDictionary *)object_getIvar(self, ivar)) setObject:obj forKey:NSStringFromSelector(_cmd)];
//    }
    
    MMRelationshipSet * obj = [(MMRecord *)self _fetchRelationshipSetWithRelationship:relationship];

    
    if (!relationship.hasMany) {
        
        if ([obj count] > 0){
            
            obj = obj[0];
            
        }
        else{
            obj = nil;
        }
    
    }
    
    return obj;
}


// generic setter
static void setRelationValueIMP(id self, SEL _cmd, id aValue) {
    
    //id value = [aValue copy];
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    //NSLog(@"settingggg");
    
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    
    MMService * store = [[((MMRecord *)self) class] store];
    MMEntity * entity = [[((MMRecord *)self) class] entity];
    MMRelationship * relationship = [entity relationshipWithName:NSStringFromSelector(_cmd)];
    
    if (!relationship.hasMany) {
        
        [self willChangeValueForKey:key];

        id obj = [self _fetchRelationshipSetWithRelationshipName:key];

        [obj removeAllObjects];
    
        [obj addObject:aValue];
    
        [self didChangeValueForKey:key];
        
        return;
    }
    
    [NSException raise:@"MMInvalidRelationshipSaveContext" format:@"You can't directly save a hasMany relationship by property assignment. Please use addObjects: or removeObjects:, or other NSMutableArray mutator methods."];
        
}









@implementation MMRecord

//@synthesize mmEntity = _entity;
//@synthesize mmService = _service;
//@synthesize mmEntity = _values;

-(instancetype)initWithValues:(NSDictionary *)values{
    
    //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [self init];
    
    if (self != nil) {
        _inserted = NO;
        @synchronized(_values){
            [_values addEntriesFromDictionary:values];
        }
            //[self registerNotificationHash];
        
        MMDebug(@"values %@", values);
    }
    
    return self;
}

-(instancetype)initWithFillValues:(NSDictionary *)values created:(BOOL)inserted fromStore:(MMService *)store{
    
    //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [self init];
    
    if (self != nil) {
        @synchronized(self){
            _inserted = inserted;
        }
        @synchronized(_values){
            [_values addEntriesFromDictionary:values];
        }
        //[self registerNotificationHash];
    }
    
    return self;
}


-(instancetype)init{
    
        //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [super init];
    
    if (self != nil) {

        _values = [[NSMutableDictionary alloc]init];
        _relationValues = [[NSMutableDictionary alloc]init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recacheActiveStore) name:@"MMActiveRecordCacheClear" object:[[self class]store]];
        
    }
    
    return self;
}

+(instancetype)findOne:(NSDictionary *)criteria{
    
    
    
    return nil;
    
}

+(instancetype)findMany:(NSDictionary *)criteria{
    
    
    return nil;
    
}

+(instancetype)create{
    
    id blah = MMAutorelease([[[self class] alloc] init]);
    
    return blah;
    //return rec;
}

+(void)create:(NSDictionary *)dictionary error:(NSError **)error completionBlock:( void (^)(MMRecord * record, BOOL success, NSError **))completionBlock{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^(){
        
        MMRecord * rec = [self create:dictionary error:error];
        
        BOOL success = false;
        
        if (rec) {
            success = true;
        }
        
        completionBlock(rec, success, error);
    
    }];
    
}

+(instancetype)create:(NSDictionary *)dictionary{
    
    NSError * error;
    
    MMRecord * rec = [self create:dictionary error:&error];
    
    return  rec;
    
}

+(instancetype)create:(NSDictionary *)dictionary error:(NSError **)error{
    
    MMRecord * rec = MMAutorelease([[[self class] alloc] initWithValues:dictionary]);

    //NSError * error;
    
    [rec save:error];
    
    return  rec;
    
}



//-(void)registerNotificationHash{
//    
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    
//    [center addObserver:self selector:@selector(receiveRecordChangeNotification:) name:[NSString stringWithFormat:@"__%@__CHANGED", [self idHash]] object:self];
//    
//    
//    
//}
//
//-(void)sendRecordChangeNotification:(NSNotification *) notification{
//    
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//
//    [center postNotificationName:[NSString stringWithFormat:@"__%@__CHANGED", [self idHash]] object:self userInfo:@{@"store":[[self class]store]}];
//    
//}




//-(void)_setDirty{
//
//    
//    _dirty = true;
//    
//}


-(void)fill:(NSDictionary *)dict{
    
    //MMRelease(_values);
    
    //_values = [[NSMutableDictionary alloc] init];
    
    [_values removeAllObjects];
    
    NSEnumerator * e = [dict keyEnumerator];
    NSString * key = nil;
    while ( key = [e nextObject]) {

        [_values setObject:key forKey:[dict valueForKey:key]];
        
    }
    
    //[self loadRelations];

}

//
-(void)save:(NSError **)error completionBlock:( void (^)(MMRecord * record, BOOL success, NSError **))completionBlock{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^(){
        
        BOOL suc = [self save:&error];
        
        completionBlock(self, suc, error);
    }];
    
}



-(BOOL)save:(NSError **)error{
    
    BOOL suc = false;
    
    if (!_inserted) {

        if ([self valid:error] && [self validForUpdate:error]) {
            suc = [[[self class] store] executeCreateOnRecord:self withValues:_values error:error];
            [self sendOperationNotification:MMCrudOperationCreate forRecord:self onService:[[self class] store]];
        }
    
        if (suc) {
            _inserted = true;
        }
        
    }
    else{
        
        if ([self valid:error] && [self validForCreate:error]) {
            suc = [[[self class] store] executeUpdateOnRecord:self withValues:_values error:error];
            [self sendOperationNotification:MMCrudOperationUpdate forRecord:self onService:[[self class] store]];
        }
        
        //[self executeUpdateOnRecord:self withValues:_values error:error];
    
    }
    
    if (suc) {
        suc = [self _saveRelationships:error];
    }
    
    return suc;

}



-(void)push:(NSError **)error completionBlock:( void (^)(MMRecord * record, BOOL success, NSError **))completionBlock{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    
    [queue addOperationWithBlock:^(){
        
        BOOL suc = [self save:&error];
        
        completionBlock(self, suc, error);
    }];
    
}




-(BOOL)push:(NSError **)error{
    
    BOOL suc = false;
    
    if (!_inserted) {
        
        if ([self valid:error] && [self validForUpdate:error]) {
            suc = [[[self class] store] executeCreateOnRecord:self withValues:_values error:error];
        }
        
        if (suc) {
            _inserted = true;
        }
        
    }
    else{
        
        if ([self valid:error] && [self validForCreate:error]) {
            suc = [[[self class] store] executeUpdateOnRecord:self withValues:_values error:error];
        }
        
        //[self executeUpdateOnRecord:self withValues:_values error:error];
        
    }
    
    if (suc) {
        suc = [self _saveRelationships:error];
    }
    
    return suc;
    
}






-(BOOL)_saveRelationships:(NSError **)error{
    
    for (MMRelationshipSet * set in [_relationValues allValues]) {
        
        if ([set dirty]) {
  
            [set save:error];
            
        }
    
    }
    
    return YES;
    
}



-(BOOL)destroy:(NSError **)error completionBlock:(void (^)(MMRecord * record, BOOL success, NSError ** error))completionBlock{
    
    
    
    //if ([self valid:error] && [self validForCreate:error]) {
    //return [self executeDestroyForValues:_values error:error];
    return [[[self class] store] executeDestroyOnRecord:self withValues:_values error:error];
    
    //}
    
    
    
}

-(BOOL)destroy:(NSError **)error{
    

        
        //if ([self valid:error] && [self validForCreate:error]) {
    //return [self executeDestroyForValues:_values error:error];
    return [[[self class] store] executeDestroyOnRecord:self withValues:_values error:error];
    
    //}


    
}




//-(BOOL)destroy;


-(BOOL)valid:(NSError **)err{
    
    return true;

}

-(BOOL)validForUpdate:(NSError **)err{
    
    return true;

}

-(BOOL)validForCreate:(NSError **)err{
    
    return true;
    
}

+(MMSet *)attributes{
    
    return [[self entity] attributes];
    
}

+(MMEntity *)entity{
    
    MMEntity * entity = [[[self store] schema] entityForName:[self entityName]];
    
    return entity;
}

+(MMService *)store{
    
    return [MMService storeWithSchemaName:[self schemaName] version:nil];
    
}

+(NSString *)schemaName{
    
    
    [NSException raise:@"MMSchemaNameException" format:@"Record class %@ has no implementation for +schemaName.", NSStringFromClass(self)];
    
    //return @"noteit";
    return nil;
    
}

+(NSString *)entityName{
    
    
    [NSException raise:@"MMEntityNameException" format:@"Record class %@ has no implementation for entityName.", NSStringFromClass(self)];
    
    //return @"noteit";
    return nil;
}


#pragma mark persistence notifciations

-(void)sendOperationNotification:(MMCrudOperation)operation forRecord:(MMRecord *)record onService:(MMService *)service{
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    NSString * changeStr = [NSString stringWithFormat:@"MMRecordOperationNotification"];
    NSString * formalStr = [NSString stringWithFormat:@"MMEntityOperationNotification+%@", [[self class]entityName] ];
    
    NSNotification * notification = [NSNotification notificationWithName:changeStr object:self userInfo:@{
                                                                                                          @"operationName":MMStringFromCrudOperation(operation),
                                                                                                          @"operation":[NSNumber numberWithInteger:operation],
                                                                                                          @"classname":NSStringFromClass([self class])
                                                                                                          }];
    
    NSNotification * entitynotification = [NSNotification notificationWithName:changeStr object:self userInfo:@{
                                                                                                                @"operationName":MMStringFromCrudOperation(operation),
                                                                                                                @"operation":[NSNumber numberWithInteger:operation],
                                                                                                                @"classname":NSStringFromClass([self class])
                                                                                                                }];
    
    [center postNotification:notification];
    [center postNotification:entitynotification];
    
    
    //[NSNotification notificationWithName:@"MMRecordChangeNotification" object:self];
    //[NSNotification notificationWithName:@"MMRecordChangeNotification" object:self];
    
    
}


-(void)registerForRecordChangesWithTarget:(id)target selector:(SEL)aSelector{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:target selector:aSelector name:@"MMRecordOperationNotification" object:self];
    
    
}

+(void)registerForEntityChangesWithTarget:(id)target selector:(SEL)aSelector{
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    NSString * formalStr = [NSString stringWithFormat:@"MMEntityOperationNotification+%@", [[self class]entityName] ];
    [center addObserver:target selector:aSelector name:formalStr object:nil];
    
}


#pragma mark MMRecordEntityConfiguration Protocol

+(NSDictionary *)metaForRecordEntity{
    
    return nil;
    
}


+(NSDictionary *)configureRecordEntityAttribute:(MMAttribute *)attribute fromProperty:(MMProperty *)prop{
    
    return nil;
    
}


+(MMStore *)cloud{
    
    return [MMCloud cloudWithSchemaName:[self schemaName] version:nil];
    
}

+(MMRequest *)newStoreRequest{
    
    //[[MMRequest alloc] initWithStore:[self store] classname:NSStringFromClass(self)];

    
    return [[self store] newRequestForClassname:NSStringFromClass(self)];
    
        //return MMAutorelease([[MMRequest alloc] initWithService:[self store] classname:NSStringFromClass(self)]);
    
}

+(MMRequest *)newCloudRequest{
    
    //[[MMRequest alloc] initWithStore:[self store] classname:NSStringFromClass(self)];
    
    return [[self cloud] newRequestForClassname:NSStringFromClass(self)];

        //return MMAutorelease([[MMRequest alloc] initWithService:[self cloud] classname:NSStringFromClass(self)]);
    
}


//-(void)revert{
//    
//    
//}

//-(void)cleanup{
//    
//    [_dirtyValues removeAllObjects];
//    
//}

//-(void)keyIsDirty:(NSString *)key{
//    
//    [_dirty setValue:[NSNumber numberWithBOOL:YES] forKey:key];
//    
//}

//-(BOOL)dirty{
//    
//    return [[dirty count] > 0];
//    
//}

//-(void)setDirtyForKey:(NSString *)key{
//    
//
//}

//-(void)setValue:(id)value forKey:(NSString *)key{
//    
//    //if (  ) {
//        
//    [_dirty setObject:value forKey:key];
//    
//    //}
//
//}

//-(void)setValue:(id)value forKey:(NSString *)path{
//    
//    [_dirtyValues setValue:value forKey:path];
//    
//}
//
//
//-(id)valueForKey:(NSString *)key{
//    
//    if ([_dirtyValues valueForKey:key] != nil) {
//        return [_dirtyValues valueForKey:key];
//    }
//    if ([_values valueForKey:key] != nil) {
//        id<NSCopying> copy = [[_values valueForKey:key]copy];
//        [_dirtyValues setValue:copy forKey:key];
//        return copy;
//    }
//    
//    return nil;
//}


//-(void)setValue:(id)value forKey:(NSString *)path{
//
//    [_dirtyValues setValue:value forKey:path];
//
//}
//
//
//-(id)valueForKey:(NSString *)key{
//
//    if ([_dirtyValues valueForKey:key] != nil) {
//        return [_dirtyValues valueForKey:key];
//    }
//    if ([_values valueForKey:key] != nil) {
//        id<NSCopying> copy = [[_values valueForKey:key]copy];
//        [_dirtyValues setValue:copy forKey:key];
//        return copy;
//    }
//
//    return nil;
//}

//-(BOOL)dirty{
//    
//    if([[_dirtyValues allValues]count] > 0){
//    
//        return YES;
//        
//    }
//    
//    return NO;
//    
//}


-(void)setPrimativeValue:(id)value forKey:(NSString *)key{
    @synchronized(_values){
        _values[key] = value;
    }
}


-(id)primativeValueForKey:(NSString *)key{
    @synchronized(_values){
        return _values[key];
    }
}






+(NSArray *)idKeys{
    
    NSArray * keys = nil;
    
    if ((keys = [[self entity] idKeys])) {
        
        MMDebug(@"idKEys : %@", keys);
        
        return keys;
    }
    
    return nil;
    
}

-(NSDictionary *)idValues{
    
    return [[self class] idValuesWithValues:_values];

}


+(NSDictionary *)idValuesWithValues:(NSDictionary *)values{
    
    NSArray * keys = [self idKeys];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    MMDebug(@"ID values: %@", values);
    
    for ( NSString * key in keys ) {
        if (values[key] != nil) {
            dict[key] = values[key];
        }
        else{
            dict[key] = [NSNull null];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
    
}


-(NSString *)idHash{
    
//    NSMutableArray * hashArray = [NSMutableArray array];
//    
//    [hashArray addObject:[[self class]schemaName]];
//    [hashArray addObject:[[self class]entityName]];
//    
//    [hashArray addObjectsFromArray:MMORMSortedValueArray([self idValues])];
//    
//    return MMORMIdentifierHash([self idValues]);

    return [[self class]idHashWithIdValues:[self idValues]];
    
}

+(NSString *)idHashWithIdValues:(NSDictionary *)idValues{
    
//    NSMutableArray * hashArray = [NSMutableArray array];
//    
//    [hashArray addObject:[[self class]schemaName]];
//    [hashArray addObject:[[self class]entityName]];
//    
//    [hashArray addObjectsFromArray:MMORMSortedValueArray(idValues)];

    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:idValues];
    
    [dict addEntriesFromDictionary:@{
                                     @"__schema":[[self class]schemaName],
                                     @"__entity":[[self class]entityName]
                                    }];
    
    return MMORMIdentifierHash(dict);
    
}


-(void)logValues{
    
    NSLog(@"values %@", _values);
    
}




//+(NSString *)arrayValueHash:(NSArray *)array
//{
//    
//    NSMutableString * keyHash = [NSMutableString stringWithString:@""];
//    
//    for (id<NSCopying> key in array) {
//        
//        NSString * hashString = [[NSNumber numberWithInteger:[((id<NSObject>)key) hash]] stringValue];
//        
//        [keyHash appendString:hashString];
//        
//    }
//    
//    return keyHash;
//}


/*
+(void)setCoreDataEntityName:(NSString ){
    
    
    
    
}
*/

-(void)_fetchAllRelationships:(NSString *)relationship{
    
    
    
    
    
}


-(MMRelationshipSet *)_fetchRelationshipSetWithRelationshipName:(NSString *)key{
    
    MMRelationship * relationship = [[[self class] entity] relationshipWithName:key];
    
    return [self _fetchRelationshipSetWithRelationship:relationship];
    
}


-(MMRelationshipSet *)_fetchRelationshipSetWithRelationship:(MMRelationship *)relationship{
    
    MMRelationshipSet * obj = [_relationValues objectForKey:relationship.name];
    
    if (!obj) {
        
        obj = [[[self class] store] buildRelationshipObjectWithRelationship:
               relationship record:self values:_values];
        
        [_relationValues setObject:obj forKey:relationship.name];
    }
    
    return obj;
    
}


/*
-(MMEntity *)entity{
    
    return [MMEntity registeredEntityWithName:[self coreDataEntityName]];
    
}


-(NSString *)coreDataEntityName{
    NSString * classname = NSStringFromClass([self class]);
    
    
    
    int i = 0;
    BOOL isUppercase = true;
    while(isUppercase == true && i < [classname length]){
        
        
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[classname characterAtIndex:i]];
        
        if (isUppercase == false && (i - 1) >= 0 && (i - 1) <  [classname length]) {
            
            return [classname substringFromIndex:(i-1)];
            
        }
        ++i;
        
        
    }
    
    
    return nil;
}
 
 
 


-(NSEntityDescription *)coreDataEntityDescription:(NSManagedObjectContext *)context{
    
    if (context == nil) {
        context = [MMCoreData managedObjectContext];
    }
    
    MMLog(@"%@", [self coreDataEntityName]);
    
    return [NSEntityDescription entityForName:[self coreDataEntityName] inManagedObjectContext:context];
    
    
}

-(NSDictionary *)uniqueIndex{
    
    NSArray * keys =[[self entity] uniqueIndex];
    
    NSMutableDictionary * ret = [NSMutableDictionary dictionary];
    
    for (NSString * key in keys) {
        [self valueForKey:key];
        [ret setValue:[self valueForKey:key] forKey:key];
        
        
    }
    
    return [NSDictionary dictionaryWithDictionary:ret];
}
*/

//-(void)setValue:(id)value forKey:(NSString *)path{
//    
//    [self willChangeValueForKey:path];
//
//    _dirty = YES;
//    
//    [_values setValue:value forKey:path];
//    
//    [self didChangeValueForKey:path];
//    
//}
//
//
//-(id)valueForKey:(NSString *)key{
//    
//    //    if ([_dirtyValues valueForKey:key] != nil) {
//    //        return [_dirtyValues valueForKey:key];
//    //    }
//    //    if ([_values valueForKey:key] != nil) {
//    //        id<NSCopying> copy = [[_values valueForKey:key]copy];
//    //        [_dirtyValues setValue:copy forKey:key];
//    //        return copy;
//    //    }
//    
//    return [_values valueForKey:key];
//    
//    return nil;
//}


-(void)recacheActiveStore{
    
    [MMService addRecordToActiveRecords:self];
    
}




+(BOOL)resolveInstanceMethod:(SEL)aSEL {
    
    NSMutableString * key = [NSStringFromSelector(aSEL) mutableCopy];
    MMAttribute * attr = [[self entity] attributeWithName:key];
    MMRelationship * rel = [[self entity] relationshipWithName:key];

    
    
    BOOL setter = NO;
    
    if ([key hasPrefix:@"set"]) {

    
        [key deleteCharactersInRange:NSMakeRange(0, 3)];
        [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
        NSString *firstChar = [key substringToIndex:1];
        [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
        attr = [[self entity] attributeWithName:key];
        rel = [[self entity] relationshipWithName:key];
        
        
        if (attr || rel) {
            setter = YES;
        }
        
        
        
    }
    
    if (attr == nil && rel == nil) {
//        NSException * e = [NSException exceptionWithName:@"InvalidPropertyNameException" reason:[NSString stringWithFormat:@"The class %@ does not implement the selector %@ either dynamically or conventionally.",NSStringFromClass([self class]) ,NSStringFromSelector(aSEL) ] userInfo:@{}];
//        
//        @throw e;

        return false;
    
    }
    

    
    MMDebug(@"blah sel %@", NSStringFromSelector(aSEL));
    
    NSString * type = getPropertyTypeName([self class], key);
    
    
    if (rel != nil) {
        if (setter) {
            class_addMethod([self class], aSEL, (IMP)setRelationValueIMP, "v@:@");
        } else {
            class_addMethod([self class], aSEL,(IMP)relationValueIMP, "@@:");
        }
        return YES;
    }
    
    if (attr != nil) {
        if (setter) {
            if ([type isEqualToString:@"int"]) {
                class_addMethod([self class], aSEL, (IMP)setValueIntIMP, "v@:@");
            }
            else if ([type isEqualToString:@"BOOL"]) {
                class_addMethod([self class], aSEL, (IMP)setValueBoolIMP, "v@:@");
            }
            else if ([type isEqualToString:@"float"]) {
                class_addMethod([self class], aSEL, (IMP)setValueFloatIMP, "v@:@");
            }
            else if ([type isEqualToString:@"double"]) {
                class_addMethod([self class], aSEL, (IMP)setValueDoubleIMP, "v@:@");
            }
            else if ([type isEqualToString:@"long"]) {
                class_addMethod([self class], aSEL, (IMP)setValueLongIMP, "v@:@");
            }
            else if ([type isEqualToString:@"char"]) {
                class_addMethod([self class], aSEL, (IMP)setValueCharIMP, "v@:@");
            }
            else{
                class_addMethod([self class], aSEL, (IMP)setValueIMP, "v@:@");
            }
        } else {
                //class_addMethod([self class], aSEL,(IMP)valueIMP, "@@:");
            
            
            if ([type isEqualToString:@"int"]) {
                class_addMethod([self class], aSEL, (IMP)valueIntIMP, "v@:@");
            }
            else if ([type isEqualToString:@"BOOL"]) {
                class_addMethod([self class], aSEL, (IMP)valueBoolIMP, "v@:@");
            }
            else if ([type isEqualToString:@"float"]) {
                class_addMethod([self class], aSEL, (IMP)valueFloatIMP, "v@:@");
            }
            else if ([type isEqualToString:@"double"]) {
                class_addMethod([self class], aSEL, (IMP)valueDoubleIMP, "v@:@");
            }
            else if ([type isEqualToString:@"long"]) {
                class_addMethod([self class], aSEL, (IMP)valueLongIMP, "v@:@");
            }
            else if ([type isEqualToString:@"char"]) {
                class_addMethod([self class], aSEL, (IMP)valueCharIMP, "v@:@");
            }
            else{
                class_addMethod([self class], aSEL, (IMP)valueIMP, "v@:@");
            }
                
        }
        return YES;
    }

    
    //introspect properties, attributes...
//    if ([NSStringFromSelector(aSEL) hasPrefix:@"set"]) {
//        class_addMethod([self class], aSEL, (IMP)setValueIMP, "v@:@");
//    } else {
//        class_addMethod([self class], aSEL,(IMP)valueIMP, "@@:");
//    }
    return NO;
}




@end

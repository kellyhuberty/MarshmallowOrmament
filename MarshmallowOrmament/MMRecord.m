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
#import "MMOrmManager.h"

static void setValueIMP(id self, SEL _cmd, id aValue);

@interface MMRecord(){
    
    NSString * _queueReference;
    
}
-(void)dispatchWriteBlock:(void (^)())syncBlock;
-(void)dispatchReadBlock:(void (^)())syncBlock;


-(MMRelationshipSet *)_fetchRelationshipSetWithRelationshipName:(NSString *)relationshipName;
-(MMRelationshipSet *)_fetchRelationshipSetWithRelationship:(MMRelationship *)relationship;


@property(nonatomic)dispatch_queue_t queue;
@end



// generic getter
id valueIMP(id self, SEL _cmd) {

    id __block value;
    [(MMRecord *)self dispatchReadBlock:^(){

        //[self willAccessValueForKey:NSStringFromSelector(_cmd)];
        Ivar ivar = class_getInstanceVariable([self class], "_values");
        //[self didAccessValueForKey:NSStringFromSelector(_cmd)];
        value = [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];
        
        if (value == [NSNull null]) {
            value = nil;
        }
    }];
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
    
    [(MMRecord *)self dispatchWriteBlock:^(){
    
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
        //key = [key stringByReplacingCharactersInRange:NSMakeRange([key length] - 1, 1) withString:@""];
        key = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *firstChar = [key substringToIndex:1];
        key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];

        
        
        
        [self willChangeValueForKey:key];
        
        
        
        Ivar ivar = class_getInstanceVariable([self class], "_values");
        
        NSMutableDictionary * dict = ((NSMutableDictionary *)object_getIvar(self, ivar));
        
        [self dispatchWriteBlock:^(){
            [dict setObject:(value) forKey:key];
            ((MMRecord *)self).dirty = true;
        }];
        
        
        //void * dirty;
        //object_getInstanceVariable([self class], "_dirty", &dirty);
        
        
        
        
        [self didChangeValueForKey:key];

    }];
}



// generic getter
id relationValueIMP(id self, SEL _cmd) {
    
    //NSString * key = cleanSelectorIntoKeyName();
    
    //Ivar ivar = class_getInstanceVariable([self class], "_relationValues");
    //id obj = [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];

    MMEntity * entity = (MMEntity *)[[((MMRecord *)self) class] entity];
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
    
    MMRelationshipSet * __block obj = nil;
    
    
    [self dispatchReadBlock:^(){
        obj = [(MMRecord *)self _fetchRelationshipSetWithRelationship:relationship];

        
        if (!relationship.hasMany) {
            
            if ([obj count] > 0){
                
                obj = obj[0];
                
            }
            else{
                obj = nil;
            }
        
        }
    }];
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
    
    MMEntity * entity = (MMEntity *)[[((MMRecord *)self) class] entity];
    MMRelationship * relationship = [entity relationshipWithName:key];
    
    [self dispatchWriteBlock:^(){
        
        if (!relationship.hasMany) {
            
            [self willChangeValueForKey:key];

            id obj = [self _fetchRelationshipSetWithRelationshipName:key];

            [obj removeAllObjects];

            if (aValue != nil) {
                [obj addObject:aValue];
            }
        
            [self didChangeValueForKey:key];
            
            return;
        }
            
            
        
        [NSException raise:@"MMInvalidRelationshipSaveContext" format:@"You can't directly save a hasMany relationship by property assignment. Please use addObjects: or removeObjects:, or other NSMutableArray mutator methods."];
            
    }];
        
}


const char * queueReferenceKey = "queueReferenceKey";




@implementation MMRecord

//@synthesize mmEntity = _entity;
//@synthesize mmService = _service;
//@synthesize mmEntity = _values;

-(instancetype)initWithValues:(NSDictionary *)values{
    
    //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [self init];
    
    if (self != nil) {
        _inserted = NO;
        [self dispatchWriteBlock:^(){
            [_values addEntriesFromDictionary:values];
        }];
            //[self registerNotificationHash];
        
        MMDebug(@"values %@", values);
    }
    
    return self;
}

-(instancetype)initWithFillValues:(NSDictionary *)values created:(BOOL)inserted fromStore:(MMService *)store{
    
    //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [self init];
    
    if (self != nil) {
        [self dispatchWriteBlock:^(){
            _inserted = inserted;
            [_values addEntriesFromDictionary:values];
        }];
    }
    
    return self;
}


-(instancetype)init{
    
        //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [super init];
    
    if (self != nil) {
        
        _values = [[NSMutableDictionary alloc]init];
        _relationValues = [[NSMutableDictionary alloc]init];

        _queueReference = [NSString stringWithFormat:@"MMRecordQueue-%@", [[NSUUID UUID] UUIDString]];
        char const * recordQueueUUID = [_queueReference UTF8String];

        _queue = dispatch_queue_create( recordQueueUUID  , NULL);
        
        dispatch_queue_set_specific(_queue, queueReferenceKey, (__bridge void * _Nullable)(_queueReference), nil);

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

-(void)fill:(NSDictionary *)dict{
    
    [_values removeAllObjects];
    
    NSEnumerator * e = [dict keyEnumerator];
    NSString * key = nil;
    while ( key = [e nextObject]) {
        [_values setObject:key forKey:[dict valueForKey:key]];
    }
    
}

-(BOOL)save{
    
    BOOL suc = false;
    
    NSError * error;
    
    suc = [self save:&error];
    
    if (!suc) {
        NSLog(@"MMLog save error: %@", [error localizedDescription]);
    }
    
    return suc;
    
}

-(void)save:(NSError **)error completionBlock:( void (^)(MMRecord * record, BOOL success, NSError **))completionBlock{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^(){
        
        BOOL suc = [self save:error];
        
        completionBlock(self, suc, error);
    }];
    
}

-(BOOL)save:(NSError **)error{
    
    BOOL __block suc = false;
    
    [self dispatchWriteBlock:^(){
        
        if (!_inserted) {

            if ([self valid:error] && [self validForUpdate:error]) {
                suc = [[[self class] store] executeCreateOnRecord:self withValues:_values error:error];
                [self sendOperationNotification:MMCrudOperationCreate forRecord:self onService:[[self class] store]];
            }
        
            if (suc) {
                _inserted = true;
                [self scheduleCloudCreate];
            }
            
        }
        else{
            
            if ([self valid:error] && [self validForCreate:error]) {
                suc = [[[self class] store] executeUpdateOnRecord:self withValues:_values error:error];
                [self sendOperationNotification:MMCrudOperationUpdate forRecord:self onService:[[self class] store]];
            }
            
            if (suc) {
                [self scheduleCloudUpdate];
            }
            
        }
        
        if (suc) {
            suc = [self _saveRelationships:error];
        }
        
    }];
        
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

-(void)destroy:(NSError **)error completionBlock:(void (^)(MMRecord * record, BOOL success, NSError ** error))completionBlock{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^(){
        
        BOOL suc = [self destroy:error];
        
        completionBlock(self, suc, error);
    }];
}

-(BOOL)destroy:(NSError **)error{
    BOOL suc = false;
    if ([self valid:error] && [self validForDestroy:error]) {
        suc = [[[self class] store] executeDestroyOnRecord:self withValues:_values error:error];
    }
    if (suc) {
        [self scheduleCloudDestroy];
    }
    return suc;
}

-(BOOL)destroy{
    
    return [self destroy:nil];
    
}

-(BOOL)valid:(NSError **)err{
    
    return true;

}

-(BOOL)validForUpdate:(NSError **)err{
    
    return true;

}

-(BOOL)validForCreate:(NSError **)err{
    
    return true;
    
}

-(BOOL)validForDestroy:(NSError **)err{
    
    return true;
    
}

-(void)scheduleCloudUpdate{
    
    [[self class]cloud];
    
}

-(void)scheduleCloudCreate{
    
    [[self class]cloud];

}

-(void)scheduleCloudDestroy{
    
    [[self class]cloud];

}


+(MMSet *)attributes{
    
    return [[self entity] attributes];
    
}

+(MMEntity *)entity{
    
    MMEntity * entity = [[[self store] schema] entityForName:[self entityName]];
    
    return entity;
}

+(MMService *)store{
    
    MMStore * store = (MMStore *)[[MMOrmManager manager] serviceWithType:@"store" schemaName:[self schemaName]];
    
    return store;
}

+(MMSchema *)schema{
    
    return [MMSchema registeredSchemaWithName:[self schemaName]];
    
}

+(NSString *)schemaName{
    
    NSLog(@"[WARNING]:Record class %@ has no implementation for +schemaName.", NSStringFromClass(self));
    [NSException raise:@"MMSchemaNameException" format:@"Record class %@ has no implementation for +schemaName.", NSStringFromClass(self)];
    
    return nil;
    
}

+(NSString *)entityName{
    
    NSLog(@"[WARNING]:Record class %@ has no implementation for +entityName.", NSStringFromClass(self));
    [NSException raise:@"MMEntityNameException" format:@"Record class %@ has no implementation for entityName.", NSStringFromClass(self)];
    
    return nil;
}


#pragma mark persistence notifciations

-(void)sendOperationNotification:(MMCrudOperation)operation forRecord:(MMRecord *)record onService:(MMService *)service{
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    NSString * changeStr = [NSString stringWithFormat:@"MMRecordOperationNotification"];
    
    //Might be used later for entity level notifications
    //NSString * formalStr = [NSString stringWithFormat:@"MMEntityOperationNotification+%@", [[self class]entityName] ];
    
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


+(void)configureRecordEntityAttribute:(MMAttribute *)attribute fromProperty:(MMProperty *)prop{
    
    //return nil;
    
}


+(MMService *)cloud{
    
    return [MMCloud cloudWithSchemaName:[self schemaName] version:nil];
    
}

+(MMRequest *)newStoreRequest{
    
    return [[self store] newRequestForClassname:NSStringFromClass(self)];

}

+(MMRequest *)newCloudRequest{
    
    return [[self cloud] newRequestForClassname:NSStringFromClass(self)];
    
}


+(MMRelationship *)createRelationshipNamed:(NSString *)name toRecordClass:(Class)recordClass hasMany:(BOOL)hasMany storeRelator:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelater{

    NSString * relatedEntityName = nil;
    if ([recordClass respondsToSelector:@selector(entityName)]) {
        relatedEntityName = [recordClass entityName];
    }
    
    NSAssert(relatedEntityName, @"Class [%@] does not conform to entityName", NSStringFromClass(recordClass));
    
    return [MMRelationship relationshipWithName:name
                                localEntityName:[self entityName]
                                     localClass:[self class]
                                        hasMany:hasMany
                            ofRelatedEntityName:relatedEntityName
                                   relatedClass:recordClass
                                   storeRelater:storeRelator
                                   cloudRelater:cloudRelater];
    
}

-(void)setPrimativeValue:(id)value forKey:(NSString *)key{
    [self dispatchWriteBlock:^(){
        _values[key] = value;
    }];
}

-(id)primativeValueForKey:(NSString *)key{
    id __block primativeValue= nil;
    [self dispatchReadBlock:^(){
         primativeValue = _values[key];
    }];
    return primativeValue;
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
    
    //MMDebug(@"ID values: %@", values);
    
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

    return [[self class]idHashWithIdValues:[self idValues]];
    
}

+(NSString *)idHashWithIdValues:(NSDictionary *)idValues{

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

-(void)_fetchAllRelationships:(NSString *)relationship{
    
    
    
    
    
}

//Used to determine if class should be autoloaded as an entity. Return false for an abstract class.
+(BOOL)shouldAutoloadClassAsEntity{
    
    return YES;
    
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


-(id)valueForKey:(NSString *)key{
    
    MMEntity * entity = [[self class] entity];
    
    MMAttribute * attr = [entity attributeWithName:key];
    MMRelationship * rel = [entity relationshipWithName:key];
    
    if (attr == nil && rel == nil) {
        
        [super valueForKey:key];
        
    }
    
    return valueIMP(self, NSSelectorFromString(key));
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    MMEntity * entity = [[self class] entity];
    
    MMAttribute * attr = [entity attributeWithName:key];
    MMRelationship * rel = [entity relationshipWithName:key];
    
    if (attr == nil && rel == nil) {
        
        [super setValue:value forKey:key];
        
    }
    
    NSString *firstChar = [key substringToIndex:1];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstChar uppercaseString]];
    
    return setValueIMP(self, NSSelectorFromString([NSString stringWithFormat:@"set%@", key]), value);
    
}


-(void)recacheActiveStore{
    
    [MMService addRecordToActiveRecords:self];
    
}



-(NSString *)description{
    
    NSDictionary * __block values = nil;
    
    [self dispatchReadBlock:^() {
        values = [_values copy];
    }];
    
    return [NSString stringWithFormat:@"%@ \nvalues:\n %@", [super description], _values];
    
}

-(void)dispatchWriteBlock:(void (^)())syncBlock{
 
    [self dispatchBlock:syncBlock];
    
}

-(void)dispatchReadBlock:(void (^)())syncBlock{

    [self dispatchBlock:syncBlock];

}

-(void)dispatchBlock:(void (^)())syncBlock{
    
    NSString * queueIdentifierString = (__bridge NSString *)(dispatch_queue_get_specific(_queue, queueReferenceKey));

    if([queueIdentifierString isEqualToString:_queueReference]){
        syncBlock();
    }else{
        dispatch_barrier_sync(_queue, ^(){
            syncBlock();
        });
    }
    
}

+(BOOL)resolveInstanceMethod:(SEL)aSEL {
    
    
    MMEntity * entity = [self entity];
    
    
    NSString * selectorName = NSStringFromSelector(aSEL);
    
    //NSMutableString * key = [NSStringFromSelector(aSEL) mutableCopy];
    MMAttribute * attr = nil;
    MMRelationship * rel = nil;
    NSString * propertyName = nil;

    
    BOOL setter = NO;
    
    //entity retrieve
    //test for getter
    if ( (attr = [entity attributeWithGetterSelectorName:selectorName]) ){
        setter = NO;
        propertyName = attr.name;
    }
    else if ( (attr = [entity attributeWithSetterSelectorName:selectorName]) ){
        setter = YES;
        propertyName = attr.name;
    }
    else if ( (rel = [entity relationshipWithGetterSelectorName:selectorName]) ){
        setter = NO;
        propertyName = rel.name;
    }
    else if ( (rel = [entity relationshipWithSetterSelectorName:selectorName]) ){
        setter = YES;
        propertyName = rel.name;
    }
    
    
    if (attr == nil && rel == nil) {
        MMDebug(@"The class %@ does not implement the selector %@ either dynamically or conventionally.",NSStringFromClass([self class]) ,NSStringFromSelector(aSEL));
        return [super resolveInstanceMethod:aSEL];
    }
    

    
    MMDebug(@"blah sel %@", NSStringFromSelector(aSEL));
    
    NSString * type = getPropertyTypeName([self class], propertyName);
    
    
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

    return [super resolveInstanceMethod:aSEL];
}


@end

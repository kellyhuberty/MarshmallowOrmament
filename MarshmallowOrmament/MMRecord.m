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
#import "MMStore.h"

#import "MMSet.h"

#import "MMORMUtility.h"

#import "MMRequest.h"

#import <objc/runtime.h>

// generic getter
id valueIMP(id self, SEL _cmd) {
    
    
    Ivar ivar = class_getInstanceVariable([self class], "_values");
    return [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];

}


// generic setter
static void setValueIMP(id self, SEL _cmd, id aValue) {
    
    id value = [aValue copy];
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    NSLog(@"settingggg");
    
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    
    
    [self willChangeValueForKey:key];
    
    
    
    Ivar ivar = class_getInstanceVariable([self class], "_values");
    [((NSMutableDictionary *)object_getIvar(self, ivar)) setObject:(value) forKey:key];

    
    [self didChangeValueForKey:key];

}



// generic getter
id relationValueIMP(id self, SEL _cmd) {
    
    //NSString * key = cleanSelectorIntoKeyName();
    
    Ivar ivar = class_getInstanceVariable([self class], "_relationValues");
    id obj = [((NSMutableDictionary *)object_getIvar(self, ivar)) objectForKey:NSStringFromSelector(_cmd)];
    
    if (!obj) {
        
        MMStore * store = [[((MMRecord *)self) class] store];
        MMEntity * entity = [[((MMRecord *)self) class] entity];
        MMRelationship * relationship = [entity relationshipWithName:NSStringFromSelector(_cmd)];
        Ivar ivar = class_getInstanceVariable([self class], "_values");
        
        
        obj = [store buildRelationshipObjectWithRelationship:
               relationship record:((MMRecord *)self) values:((NSMutableDictionary *)object_getIvar(self, ivar))];
        
        [((NSMutableDictionary *)object_getIvar(self, ivar)) setObject:obj forKey:NSStringFromSelector(_cmd)];
    }
    
    
    return obj;
}


// generic setter
static void setRelationValueIMP(id self, SEL _cmd, id aValue) {
    
    id value = [aValue copy];
    NSMutableString *key = [NSStringFromSelector(_cmd) mutableCopy];
    
    NSLog(@"settingggg");
    
    // delete "set" and ":" and lowercase first letter
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    [key deleteCharactersInRange:NSMakeRange([key length] - 1, 1)];
    NSString *firstChar = [key substringToIndex:1];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:[firstChar lowercaseString]];
    
    
    
    [self willChangeValueForKey:key];
    
    
    
    Ivar ivar = class_getInstanceVariable([self class], "_values");
    [((NSMutableDictionary *)object_getIvar(self, ivar)) setObject:(value) forKey:key];
    
    
    [self didChangeValueForKey:key];
    
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

        [_values addEntriesFromDictionary:values];
        //[self registerNotificationHash];
        
        NSLog(@"values %@", values);
    }
    
    return self;
}

-(instancetype)initWithFillValues:(NSDictionary *)values created:(BOOL)inserted fromStore:(MMStore *)store{
    
    //self = [super initWithEntity:[self coreDataEntityDescription:nil] insertIntoManagedObjectContext:nil/*[MMCoreData managedObjectContext]*/];
    self = [self init];
    
    if (self != nil) {
        _inserted = YES;
        [_values addEntriesFromDictionary:values];
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
    
    return MMAutorelease([[[self class] alloc] init]);
    
    
    //return rec;
}

+(instancetype)create:(NSDictionary *)dictionary{
    
    MMRecord * rec = MMAutorelease([[[self class] alloc] initWithValues:dictionary]);

    NSError * error;
    
    [rec save:&error];
    
    return  rec;
    
}

-(void)registerNotificationHash{
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveRecordChangeNotification:) name:[NSString stringWithFormat:@"__%@__CHANGED", [self idHash]] object:self];
    
    
    
}

-(void)sendRecordChangeNotification:(NSNotification *) notification{
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];

    [center postNotificationName:[NSString stringWithFormat:@"__%@__CHANGED", [self idHash]] object:self userInfo:@{@"store":[[self class]store]}];
    
}

-(void)receiveRecordChangeNotification:(NSNotification *) notification{
    
    
    
}




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



-(BOOL)save:(NSError **)error{
    
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
    return suc;

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
    
    return [[[self store] schema] entityForName:[self entityName]];
    
}

+(MMStore *)store{
    
    return [MMStore storeWithSchemaName:[self schemaName] version:nil];
    
}

+(MMRequest *)newRequest{
    
    //[[MMRequest alloc] initWithStore:[self store] classname:NSStringFromClass(self)];

    
    return MMAutorelease([[MMRequest alloc] initWithStore:[self store] classname:NSStringFromClass(self)]);
    
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

+(NSArray *)idKeys{
    
    return [[self entity] idKeys];
    
}

-(NSDictionary *)idValues{
    
    NSArray * keys = [[self class] idKeys];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    for ( NSString * key in keys ) {
        
        dict[key] = _values[key];
        
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
    
}

-(NSString *)idHash{
    
    NSMutableArray * hashArray = [NSMutableArray array];
    
    [hashArray addObject:[[self class]schemaName]];
    [hashArray addObject:[[self class]entityName]];
    
    [hashArray addObjectsFromArray:MMORMSortedValueArray([self idValues])];
    
    return MMORMIdentifierHash([self idValues]);
    
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
        
        
        if (attr) {
            setter = YES;
        }
        
        
        
    }
    
    
    // NSLog(@"blah __attribute %@", attr);
    
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
            class_addMethod([self class], aSEL, (IMP)setValueIMP, "v@:@");
        } else {
            class_addMethod([self class], aSEL,(IMP)valueIMP, "@@:");
        }
        return YES;
    }

    
    //introspect properties, attributes...
    if ([NSStringFromSelector(aSEL) hasPrefix:@"set"]) {
        class_addMethod([self class], aSEL, (IMP)setValueIMP, "v@:@");
    } else {
        class_addMethod([self class], aSEL,(IMP)valueIMP, "@@:");
    }
    return NO;
}


@end

//
//  MMRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRelationship.h"
#import "MMService.h"
#import "MMSet.h"
#import "MMRelation.h"
#import "MMRelater.h"
#import "MMUtility.h"

@implementation MMRelationship


//+(MMStore *)store{
//    
////    return [MMStore storeWithSchemaName:[self schemaName] version:nil];
//    
//}

//
//-(MMRelationship *)setNextRelation:(MMRelationship *)next{
//    
//    
//    next.lastRelation = self
//    _nextRelation = MMRetain(next);
//    
//}


+(instancetype)relationshipWithDictionary:(NSDictionary *)dict{
    
    return [[[self class] alloc] initWithDictionary:dict];
    
}



//+(instancetype)hasManyRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
//    
//    return [[[self class] alloc] initWithSchema:<#(MMSchema *)#>];
//
//    
//    
//}
//
//
//+(instancetype)hasOneRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
//    
//    
//    
//    
//    
//}



//-(id)init{
//    NSAssert(false, @"%@ can not be instantiated with init. Use initWithSchema:", NSStringFromClass([self class]));
//    return nil;
//}
//
//-(id)initWithDictionary:(NSDictionary *)dict{
//    NSAssert(false, @"%@ can not be instantiated with initWithDictionary:. Use initWithDictionary:schema:", NSStringFromClass([self class]));
//    return nil;
//}

-(id)initWithDictionary:(NSDictionary *)dict{
    
    //    NSArray * arr = [dict allKeys];
    //
    //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];
    //
    //    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
    //
    
    if(self = [self init]){
        
        NSError * error;
        
        [self loadFromDictionary:dict error:&error];
        
        [self loadMetaFromDictionary:dict error:&error];
        
        
    }
    
    return self;
    
}


+(instancetype)relationshipWithName:(NSString *)name localEntityName:(NSString *)localEntityName localClass:(Class)localClass    hasMany:(BOOL)hasMany ofRelatedEntityName:(NSString *)relatedEntityName relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
    
    return [[[self class]alloc] initWithName:name localEntityName:localEntityName localClass:localClass hasMany:hasMany ofRelatedEntityName:relatedEntityName relatedClass:relatedClass storeRelater:storeRelator cloudRelater:cloudRelator];
    
}

-(instancetype)initWithName:(NSString *)name localEntityName:(NSString *)localEntityName localClass:(Class)localClass hasMany:(BOOL)hasMany ofRelatedEntityName:(NSString *)relatedEntityName relatedClass:(__unsafe_unretained Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
    
    if (self = [self init]) {
        
        _name = name;
        _localEntityName = localEntityName;
        _localClassName = NSStringFromClass(localClass);
        _hasMany = hasMany;
        _relatedEntityName = relatedEntityName;
        self.storeRelater = storeRelator;
        self.cloudRelater = cloudRelator;
        _relatedClassName = NSStringFromClass(relatedClass);
        
    }
    
    return self;
}


-(instancetype)init{
    
    if(self = [super init]){
        _hasMany = YES;
        _autoRelate = NO;

    }
    
    return self;
    
}

-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
    
    NSArray * relations;

    _name = [dict[@"name"] copy];
    
    if (dict[@"hasMany"]) {
        
        _hasMany = [dict[@"hasMany"] boolValue];
        
    }
    if (dict[@"shareable"]) {
        
        _shareable = [dict[@"shareable"] boolValue];
        
    }
    if (dict[@"autoRelate"]) {
        
        _autoRelate = [dict[@"autoRelate"] boolValue];
        
    }
    if (dict[@"autoRelateName"]) {
        
        _autoRelateName = [dict[@"autoRelateName"] copy];
        
    }
    
    _relatedClassName = [dict[@"className"] copy];
    _relatedEntityName = [dict[@"entityName"] copy];

    if (!_relatedEntityName) {
        _relatedEntityName = [[NSClassFromString(_relatedClassName) entityName]copy];
    }
        
    
    return YES;
    
}



-(void)log{
    
    MMLog(@"                ");
    
    MMLog(@"            name:%@", _name);
    MMLog(@"            classname: %@", _relatedClassName);
    MMLog(@"            classname: %@", _relatedEntityName);
    
}


-(BOOL)onSelf{
    
    return [_relatedEntityName isEqualToString:_localEntityName];
    
}


-(NSNumber *)autoRelateNumber{
    
    return [NSNumber numberWithBool:_autoRelate];
    
}


-(void)setCloudRelater:(MMRelater *)cloudRelater{
    
    cloudRelater.relationship = self;
    _cloudRelater = cloudRelater;
    
}

-(void)setStoreRelater:(MMRelater *)storeRelater{
    
    storeRelater.relationship = self;
    _storeRelater = storeRelater;
    
}


-(Class)localClass{
    
    return NSClassFromString(self.localClassName);
    
}

-(Class)relatedClass{
    
    return NSClassFromString(self.relatedClassName);
    
}



@end

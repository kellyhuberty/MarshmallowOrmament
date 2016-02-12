//
//  MMRelationship.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMSchemaObject.h"
@class MMSet, MMSchemaObject, MMRelater, MMSchema, MMEntity;
@interface MMRelationship : MMSchemaObject{
    
    NSString * _name;
    //MMSet * _cloud;
    
    MMRelater * _cloudRelater;
    MMRelater * _storeRelater;
    
    BOOL _hasMany;
    BOOL _shareable;
    
    NSString * _className;
    NSString * _relatedEntityName;
    NSString * _localEntityName;
    
    
    
    
    
    BOOL _autoRelate;
    NSString * _autoRelateName;
    
}


@property(nonatomic, retain)MMSchema * schema;
@property(nonatomic, retain)NSString * localEntityName;
@property(nonatomic, retain)NSString * relatedEntityName;
@property(nonatomic, retain)NSString * className;
@property(nonatomic, retain)MMSet * links;
@property(nonatomic, retain)NSString * name;
@property(nonatomic) BOOL hasMany;
@property(nonatomic) BOOL autoRelate;
@property(nonatomic, readonly) NSNumber * autoRelateNumber;
@property(nonatomic) BOOL shareable;
@property(nonatomic, retain)NSString * autoRelateName;
@property(nonatomic, retain)MMRelater * cloudRelater;
@property(nonatomic, retain)MMRelater * storeRelater;






+(instancetype)relationshipWithDictionary:(NSDictionary *)dict;
+(instancetype)relationshipWithDictionary:(NSDictionary *)dict schema:(MMSchema *)schema;

+(instancetype)relationshipWithName:(NSString *)name schemaName:(NSString *)schemaName localEntityName:(NSString *)localEntityName relatedEntityName:(NSString *)relatedEntityName storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

-(instancetype)initWithName:(NSString *)name schemaName:(NSString *)schemaName localEntityName:(NSString *)localEntityName relatedEntityName:(NSString *)relatedEntityName storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

//+(instancetype)hasManyRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;
//+(instancetype)hasOneRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

-(NSArray *)allLinks;
-(void)addAllLinks:(NSArray *)links;
-(void)log;


-(BOOL)onSelf;


-(MMEntity *)localEntity;
-(MMEntity *)relatedEntity;

@end

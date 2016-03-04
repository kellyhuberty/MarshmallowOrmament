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
    
    MMRelater * _cloudRelater;
    MMRelater * _storeRelater;
    
    BOOL _hasMany;
    BOOL _shareable;
    
    NSString * _relatedClassName;
    NSString * _relatedEntityName;
    NSString * _localEntityName;
    

    BOOL _autoRelate;
    NSString * _autoRelateName;
    
}


@property(nonatomic, retain)NSString * localEntityName;
@property(nonatomic, retain)NSString * localClassName;
@property(nonatomic, retain)NSString * relatedEntityName;
@property(nonatomic, retain)NSString * relatedClassName;
@property(nonatomic, retain)NSString * name;
@property(nonatomic) BOOL hasMany;
@property(nonatomic, readonly) NSNumber * autoRelateNumber;
@property(nonatomic) BOOL shareable;
@property(nonatomic, retain)MMRelater * cloudRelater;
@property(nonatomic, retain)MMRelater * storeRelater;


@property(nonatomic) BOOL autoRelate DEPRECATED_ATTRIBUTE;
@property(nonatomic, retain)NSString * autoRelateName DEPRECATED_ATTRIBUTE;




+(instancetype)relationshipWithDictionary:(NSDictionary *)dict;

+(instancetype)relationshipWithName:(NSString *)name localEntityName:(NSString *)localEntityName localClass:(Class)localClass hasMany:(BOOL)hasMany ofRelatedEntityName:(NSString *)relatedEntityName relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

-(instancetype)initWithName:(NSString *)name localEntityName:(NSString *)localEntityName localClass:(Class)localClass hasMany:(BOOL)hasMany ofRelatedEntityName:(NSString *)relatedEntityName relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

//+(instancetype)hasManyRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;
//+(instancetype)hasOneRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator;

-(NSArray *)allLinks;
-(void)addAllLinks:(NSArray *)links;
-(void)log;


-(BOOL)onSelf;


-(MMEntity *)localEntity;
-(MMEntity *)relatedEntity;

@end

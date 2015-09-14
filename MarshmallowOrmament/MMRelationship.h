//
//  MMRelationship.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSet.h"
#import "MMRelation.h"
#import "MMSchemaObject.h"
#import "MMRelater.h"

@interface MMRelationship : MMSchemaObject{
    
    NSString * _name;
    //MMSet * _cloud;
    
    MMRelater * _cloudRelater;
    MMRelater * _storeRelater;
    
    BOOL _hasMany;
    BOOL _shareable;
    
    NSString * _className;
    NSString * _entityName;
    NSString * _recordEntityName;
    
    BOOL _autoRelate;
    NSString * _autoRelateName;
    
}



@property(nonatomic, retain)NSString * recordEntityName;
@property(nonatomic, retain)NSString * entityName;
@property(nonatomic, retain)NSString * className;
@property(nonatomic, retain)MMSet * links;
@property(nonatomic, retain)NSString * name;
@property(nonatomic) BOOL hasMany;
//@property(nonatomic) BOOL autoRelate;
@property(nonatomic, readonly) NSNumber * autoRelateNumber;
@property(nonatomic) BOOL shareable;
@property(nonatomic, retain)NSString * autoRelateName;
@property(nonatomic, retain)MMRelater * cloudRelater;
@property(nonatomic, retain)MMRelater * storeRelater;

+(instancetype)relationshipWithDictionary:(NSDictionary *)dict;
-(NSArray *)allLinks;
-(void)addAllLinks:(NSArray *)links;
-(void)log;


-(BOOL)onSelf;

@end

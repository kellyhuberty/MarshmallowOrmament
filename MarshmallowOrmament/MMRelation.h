//
//  MMRelationLink.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/24/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : int {
    MMRelationForeignKeyOnSelf,
    MMRelationForeignKeyOnRef,
} MMRelationForeignKeyWriteType;

@interface MMRelation : NSObject{
    
    NSString * _entityName;
    NSString * _key;
    
    NSString * _referencingEntityName;
    NSString * _referencingKey;
    
    MMRelationForeignKeyWriteType _foreignKeyType;
    
}
@property (nonatomic, copy)NSString * entityName;
@property (nonatomic, copy)NSString * key;
@property (nonatomic, copy)NSString * referencingEntityName;
@property (nonatomic, copy)NSString * referencingKey;

@property (nonatomic)MMRelationForeignKeyWriteType foreignKeyType;


+(MMRelation *)relationWithDictionary:(NSDictionary *)dict;
+(MMRelation *)relationWithRelationFormat:(NSString *)format;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithRelationFormat:(NSString *)format;

@end

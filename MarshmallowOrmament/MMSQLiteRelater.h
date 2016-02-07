//
//  MMSQLiteRelationship.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/16/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMRelationship.h"
#import "MMRelater.h"
#import "MMSQLiteJoin.h"
@class MMRecord;
@class MMService;
@class MMEntity;
//#import "MMSQLiteMutation.h"


//NSString * const MMSQLiteRelator = @""
//NSString * const MMSQLiteRelationship = @""

/*

ForeignKeyColumnName
 
UniqueKeyOnRecordTableOverride
UniqueKeyOnRelatedTableOverride

*/
typedef NS_ENUM(NSUInteger, MMSQLiteEntityType) {
    MMSQLiteTargetType,
    MMSQLiteRelatedType
};

typedef NS_ENUM(NSUInteger, MMSQLiteRelaterKeyOptions) {
    MMSQLiteForeignKeyOnTarget,
    MMSQLiteForeignKeyOnRelated,
    MMSQLiteForeignKeysOnIntermediate
};

typedef NS_ENUM(NSUInteger, MMSQLiteRelaterMutationOptions) {
    MMSQLiteIntermediateRow,
    MMSQLiteNullForeignKey,
    MMSQLiteDeleteForeignRow,
};


@interface MMSQLiteRelater : MMRelater {
    
    //MMSet * _joins;
    //MMSQLiteMutation * _mutation;
    
    //MMSQLiteRelaterTableOptions _tableOptions;
    MMSQLiteRelaterKeyOptions _keyOptions;
    MMSQLiteRelaterMutationOptions _mutationOptions;
    
    
    
    NSString * _foreignKeyColumnName;
    
    MMEntity * _recordEntity;
    MMEntity * _relatedEntity;
//    NSString * _intermediateTableName;
//    NSString * _foreignKeyColumnName;
//    NSString * _intermediateToRelationshipTableKeyColumnName;

//    NSMutableDictionary * _identifierNames;
    
}

@property(nonatomic,retain,readonly,nonnull)MMSet * joins;

@property(nonatomic)MMSQLiteRelaterKeyOptions keyOptions;
@property(nonatomic)MMSQLiteRelaterMutationOptions mutationOptions;

@property(nonatomic, nullable)NSString * intermediateTableName;
@property(nonatomic, nonnull)NSString * foreignKeyColumnName;



@property (nonatomic, copy, nullable) BOOL (^addToRelationship)(MMService * service, MMRelationship * rel, MMRecord* recordInstance, NSArray<MMRecord *>* toBeAdded);

@property (nonatomic, copy, nullable) BOOL (^removeFromRelationship)(MMService * service, MMRelationship * rel, MMRecord* recordInstance, NSArray<MMRecord *>* toBeRemoved);




//+(MMSQLiteRelater *)relaterWithIntermediateTableName:(nullable NSString*)intermediateTable foreignKeyToRecordName:(NSString *)foreignKeyToRecordColumnName foreignKeyToRelatedName:(NSString *)foreignKeyToRelatedColumnName;
+(MMSQLiteRelater *)relaterWithRecordEntity:(MMEntity *)recordEntity relatedEntity:(MMEntity *)relatedEntity ForeignKeyName:(NSString *)foreignKeyColumnName onEntity:(MMSQLiteRelaterKeyOptions)keyOptions andMutationOptions:(MMSQLiteRelaterMutationOptions)mutationOptions;




-(void)foreignKeyForEntity:(MMSQLiteEntityType)type;

@end


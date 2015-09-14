//
//  MMSQLiteRelationship.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/16/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMRelationship.h"
#import "MMRelater.h"
//#import "MMSQLiteMutation.h"

typedef NS_ENUM(NSUInteger, MMSQLiteEntityType) {
    MMSQLiteTargetType,
    MMSQLiteRelatedType
};

typedef NS_ENUM(NSUInteger, MMSQLiteRelaterKeyOptions) {
    MMSQLiteForeignKeyOnTarget,
    MMSQLiteForeignKeyOnRelated,
    MMSQLiteForeignKeysOnIntermediate
};

typedef NS_ENUM(NSUInteger, MMSQLiteRelaterTableOptions) {
    MMSQLiteIntermediateRow,
    MMSQLiteNullForeignKey,
    MMSQLiteDeleteForeignRow
};


@interface MMSQLiteRelater : MMRelater {
    
    //MMSet * _joins;
    //MMSQLiteMutation * _mutation;
    
    MMSQLiteRelaterTableOptions _tableOptions;
    MMSQLiteRelaterKeyOptions _keyOptions;

    
}
@property(nonatomic,retain,readonly)MMSet * joins;
@property(nonatomic)MMSQLiteRelaterTableOptions _tableOptions;
@property(nonatomic)MMSQLiteRelaterKeyOptions _keyOptions;


-(void)foreignKeyForEntity:(MMSQLiteEntityType)type;

@end


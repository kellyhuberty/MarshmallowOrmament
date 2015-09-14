//
//  MMSqliteSchemaMigration.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/7/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSchemaMigration.h"
#import "MMSQLiteStore.h"
#import "MMSQLiteSchema.h"

@interface MMSqliteSchemaMigration : MMSchemaMigration{
    
    
    NSMutableArray* _upgradeSql;
    NSMutableArray* _downgradeSql;
    
    
    
}
@property(nonatomic, readonly)NSMutableArray * upgradeSql;
@property(nonatomic, readonly)NSMutableArray * downgradeSql;
//@property(nonatomic, retain)BOOL _createNewStoreFile;
@end

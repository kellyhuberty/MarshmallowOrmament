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
    
    
    
    
    
}

@property(nonatomic, retain)MMSQLiteStore * olderStore;
@property(nonatomic, retain)MMSQLiteStore * newerStore;

@property(nonatomic, retain)MMSQLiteSchema * olderSchema;
@property(nonatomic, retain)MMSQLiteSchema * newerSchema;

@end

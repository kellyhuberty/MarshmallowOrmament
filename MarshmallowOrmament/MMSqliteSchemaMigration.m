//
//  MMSqliteSchemaMigration.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/7/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSqliteSchemaMigration.h"
#import "MMSqliteStore.h"

@implementation MMSqliteSchemaMigration



-(MMSQLiteStore *)olderStore{
 
    if (![super olderStore]) {
        [super setOlderStore:[[MMSQLiteStore alloc]initWithSchema:[super olderSchema]]];
    }
    
    return super.olderStore;
    
}


-(MMSQLiteStore *)newerStore{
    
    if (![super newerStore]) {
        [super setNewerStore:[[MMSQLiteStore alloc]initWithSchema:[super newerSchema]]];
    }
    
    return super.newerStore;
    
}



@end

//
//  TSTMigration1.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/8/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSqliteSchemaMigration.h"

@interface TSTMigration1 : MMSqliteSchemaMigration


-(BOOL)upgrade:(NSError **)error;
-(BOOL)downgrade:(NSError **)error;


@end

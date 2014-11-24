//
//  MMSQLiteRequest.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteRequest.h"
#import "MMSQLiteStore.h"
@implementation MMSQLiteRequest

    //
-(id)init{
    
    if (self = [super init]) {
            _sqlBindValues = [[NSMutableDictionary alloc]init];
            //_meta = [[MMOrmMeta alloc]init];
    }
    
    return self;
}


@end

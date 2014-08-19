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


-(instancetype)init{
    
    
    self = [super init];
    
    if (self) {
        _parameterDictionary = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}


@end

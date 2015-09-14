//
//  MMSQLiteRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/16/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteRelater.h"

@implementation MMSQLiteRelater

-(id)init{
    
    if (self = [super init]) {
        
        _joins = [[MMSet alloc]init];

        
    }
    
    return self;
    
}



@end

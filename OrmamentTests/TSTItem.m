//
//  TSTItem.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/3/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTItem.h"

@implementation TSTItem

@dynamic date;

+(BOOL)shouldAutoloadClassAsEntity{
    if([self class] == [TSTItem class]){
        return NO;
    }
    return YES;
}

@end

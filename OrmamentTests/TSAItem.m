//
//  TSAItem.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 12/23/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSAItem.h"

@implementation TSAItem

@dynamic date;

+(BOOL)shouldAutoloadClassAsEntity{
    if([self class] == [TSAItem class]){
        return NO;
    }
    return YES;
}


@end

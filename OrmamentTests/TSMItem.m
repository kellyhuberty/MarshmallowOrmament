//
//  TSAItem.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 12/23/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSMItem.h"

@implementation TSMItem

@dynamic date;

+(BOOL)shouldAutoloadClassAsEntity{
    if([self class] == [TSMItem class]){
        return NO;
    }
    return YES;
}


@end

//
//  MMORMUtility.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMORMUtility.h"
#include <pthread.h>

NSString * MMORMArrayValueHash(NSArray * array)
{
    
    NSMutableString * keyHash = [NSMutableString stringWithString:@""];
    
    for (id<NSCopying> key in array) {
        
        NSString * hashString = [[NSNumber numberWithInteger:[((id<NSObject>)key) hash]] stringValue];
        
        [keyHash appendString:hashString];
        
    }
    
    return keyHash;
}

NSArray * MMORMSortedValueArray(NSDictionary * dict)
{
    NSArray * keys = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray * values = [NSMutableArray array];
    
    for (NSString * key in keys) {
        [values addObject:[dict valueForKey:key]];
    }
    
    return values;
}

NSString * MMORMIdentifierHash(NSDictionary * dict)
{
    return MMORMArrayValueHash(MMORMSortedValueArray(dict));
}

NSNumber * MMORMThreadNSNumber()
{
    unsigned int tid = pthread_mach_thread_np(pthread_self());

    return [NSNumber numberWithInt:tid];
}


@implementation MMORMUtility

@end

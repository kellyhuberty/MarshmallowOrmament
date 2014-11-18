//
//  MMSchemaObject.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSchemaObject.h"

@implementation MMSchemaObject

-(id)initWithDictionary:(NSDictionary *)dict{
    
    NSArray * arr = [dict allKeys];
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];
    
    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
    
    
    return nil;
    
}

@end

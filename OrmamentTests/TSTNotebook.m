//
//  TSTNotebook.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/5/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTNotebook.h"

@implementation TSTNotebook

@dynamic id;
@dynamic title;
@dynamic description;
@dynamic notes;

+(NSString *)schemaName{
    
    return @"noteit";
    
}

+(NSString *)entityName{
    
    return @"notebook";
    
}

+(NSArray *)idKeys{
    
    return @[@"id"];
    
}

+(NSDictionary *)metaForRecordEntity{
    
    return @{};
    
}

@end

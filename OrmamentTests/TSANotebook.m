    //
    //  TSTNotebook.m
    //  MarshmallowOrmament
    //
    //  Created by Kelly Huberty on 8/5/14.
    //  Copyright (c) 2014 Kelly Huberty. All rights reserved.
    //

#import "TSANotebook.h"

@implementation TSANotebook

@dynamic id;
@dynamic title;
@dynamic description;
@dynamic notes;

+(NSString *)schemaName{
    
    return @"noteitauto";
    
}

+(NSString *)entityName{
    
    return @"notebook";
    
}

+(NSArray *)idKeys{
    
    return @[@"identifier"];
    
}

+(NSDictionary *)metaForRecordEntity{
    
    return @{};
    
}

@end

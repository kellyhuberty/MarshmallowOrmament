//
//  TSTNotebook.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/5/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTNotebook.h"
#import "TSTNote.h"
#import "MMSQLiteRelater.h"

@implementation TSTNotebook

@dynamic identifier;
@dynamic title;
@dynamic description;
@dynamic notes;

+(NSString *)schemaName{
    
    return @"noteit";
    
}

+(NSString *)entityName{
    
    return @"notebook";
    
}

+(NSArray *)idKeysForRecordEntity{
    
    return @[@"identifier"];
    
}

+(NSDictionary *)metaForRecordEntity{
    
    return @{};
    
}

+(NSArray *)relationshipsForRecordEntity{
    
    MMRelationship * rel = [self createRelationshipNamed:@"notes"
                                           toRecordClass:[TSTNote class]
                                                 hasMany:YES
                                            storeRelator:[MMSQLiteRelater relaterWithForeignKeyName:@"notebookId" onEntity:MMSQLiteForeignKeyOnRelated andMutationOptions:MMSQLiteNullForeignKey]
                                            cloudRelater:nil];

    
    return @[rel];
    
}

@end

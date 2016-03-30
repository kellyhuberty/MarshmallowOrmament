//
//  TSTTag.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 3/19/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import "TSTTag.h"
#import "TSTNote.h"
#import "MMSQLiteRelater.h"
@implementation TSTTag

@dynamic identifier;
@dynamic title;
@dynamic description;

+(NSString *)schemaName{
    
    return @"noteit";
    
}

+(NSString *)entityName{
    
    return @"tag";
    
}

+(NSArray *)idKeysForRecordEntity{
    
    return @[@"identifier"];
    
}

+(NSDictionary *)metaForRecordEntity{
    
    return @{};
    
}

+(NSArray *)relationshipsForRecordEntity{
    
    //MMSQLiteRelater
    

    
    
    MMRelationship * rel = [self createRelationshipNamed:@"notes"
                                           toRecordClass:[TSTNote class]
                                                 hasMany:YES
                                            storeRelator:
                                            [MMSQLiteRelater relaterWithIntermediateTableName:@"tag_note"
                                                                          localForeignKeyName:@"tag_identifier"
                                                                        relatedForeignKeyName:@"note_identifier"]
                                            cloudRelater:nil];
    
    
    return @[rel];
    
}

@end

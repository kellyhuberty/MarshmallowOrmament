//
//  TSTNote.m
//  MarshmallowORM
//
//  Created by Kelly Huberty on 4/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTNote.h"
#import "TSTTag.h"
#import "MMSQLiteRelater.h"
@implementation TSTNote

@dynamic identifier;
@dynamic text;
@dynamic tags;
@dynamic notebook;
@dynamic longitude;
@dynamic latitude;

+(NSString *)schemaName{
    
    return @"noteit";
    
}

+(NSString *)entityName{
    
    return @"note";
    
}

+(NSArray *)idKeysForRecordEntity{
    
    return @[@"identifier"];
    
}

+(NSDictionary *)metaForRecordEntity{
    
    return nil;
    
}

+(NSArray *)relationshipsForRecordEntity{
    
    
    MMRelationship * notebookRelationship = [self createRelationshipNamed:@"notebook"
                                           toRecordClass:[TSTNotebook class]
                                                 hasMany:NO
                                            storeRelator:[MMSQLiteRelater relaterWithForeignKeyName:@"notebookId" onEntity:MMSQLiteForeignKeyOnTarget andMutationOptions:MMSQLiteNullForeignKey]
                                            cloudRelater:nil];
    
    
    MMRelationship * tagRelationship = [self createRelationshipNamed:@"tags"
                                           toRecordClass:[TSTTag class]
                                                 hasMany:YES
                                            storeRelator:
                            [MMSQLiteRelater relaterWithIntermediateTableName:@"tag_note"
                                                          localForeignKeyName:@"note_identifier"
                                                        relatedForeignKeyName:@"tag_identifier"]
                                            cloudRelater:nil];
    
    
    
    return @[notebookRelationship, tagRelationship];
    
}




@end

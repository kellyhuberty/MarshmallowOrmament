//
//  MMOrmamentBoostrap.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/3/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "MMSchema.h"

@interface MMOrmamentBootstrap : NSObject

+(void)startWithSchemas:(NSArray *)schemas;

+(void)upgradeSchema:(NSString *)schemaName oldVersion:(MMVersionString *)oldVersion newVersion:(MMVersionString *)newVersion error:(NSError **)error;

+(void)downgradeSchema:(NSString *)schemaName oldVersion:(MMVersionString *)oldVersion newVersion:(MMVersionString *)newVersion error:(NSError **)error;

+(NSArray *)migrationMapForSchemaName:(NSString *)schemaName;

+(void)unsetVersionForSchema:(NSString *)schemaName;

+(NSDictionary *)schemaDictionaryWithName:(NSString *)name version:(NSString *)ver;

@end

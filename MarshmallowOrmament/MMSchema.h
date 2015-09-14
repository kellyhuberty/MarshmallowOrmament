//
//  MMSchema.h
//  Marshmallow
//
//  Created by Kelly Huberty on 11/8/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMUtility.h"
#import "MMVersionString.h"
#import "MMEntity.h"
#import "MMSet.h"
#import "MMSchemaObject.h"



@interface MMSchema : MMSchemaObject{
    
    NSString * _name;
    MMVersionString * _version;
    MMSet * _entities;
    NSMutableDictionary * _modelClassNameIndex;
    NSString * _storeClassName;
    MMSet * _autoRelationships;
    MMSet * _migrations;
    
    BOOL _autoEntities;
    BOOL _autoBuild;

}
@property(nonatomic)MMVersionString * version;
@property(nonatomic, retain)NSString * name;
@property(nonatomic, retain)NSArray * entities;
@property(nonatomic, retain)NSString * storeClassName;
@property(nonatomic, retain)NSString * cloudClassName;
@property(nonatomic, retain)MMSet * migrations;
@property(nonatomic)BOOL autoEntities;
@property(nonatomic)BOOL autoBuild;
@property(nonatomic)NSString * storeMigrationDelegateClassname;
@property(nonatomic)NSString * cloudMigrationDelegateClassname;

+(void)registerSchema:(MMSchema *)schema;
+(MMSchema *)registeredSchemaWithName:(NSString *)name;

+(MMSchema *)currentSchemaWithName:(NSString *)name;

+(MMVersionString *)currentVersionForSchemaName:(NSString *)schemaName;
+(void)setCurrentVersion:(MMVersionString *)version forSchemaName:(NSString *)schemaName;
+(void)unsetVersionForSchemaName:(NSString *)schemaName;


+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver;
+(NSArray *)allSchemas;


-(id)init;
-(id)initWithDictionary:(NSDictionary *)dict;
-(id)initWithFilePath:(NSString *)path;
-(id)initWithName:(NSString *)name version:(MMVersionString *)version;
-(id)initWithName:(NSString *)name version:(MMVersionString *)version entities:(NSArray *)entities;
-(id)initWithFilename:(NSString *)filename;

-(void)setEntityArray:(NSArray *)arr;


-(MMEntity *)entityForModelClassName:(NSString *)className;
-(MMEntity *)entityForModelClass:(Class)name;
-(MMEntity *)entityForName:(NSString *)entityName;

+(void)setDefaultSchema:(MMSchema *)schema;
+(MMSchema *)defaultSchema;




-(void)upgradeSchemaFromVersion:(NSString *)fromVersion toVersion:(NSString *)toVersion usingUpgradePathName:(NSString *)mapName;
-(void)build;
-(void)destroy;

-(void)log;
@end

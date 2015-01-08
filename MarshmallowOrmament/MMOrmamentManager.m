//
//  MMOrmamentBoostrap.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/3/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMOrmamentManager.h"
#import "MMPreferences.h"

#import "MMSchemaMigration.h"

#import "MMService.h"

@implementation MMOrmamentManager


+(MMOrmamentManager *)sharedManager{
    
    if (!sharedManager){
        
        //sharedManager =
        sharedManager = [[[self class] alloc]init];
        
        
    }
    
    return sharedManager;
    
    
}


+(void)resetSharedManager{
    
    MMRelease(sharedManager);
    
    sharedManager = nil;
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        _schemas = [[NSMutableDictionary alloc] init];
        _services = [[NSMutableDictionary alloc] init];
        _records = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}


+(void)startWithSchemas:(NSArray *)schemas{
    
    MMOrmamentManager * manager = [self sharedManager];
    
    [manager startWithSchemas:schemas];
    
}



-(void)startWithSchemas:(NSArray *)schemas{
    
    
    for (NSObject * obj in schemas) {
       
        MMSchema * schema = nil;
        
        if ([obj isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            
            if ( ((NSDictionary *)obj)[@"name"] && ((NSDictionary *)obj)[@"version"]) {

                schema = [[self class] schemaFromName:((NSDictionary *)obj)[@"name"] version:((NSDictionary *)obj)[@"version"]];
                
            }
            
        }
//        else if ([obj isKindOfClass:NSClassFromString(@"MMSchema")]){
//            
//            schema = (MMSchema *)obj;
//            
//        }
        
        NSError * error = nil;
        
        if ( [[self class] currentVersionForSchemaName:schema.name] == nil ) {
            //initial data build....
            
            NSLog(@"Building inital store for %@", schema.name);
            
            [[self class] buildServicesForSchema:schema error:&error];
            
        }
        else{
        
            if ( [schema.version compareVersion:[[self class] currentVersionForSchemaName:schema.name]] == NSOrderedDescending ) {
                // downgrade schema...
                
//                MMSchema *newschema = [self schemaFromPlistPath:[NSString stringWithFormat:@"%@__%@",
//                                                                 [NSString stringWithString:((NSDictionary *)obj)[@"name"] ],
//                                                                 [MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]
//                                                                 ]];
                //MMSchema *newschema = [[self class] schemaFromName:[NSString stringWithString:((NSDictionary *)obj)[@"name"] ] version:[MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]];
                
                

                [[self class] downgradeSchema:schema.name oldVersion:[[self class] currentVersionForSchemaName:schema.name] newVersion:schema.version error:&error];

                
            }
            else if ( [schema.version compareVersion:[[self class] currentVersionForSchemaName:schema.name]] == NSOrderedAscending ) {
                // upgrade schema...
                
                
                //MMSchema * oldschema = [[self class] schemaFromName:[NSString stringWithString:((NSDictionary *)obj)[@"name"] ] version:[MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]];
                
                
                [[self class] upgradeSchema:schema.name oldVersion:[[self class] currentVersionForSchemaName:schema.name] newVersion:schema.version error:&error];

                
            }
            
        }
        
        
        [MMSchema registerSchema:schema];

        
    }
    
}


+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
    return MMAutorelease([[MMSchema alloc]initWithDictionary:[self schemaDictionaryWithName:name version:ver]]);
    
}

+(NSDictionary *)schemaDictionaryWithName:(NSString *)name version:(NSString *)ver{
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:[self schemaPathWithName:name version:ver ]];
    
    return dictionary;
    
}


+(NSString *)schemaPathWithName:(NSString *)name version:(NSString *)ver{
    
    return [self bundlePlistPathWithName:[self schemaIdentifierStringFromName:name version:ver]];
    
}

+(NSString *)bundlePlistPathWithName:(NSString *)name{
    
    
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"plist"];

    
}


+(NSString *)schemaIdentifierStringFromName:(NSString *)name version:(NSString *)ver{
    
    //NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
    //return [self schemaFromPlistPath: [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]];
    
    return [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]];
    
}


+(MMSchema *)schemaFromPlistPath:(NSString *)string{
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:string ofType:@"plist"];
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"url path__ %@ string__ %@", path, string);
    
    return MMAutorelease([[MMSchema alloc]initWithDictionary:dictionary]);
    
}


//+(NSArray *)migrationMapForSchemaName:(NSString *)schemaName{
//    
//    
//    NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@__migrations",schemaName] ofType:@"plist"];
//    
//    if(!path){
//        
//        [MMException(@"no file found for filename!", @"MMFileException", nil) raise];
//        return nil;
//        
//    }
//    
//    
//    NSArray * dict = [NSArray arrayWithContentsOfFile:path] ;
//    
//    
//    if(!dict){
//        
//        [MMException(@"Dictionary not parseable.", @"MMSchemaException", nil) raise];
//        return nil;
//        
//    }
//    
//    return dict;
//    
//}


+(void)start{
    
    [self startWithSchemas: [MMPreferences appInfoForKey:@"MMSchemaVersions"]];
 
}

//+(MMVersionString *)currentVersionForSchema:(NSString *)schemaName{
//    
//    NSDictionary * dict = [MMPreferences appInfoForKey:@"MMSchemaVersions"];
//    
//    return [MMVersionString stringWithString:dict[schemaName]];
//    
//}

+(MMVersionString *)currentVersionForSchemaName:(NSString *)schemaName{
    
    NSDictionary * dict = [[MMPreferences valueForKey:@"MMSchemaVersions"] mutableCopy];
    if (dict[schemaName]) {
        return [MMVersionString stringWithString:dict[schemaName]];
    }
    return nil;
    
}

+(void)setCurrentVersion:(MMVersionString *)version forSchemaName:(NSString *)schemaName{
    
     NSMutableDictionary * dict = [[MMPreferences valueForKey:@"MMSchemaVersions"] mutableCopy ];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    
    dict[schemaName] = version;
    
    [MMPreferences setValue:dict forKey:@"MMSchemaVersions"];
    
}


+(void)unsetVersionForSchema:(NSString *)schemaName{
    
    NSMutableDictionary * dict = [[MMPreferences valueForKey:@"MMSchemaVersions"] mutableCopy];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    [dict removeObjectForKey:schemaName];
    
    [MMPreferences setValue:dict forKey:@"MMSchemaVersions"];
    
}


+(BOOL)checkSchemas:(NSError **)error{
    
    NSArray * schemas = [MMSchema allSchemas];
    
    for (MMSchema * schema in schemas) {
        
        
        
    }
    
    return nil;
}

+(void)buildServicesForSchema:(MMSchema *)schema error:(NSError **)error{
    
    if (schema.storeClassName) {
    
        
        if (NSClassFromString(schema.storeClassName)) {
            MMService * store = [[NSClassFromString(schema.storeClassName) alloc] initWithSchema:(schema)];
            
            BOOL suc = [store build:&error];
            
            if(!suc){
                
                MMError(@"Error during build for class %@", schema.storeClassName);
                exit(1);
            }
            
        }
        else{
        
            MMError(@"Unable to build valid store for class %@", schema.storeClassName);
        }

    }
    
    if (schema.cloudClassName) {
        
        if (NSClassFromString(schema.cloudClassName)) {

            MMService * cloud = [[NSClassFromString(schema.cloudClassName) alloc] initWithSchema:(schema)];
            
            BOOL suc = [cloud build:&error];
            
            if(!suc){
                
                MMError(@"Error during build for class %@", schema.cloudClassName);
                exit(1);
            }
            
        }
        else{
            
            MMError(@"Unable to build valid store for class %@", schema.cloudClassName);
        }
    
    }
        
    [self setCurrentVersion:schema.version forSchemaName:schema.name];
    
}

+(void)resetStoreForStoreForSchema:(MMSchema *)schema error:(NSError **)error{
    
    MMService * store = [[NSClassFromString(schema.storeClassName) alloc] initWithSchema:(schema)];
    
    [store build:&error];
    
    [self setCurrentVersion:schema.version forSchemaName:schema.name];
    
}

//+(NSArray *)buildSchemaMigrationsWithName:(NSString *)schemaName olderSchema:(MMSchema *)olderSchema newerSchema:(MMSchema *)newerSchema error:(NSError **)error{
//    
//    MMSet * set = [[MMSet alloc]init];
//    
//    MMSet * migrations = [[MMSet alloc]init];
//    
//    [set addIndexForKey:@"fromVersion"];
//    [set addIndexForKey:@"toVersion"];
//    
//    //[set addObjectsFromArray:[self migrationMapForSchemaName:schemaName]];
//    
//
//        MMVersionString * oldVersion = [MMVersionString stringWithString:olderSchema.version];
//        MMVersionString * intermediate;
//        MMVersionString * newVersion = [MMVersionString stringWithString:newerSchema.version];
//        BOOL goodPath = NO;
//        BOOL badPath = NO;
//
//        intermediate = oldVersion;
//
//
//        while(!goodPath && !badPath){
//
//            MMLog(@"Upgrade path generation loop");
//
//            //newVersion.migrationMaps
//            
//            NSArray * possibleMigrations = [set objectsWithValue:intermediate forKey:@"old"];
//            
//            if([possibleMigrations count] > 0){
//
//                for (NSDictionary * migDict in possibleMigrations) {
//                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedAscending) {
//                        // add migration
//                        
//                        
//                        
//                    }
//                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedSame) {
//                        // add migration and break
//                        
//                        //[migrations addObject:
//                         
//                         Class <MMSchemaMigration> cls = NSClassFromString(migDict[@"classname"]);
//                        
//                         MMSchema * oldSchema = [self schemaFromName:schemaName version:[MMVersionString stringWithString:migDict[@"old"]]];
//                        
//                         MMSchema * newSchema = [self schemaFromName:schemaName version:[MMVersionString stringWithString:migDict[@"new"]]];
//                        
//                        
//                         MMSchemaMigration * mig = [cls migrationForOldSchema:[MMVersionString stringWithString:migDict[@"old"]] newSchema:[MMVersionString stringWithString:migDict[@"new"]]
//                          ];
//                        
//                        [migrations addObject:mig];
//                        
//                        goodPath = true;
//                    
//                    }
//                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedDescending) {
//                        // add migration and break
//                        
//                        badPath = true;
//                    }
//                    
//                }
//
//            }
//            else{
//                badPath = true;
//            }
//        }
//        
//
//    
//    return migrations;
//}

+(NSArray *)buildSchemaMigrationsForName:(NSString *)name fromVersion:(MMVersionString *)old toVersion:(MMVersionString *)new{
    
    BOOL downgrade = ( ([old compareVersion:new] == NSOrderedAscending) ? false: true);
    
    NSDictionary * schemaDictionary = [self schemaDictionaryWithName:name version:new];
    
    NSDictionary * migrationDictionary = nil;
    
    [self migrationDictionariesWithSchemaDictionary:schemaDictionary];
    
    NSMutableArray * migrations = [NSMutableArray array];
    
    MMSchemaMigration * migration = [MMSchemaMigration migrationWithDictionary:migrationDictionary];
    [migrations insertObject:migration atIndex:0];
    
    while (migration && migration.fromVersion != old) {
     
        NSDictionary * schemaDictionary = [self schemaDictionaryWithName:name version:new];
        
        NSDictionary * migrationDictionary = nil;
        
        migrationDictionary = [self migrationDictionariesWithSchemaDictionary:schemaDictionary];
        
        if ([old compareVersion:new] == NSOrderedDescending && downgrade ) {
            
            [NSException raise:@"MMInvalidSchemaMigrationException" format:@"The schema had an invalid migration"];
            
        }
        else if([old compareVersion:new] == NSOrderedAscending && !downgrade ){
            
            [NSException raise:@"MMInvalidSchemaMigrationException" format:@"The schema had an invalid migration"];
            
        }
        
        MMSchemaMigration * migration = [MMSchemaMigration migrationWithDictionary:migrationDictionary];

        [migrations insertObject:migration atIndex:0];
        
    }
    
    return migrations;
    
}


+(NSDictionary *)versionMigrationDictionariesWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
    

   return [self migrationDictionariesWithSchemaDictionary:[self schemaDictionaryWithName:schemaName version:ver]];
    
}

+(NSDictionary *)migrationDictionariesWithSchemaDictionary:(NSDictionary *)schemaDict{
    
    return @{schemaDict[@"migration"]: schemaDict[@"migration"]};
    
}

+(NSDictionary *)bestMigrationUpgradeToVersion:(MMVersionString *)ver withDictionaries:(NSDictionary *)schemaDict{
    
    return schemaDict[@"migration"];
    
}

+(void)upgradeSchema:(NSString *)schemaName oldVersion:(MMVersionString *)oldVersion newVersion:(MMVersionString *)newVersion error:(NSError **)error{
    
    NSArray * migrations = [self buildSchemaMigrationsForName:schemaName fromVersion:oldVersion toVersion:newVersion];
    
    //NSError * error;
    
    for (MMSchemaMigration * migration in migrations) {
        
        MMService * oldStore = [MMService storeWithSchemaName:schemaName version:migration.fromVersion];
        MMService * newStore = [MMService storeWithSchemaName:schemaName version:migration.toVersion];

        
        BOOL success = [migration upgradeStore:oldStore toStore:newStore error:error];
        
        if (!success) {
            MMLog(@"Migration falied %@", [*error localizedDescription] );
            //NSString * str = [*error localizedDescription];
            
        }
        
        
    }
    
}

+(void)downgradeSchema:(NSString *)schemaName oldVersion:(MMVersionString *)oldVersion newVersion:(MMVersionString *)newVersion error:(NSError **)error{
    
    
    
}


//
//-(BOOL)upgradeSchemaWithName:(NSString *)modelName FromVersion:(NSString *)old toVersion:(NSString *)new usingMap:(NSDictionary *)map{
//    
//    NSMutableArray * upgrades = [NSMutableArray array];
//    
//    //This loop generates the upgrade path.
//    //Loop setup
//    if (map != nil) {
//        
//        NSString * oldVersion = [NSString stringWithString:old];
//        NSString * intermediate;
//        NSString * newVersion = [NSString stringWithString:new];
//        BOOL goodPath = NO;
//        BOOL badPath = NO;
//        
//        intermediate = oldVersion;
//        
//        
//        while(!goodPath && !badPath){
//            
//            MMLog(@"Upgrade path generation loop");
//            
//            NSString * newintermediate = [_upgradePath valueForKey:intermediate];
//            
//            if(newintermediate != nil){
//                
//                [upgrades addObject:@{intermediate : newintermediate}];
//                if([intermediate isEqualToString:newVersion]){
//                    goodPath = true;
//                }
//                intermediate = newintermediate;
//                
//            }
//            else{
//                badPath = true;
//            }
//        }
//        
//    }else{
//        
//        MMLog(@"No Upgrade Map Found");
//        
//    }
//    
//    //Run the Migrations;
//    for (NSDictionary * dict in upgrades) {
//        NSString * intermediate = [dict allKeys][0];
//        NSString * newintermediate = [dict allKeys][0];
//        
//        
//        [self runUpgradeMigrationFromVersion:intermediate toVersion:newintermediate];
//    }
//    
//    return true;
//}




-(void)buildInitialStore{
    
    
    
    
    
}





@end

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
#import "MMLogger.h"
#import "MMVersionString.h"
@implementation MMOrmamentManager


+(instancetype)sharedManager{
    
    if (!sharedManager){
        
        //sharedManager =
        sharedManager = [[[self class] alloc]init];
        
        
    }
    
    return sharedManager;
    
    
}


+(void)resetSharedManager{
    
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
        
        NSError * error = nil;
        
        [self _startSchemaServices:schema];
        
        [MMSchema registerSchema:schema];

        
    }
    
}

#pragma mark Schema acquistion from file.
+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    NSLog(@"schemaFromName:%@ version:%@", name, ver);
    
    NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
    NSLog(@"schema dictionary:%@", [self schemaDictionaryWithName:name version:ver]);

    return [[MMSchema alloc]initWithDictionary:[self schemaDictionaryWithName:name version:ver]];
    
}

+(NSDictionary *)schemaDictionaryWithName:(NSString *)name version:(NSString *)ver{
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:[self schemaPathWithName:name version:ver]];
    
    return dictionary;
    
}


+(NSString *)schemaIdentifierStringFromName:(NSString *)name version:(NSString *)ver{
    
        //NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
        //return [self schemaFromPlistPath: [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]];
    
    return [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]];
    
}

+(NSString *)schemaPathWithName:(NSString *)name version:(NSString *)ver{
    
    return [self bundlePlistPathWithName:[self schemaIdentifierStringFromName:name version:ver]];
    
}



+(NSString *)bundlePlistPathWithName:(NSString *)name{
    
    
    return [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"plist"];

    
}


+(MMSchema *)schemaFromPlistPath:(NSString *)string{
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:string ofType:@"plist"];
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"url path__ %@ string__ %@", path, string);
    
    return [[MMSchema alloc]initWithDictionary:dictionary];
    
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


+(BOOL)checkSchemas:(NSError **)error{
    
    NSArray * schemas = [MMSchema allSchemas];
    
    for (MMSchema * schema in schemas) {
        
        
        
    }
    
    return nil;
}

+(void)buildServiceType:(NSString *)serviceType forSchema:(MMSchema *)schema error:(NSError **)error{
    
    NSString * serviceClassName;
    
    if ((serviceClassName = [schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]])) {
    
        
        if (NSClassFromString(serviceClassName)) {
            MMService * store = [[NSClassFromString(serviceClassName) alloc] initWithSchema:(schema)];
            
            BOOL suc = [store build:&error];
            
            if(!suc){
                
                MMError(@"Error during build for class %@", serviceClassName);
                exit(1);
            }else{
                
                [MMService setCurrentVersion:schema.version forSchemaName:schema.name type:serviceType];
                
            }
            
        }
        else{
        
            MMError(@"Unable to build valid store for class %@", serviceType);
        }

    }
    
        
        //    [self setCurrentVersion:schema.version forSchemaName:schema.name];
    
}


-(void)_startSchemaServices:(MMSchema *)schema{
    
    NSArray * serviceTypes = @[@"store", @"cloud"];
    
    
    
    
    for (NSString * type in serviceTypes) {
        
        
        NSError * error;
        
        NSString * classname = [schema valueForKey:[NSString stringWithFormat:@"%@ClassName", type]];
        
        if (!classname) {
            continue;
        }
    
        NSLog(@"currentVersionForSchema %@" , [MMService currentVersionForSchemaName:schema.name type:type]);
        
        if ( [MMService currentVersionForSchemaName:schema.name type:type] == nil && schema.autoBuild) {
                //initial data build....
            
            NSLog(@"Building inital store for %@", schema.name);
            
            if (schema.autoBuild) {
                
                [[self class] buildServiceType:type forSchema:schema error:&error];
            
            }
            else{
                
                
            }
            
        }
        else{

            if ([MMService currentVersionForSchemaName:schema.name type:type] == nil) {
                [MMService setCurrentVersion:[MMVersionString stringWithString:@"0.0.0"] forSchemaName:schema.name type:type];
            }

            
            if ( [schema.version compareVersion:[MMService currentVersionForSchemaName:schema.name type:type]] == NSOrderedDescending ) {
                    // downgrade schema...
                
                [[self class] downgradeSchema:schema.name oldVersion:[MMService currentVersionForSchemaName:schema.name type:type] newVersion:schema.version error:&error];
                
            }
            else if ( [schema.version compareVersion:[MMService currentVersionForSchemaName:schema.name type:type]] == NSOrderedAscending ) {
                    // upgrade schema...
                
                
                    //MMSchema * oldschema = [[self class] schemaFromName:[NSString stringWithString:((NSDictionary *)obj)[@"name"] ] version:[MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]];
                
                
                [[self class] upgradeSchema:schema.name oldVersion:[MMService currentVersionForSchemaName:schema.name type:type] newVersion:schema.version error:&error];
                
                
            }
            
        }
        
        
        
        
    }

    
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
    
//    //NSError * error;
//    
//    for (MMSchemaMigration * migration in migrations) {
//        
//        MMService * oldStore = [MMService storeWithSchemaName:schemaName version:migration.fromVersion];
//        MMService * newStore = [MMService storeWithSchemaName:schemaName version:migration.toVersion];
//
//        
//        BOOL success = [migration upgradeStore:oldStore toStore:newStore error:error];
//        
//        if (!success) {
//            MMLog(@"Migration falied %@", [*error localizedDescription] );
//            //NSString * str = [*error localizedDescription];
//            
//        }
//        
//        
//    }
    
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

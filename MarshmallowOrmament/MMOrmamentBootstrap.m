//
//  MMOrmamentBoostrap.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/3/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMOrmamentBootstrap.h"
#import "MMPreferences.h"

#import "MMSchemaMigration.h"

#import "MMStore.h"

@implementation MMOrmamentBootstrap


+(void)startWithSchemas:(NSArray *)schemas{
    
    
    for (NSObject * obj in schemas) {
       
        MMSchema * schema = nil;
        
        if ([obj isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            if ( ((NSDictionary *)obj)[@"name"] && ((NSDictionary *)obj)[@"version"]) {
                //schema = [self schemaFromPlistPath:[NSString stringWithFormat:@"%@__%@",
                //            [NSString stringWithString:((NSDictionary *)obj)[@"name"] ],
                //            [[MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]] pathString]
                //          ]];
                schema = [self schemaFromName:((NSDictionary *)obj)[@"name"] version:((NSDictionary *)obj)[@"version"]];
                
            }
            
        }
        
        NSError * error = nil;
        
        if ( [self versionForSchema:schema.name] == nil ) {
            //initial data build....
            
            [[self class] buildInitialStoreForSchema:schema error:&error];
            
            
        }
        else{
        
            if ( [schema.version compareVersion:[self versionForSchema:schema.name]] == NSOrderedDescending ) {
                // downgrade schema...
                
                MMSchema *newschema = [self schemaFromPlistPath:[NSString stringWithFormat:@"%@__%@",
                                                                 [NSString stringWithString:((NSDictionary *)obj)[@"name"] ],
                                                                 [MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]
                                                                 ]];
                

                [[self class] downgradeSchema:schema.name olderSchema:schema newerSchema:newschema error:&error];

                
            }
            else if ( [schema.version compareVersion:[self versionForSchema:schema.name]] == NSOrderedAscending ) {
                // upgrade schema...
                
                
                MMSchema * oldschema = [self schemaFromPlistPath:[NSString stringWithFormat:@"%@__%@",
                                                                 [NSString stringWithString:((NSDictionary *)obj)[@"name"] ],
                                                                 [MMVersionString stringWithString:((NSDictionary *)obj)[@"version"]]
                                                                 ]];
                
                
                [[self class] upgradeSchema:schema.name olderSchema:oldschema newerSchema:schema error:&error];

                
            }
            
        }
        
        
        [MMSchema registerSchema:schema];

        
    }
    
    //NSError * error;
    
    //[self checkSchemas:&error];
    
}


+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
    return [self schemaFromPlistPath: [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]];
    
}


+(MMSchema *)schemaFromPlistPath:(NSString *)string{
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:string ofType:@"plist"];
    
    NSLog(@"url path__ %@ string__ %@", path, string);
    
    return MMAutorelease([[MMSchema alloc]initWithFilePath:path]);

}



+(NSArray *)migrationMapForSchemaName:(NSString *)schemaName{
    
    
    NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@__migrations",schemaName] ofType:@"plist"];
    
    if(!path){
        
        [MMException(@"no file found for filename!", @"MMFileException", nil) raise];
        return nil;
        
    }
    
    
    NSArray * dict = [NSArray arrayWithContentsOfFile:path] ;
    
    
    if(!dict){
        
        [MMException(@"Dictionary not parseable.", @"MMSchemaException", nil) raise];
        return nil;
        
    }
    
    return dict;
    
}


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

+(MMVersionString *)versionForSchema:(NSString *)schemaName{
    
    NSDictionary * dict = [MMPreferences valueForKey:@"MMSchemaVersions"];
    if (dict[schemaName]) {
        return [MMVersionString stringWithString:dict[schemaName]];
    }
    return nil;
    
}

+(void)setVersion:(MMVersionString *)version forSchema:(NSString *)schemaName{
    
     NSMutableDictionary * dict = [MMPreferences valueForKey:@"MMSchemaVersions"];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    
    dict[schemaName] = version;
    
    [MMPreferences setValue:@"MMSchemaVersions" forKey:dict];
    
}



+(BOOL)checkSchemas:(NSError **)error{
    
    NSArray * schemas = [MMSchema allSchemas];
    
    for (MMSchema * schema in schemas) {
        
        
        
    }
    
    return nil;
}

+(void)buildInitialStoreForSchema:(MMSchema *)schema error:(NSError **)error{
    
    MMStore * store = [[NSClassFromString(schema.storeClassName) alloc] initWithSchema:(schema)];
    
    [store build:&error];
    
    [self setVersion:schema.version forSchema:schema.name];
    
}

+(NSArray *)buildSchemaMigrationsWithName:(NSString *)schemaName olderSchema:(MMSchema *)olderSchema newerSchema:(MMSchema *)newerSchema error:(NSError **)error{
    
    MMSet * set = [[MMSet alloc]init];
    
    MMSet * migrations = [[MMSet alloc]init];
    
    [set addIndexForKey:@"old"];
    [set addIndexForKey:@"new"];
    
    [set addObjectsFromArray:[self migrationMapForSchemaName:schemaName]];
    

        MMVersionString * oldVersion = [MMVersionString stringWithString:olderSchema.version];
        MMVersionString *  intermediate;
        MMVersionString * newVersion = [MMVersionString stringWithString:newerSchema.version];
        BOOL goodPath = NO;
        BOOL badPath = NO;

        intermediate = oldVersion;


        while(!goodPath && !badPath){

            MMLog(@"Upgrade path generation loop");

            NSArray * possibleMigrations = [set objectsWithValue:intermediate forKey:@"old"];
            
            if([possibleMigrations count] > 0){

                for (NSDictionary * migDict in possibleMigrations) {
                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedAscending) {
                        // add migration
                    }
                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedSame) {
                        // add migration and break
                        
                        //[migrations addObject:
                         
                         Class <MMSchemaMigration> cls = NSClassFromString(migDict[@"classname"]);
                        
                        MMSchema * oldSchema = [self schemaFromName:schemaName version:[MMVersionString stringWithString:migDict[@"old"]]];
                        
                        MMSchema * newSchema = [self schemaFromName:schemaName version:[MMVersionString stringWithString:migDict[@"new"]]];
                        
                        
                         MMSchemaMigration * mig = [cls migrationForOldSchema:[MMVersionString stringWithString:migDict[@"old"]] newSchema:[MMVersionString stringWithString:migDict[@"new"]]
                          ];
                        
                        [migrations addObject:mig];
                        
                        goodPath = true;
                    
                    }
                    if ([[MMVersionString stringWithString:migDict[@"new"]] compareVersion:newVersion] == NSOrderedDescending) {
                        // add migration and break
                        
                        badPath = true;
                    }
                    
                }

            }
            else{
                badPath = true;
            }
        }
        

    
    return migrations;
}




+(void)upgradeSchema:(NSString *)schemaName olderSchema:(MMSchema *)olderSchema newerSchema:(MMSchema *)newerSchema error:(NSError **)error{
    
    MMSet * migrations = [self buildSchemaMigrationsWithName:(NSString *)schemaName olderSchema:(MMSchema *)olderSchema newerSchema:(MMSchema *)newerSchema error:error];
    
    //NSError * error;
    
    for (MMSchemaMigration * migration in migrations) {
        BOOL success = [migration upgrade:error];
        
        if (!success) {
            MMLog(@"Migration falied %@", [*error localizedDescription] );
            //NSString * str = [*error localizedDescription];
            
        }
        
        
    }
    
}

+(void)downgradeSchema:(NSString *)schemaName olderSchema:(MMSchema *)olderSchema newerSchema:(MMSchema *)newerSchema error:(NSError **)error{
    
    
    
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

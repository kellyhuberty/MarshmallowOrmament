//
//  MMCoreData.m
//  Marshmallow
//
//  Created by Kelly Huberty on 4/10/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import "MMUtility.h"
#import "MMCoreData.h"
#import "MMPreferences.h"

#include <pthread.h>
@class MMUtility;

@implementation MMCoreData

static NSPersistentStoreCoordinator * storeCoordinator;
    //static NSManagedObjectContext * managedObjectContext;
static NSMutableDictionary * managedObjectContextsByThread;
static NSManagedObjectModel * managedObjectModel;
static NSManagedObjectModel * userManagedObjectModel;

static NSString * modelName;
static NSString * modelVersionString;
static NSDictionary * upgradePath;


+(NSManagedObjectContext *)managedObjectContext{
        //if (managedObjectContext != nil) {
        //    return managedObjectContext;
        //}
    
    NSManagedObjectContext * managedObjectContext;

    
    if (managedObjectContextsByThread == nil) {
        managedObjectContextsByThread = [[NSMutableDictionary alloc]init];
    }
    
    unsigned int tid = pthread_mach_thread_np(pthread_self());
    
    managedObjectContext = (NSManagedObjectContext *)[managedObjectContextsByThread objectForKey:[NSNumber numberWithInt:tid]];
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    
    NSPersistentStoreCoordinator *coordinator = [[self class] mmPersistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        [managedObjectContextsByThread setObject:managedObjectContext forKey:[NSNumber numberWithInt:tid]];
    }
    else{
            //You're screwed. Your trying to pull data without a database. Good luck.
        [NSException raise:@"MMCoreDataNoStoreCordinatorException" format:@"Your core data session experienced an error. You need to initailize your core data session before continuing"];
    }
    
    return managedObjectContext;
}

+ (NSManagedObjectModel *)mmManagedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSMutableArray * models = [NSMutableArray arrayWithObjects:[[self class] marshmallowDataModel],nil ];
    
    
    if (userManagedObjectModel) {
        [models addObject:userManagedObjectModel];
    }
    
    managedObjectModel = mmRetain([NSManagedObjectModel modelByMergingModels:models ]) ;
    
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)mmPersistentStoreCoordinator {
    if (storeCoordinator != nil) {
        return storeCoordinator;
    }
    
    NSString *storeUrlFileName = [[self applicationDocumentsDirectory]
                                  stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@%@" ,@"mm_app_data", [[self class] modelVersionString], @".sqlite"]];
    
    
    NSURL *storeUrl = [NSURL fileURLWithPath: storeUrlFileName];
    
    NSError * error1 = nil;
    
    if([storeUrl checkResourceIsReachableAndReturnError:&error1] == NO){
        
        if (error1 != nil) {
            MMLog(@"Error: %@", [error1 localizedDescription]);
        }
        
        NSLog(@"Invalid store filename:%@", storeUrlFileName);
        
        NSLog(@"Checking Model Versions");

        NSLog(@"currentModelVersion: %@",[self currentModelVersionString]);
        NSLog(@"modelVersion: %@", [self modelVersionString]);
        if (([self currentModelVersionString] != nil)) {
            if (([[self currentModelVersionString] isEqualToString:[self modelVersionString]] == NO)) {
                NSLog(@"Attempting Model Upgrade");

                [self upgradeModelWithName:modelName FromVersion:[self currentModelVersionString] toVersion:[self modelVersionString] usingMapNamed:nil];

            }
        }
        storeUrl = [NSURL fileURLWithPath: storeUrlFileName];
        
    }
    
    NSError *error = nil;
    storeCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[[self class] mmManagedObjectModel]];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
        //NSDictionary *options = [NSDictionary dictionary];
     
    if([storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error]) {
        
        [MMPreferences setValue:[[self class] modelVersionString] forKey:@"MMCoreDataCurrentModelVersion"];
        
        
        
        
    }
    else{
        /*Error for store creation should be handled in here*/
        if([MMPreferences valueForKey:@"MMCoreDataCurrentModelVersion"] != nil){
            NSLog(@"%@", [error localizedDescription]);
            NSLog(@"Failed to initailize CoreData store. Exiting");
            exit(1);
        }
        
    }
    
    return storeCoordinator;
}

+ (NSManagedObjectModel *)mmManagedObjectModelWithName:(NSString *)nameStr version:(NSString *)versionStr{
    
    NSURL *modelURL = mmAutorelease([[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@.momd/%@_%@", nameStr, nameStr, versionStr] withExtension:@"mom"]);
    NSManagedObjectModel * userModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSMutableArray * models = [NSMutableArray arrayWithObjects:[[self class] marshmallowDataModel], userModel ,nil ];
    
    mmRelease(userModel);
    
    return [NSManagedObjectModel modelByMergingModels:models ];
    
}

+ (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)nameStr version:(NSString *)versionStr{
    
    NSURL *modelURL = mmAutorelease([[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@.momd/%@_%@", nameStr, nameStr, versionStr] withExtension:@"mom"]);
    NSManagedObjectModel * model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    
    return model;
    
}

+ (NSPersistentStoreCoordinator *)storeCoordinator {
    
    return [[self class] mmPersistentStoreCoordinator];
}


+ (NSArray *)allDataModels{
    
    return nil;
    
}

+(void)setDataModelFilename:(NSString*)name{
    
    
    modelName = name;
    NSURL * url = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    
    if (url){
        [[self class] setDataModelFileURL:url];
    }
    else{
        MMLog(@"Invalid Filename!");
    }
    
}


+(void)setDataModelFileURL:(NSURL*)url{
    
    if (userManagedObjectModel == nil) {
        
        userManagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:url];
        
        if (userManagedObjectModel == nil) {
            MMLog(@"Issue: Unable to create managedObjectModel with url: %@", url);
        }
        
        MMLog(@"Model Set!");
        
    }
    else{
        //screw off, Throw exception. You can't have more than one persistent store in MM
        
    }
    
}


+ (void)setDataModel:(NSManagedObjectModel *)model{
    
    userManagedObjectModel = model;
    
}


+ (NSManagedObjectModel *)marshmallowDataModel{
    
    NSManagedObjectModel * objModel = [[NSManagedObjectModel alloc]init];
    
    
        //Entities for Marshmallow URL cache storage.
    NSEntityDescription * ed1 = [[NSEntityDescription alloc]init];
    [ed1 setName:@"MM_network_cache"];
    NSAttributeDescription * pr1 = [[NSAttributeDescription alloc]init];
    pr1.attributeValueClassName = @"NSString";
    pr1.name = @"url";
    
    NSAttributeDescription * pr2 = [[NSAttributeDescription alloc]init];
    pr2.attributeValueClassName = @"NSData";
    pr2.name = @"data";
    
    NSAttributeDescription * pr3 = [[NSAttributeDescription alloc]init];
    pr3.attributeValueClassName = @"NSDate";
    pr3.name = @"loaded";
    
    [ed1 setProperties:@[
            pr1,
            pr2,
            pr3
        ]
     ];
    
    [objModel setEntities:@[
            ed1
     
        ]
     ];
    
    //mmRelease(pr1);
    //mmRelease(pr2);
    //mmRelease(pr3);
    //mmRelease(ed1);

    
    
    return objModel;
    
   // return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];;
    
}

+(NSString *)versionId{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
}
/*
+(void)setModelVersionString:(NSString *)str{
    
    modelVersionString = str;
    
}
*/
+(NSString *)modelVersionString{
        //Return the model version string

    return (NSString *)[MMPreferences appInfoForKey:@"MMCoreDataModelVersion"];
    //return @"2";
}

+(void)setCurrentModelVersionString:(NSString *)str{
    
        //modelVersionString = str;
    
    [MMPreferences setValue:str forKey:@"MMCoreDataCurrentModelVersion"];
    
}

+(NSString *)currentModelVersionString{
        //Return the model version string

    return (NSString *)[MMPreferences valueForKey:@"MMCoreDataCurrentModelVersion"];
    //return @"1";
}



+(void)setUpgradeVersionMapDictionary:(NSDictionary *)dict{
    
    upgradePath = mmRetain(dict);
    
}

+(BOOL)upgradeModelWithName:(NSString *)modelName FromVersion:(NSString *)old toVersion:(NSString *)new usingMapNamed:(NSString *)mapName{
    
    /*
    NSMigrationManager * migrationManager = [[NSMigrationManager alloc]initWithSourceModel:<#(NSManagedObjectModel *)#> destinationModel:<#(NSManagedObjectModel *)#>]
    */
    
    NSMutableArray * upgrades = [NSMutableArray array];
    
    
    //This loop generates the upgrade path.
    //Loop setup
    if (mapName == nil && upgradePath) {
        
        NSString * oldVersion = [NSString stringWithString:old];
        NSString * intermediate;
        NSString * newVersion = [NSString stringWithString:new];
        BOOL goodPath = NO;
        BOOL badPath = NO;
        
        intermediate = oldVersion;
        
        
        
        while(!goodPath && !badPath){
            
            MMLog(@"Upgrade path generation loop");
            
            NSString * newintermediate = [upgradePath valueForKey:intermediate];
            
            if(newintermediate != nil){
                
                [upgrades addObject:@{intermediate : newintermediate}];
                if([intermediate isEqualToString:newVersion]){
                    goodPath = true;
                }
                intermediate = newintermediate;
                
            }
            else{
                badPath = true;
            }
        }
    }
    
    
    //This loop executes the upgrade path.
    if ([upgrades count] > 0) {
        
        for(NSDictionary * upgrade in upgrades){
            
            NSString * oldVersion;
            NSString * newVersion;
            NSManagedObjectModel * oldModel;
            NSManagedObjectModel * newModel;
            
            NSMigrationManager * migrationManager;
            
            BOOL ok = false;
            
            @try {
                oldVersion = (NSString *) ((NSArray * )[(NSDictionary *)upgrade allKeys])[0];
                newVersion = (NSString *) ((NSArray * )[(NSDictionary *)upgrade allValues])[0];
                
                oldModel = [self mmManagedObjectModelWithName:modelName version:oldVersion];
                newModel = [self mmManagedObjectModelWithName:modelName version:newVersion];
                
                MMLog(@"oldVersion: %@", oldVersion);
                
                NSURL * oldStoreURL =[NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                                      stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@%@" ,@"mm_app_data", oldVersion, @".sqlite"]]];
                
                NSURL * newStoreURL =[NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                                      stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@%@" ,@"mm_app_data", newVersion, @".sqlite"]]];
                
                if (oldStoreURL) {
                    MMLog(@"old url : %@", [oldStoreURL absoluteString]);
                }
                if (newStoreURL) {
                    MMLog(@"new url : %@", [newStoreURL absoluteString]);
                }
                
                if (oldModel) {
                    MMLog(@"oldModel");
                }
                if (newModel) {
                    MMLog(@"newModel");
                }
                
                migrationManager = [[NSMigrationManager alloc]initWithSourceModel:oldModel destinationModel:newModel];
                
                NSURL * mappingModelURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@_%@_to_%@", modelName, oldVersion, newVersion] withExtension:@"cdm"];
                
                NSMappingModel * mapModel = [[NSMappingModel alloc]initWithContentsOfURL:mappingModelURL];
                
                if (migrationManager) {
                    MMLog(@"migrationManager");
                }
                if (mapModel) {
                    MMLog(@"mapModel");
                }
                
                
                
                NSError * error = nil;
                
                [self migrateWithManager:migrationManager mappingModel:mapModel oldStore:oldStoreURL newStore:newStoreURL error:&error];
                
                if(error != nil){
                    
                    MMLog(@"MMCoreData: upgradeModelWithName: Error: %@", [error localizedDescription]);
                    
                }
                
            }
            @catch (NSException *exception) {
                MMLog(@"exception: %@: %@", [exception name], [exception reason]);
            }
            @finally {
                
            }
            
           
            
            
            
            
            
            
            
           // MMRelease(migrationManager);
        }
    
    }
    
    /*
    NSArray *mappingModelNames = [NSArray arrayWithObjects:@"StepOne", @"StepTwo", nil];
    NSDictionary *sourceStoreOptions = nil;
    
    NSURL *destinationStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataMigrationNew.sqlite"];
    
    NSString *destinationStoreType = NSSQLiteStoreType;
    
    NSDictionary *destinationStoreOptions = nil;
    
    /*
    for (NSString *mappingModelName in mappingModelNames) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:mappingModelName withExtension:@"cdm"];
        
        NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:fileURL];
        
        BOOL ok = [migrationManager migrateStoreFromURL:sourceStoreURL
                                                   type:sourceStoreType
                                                options:sourceStoreOptions
                                       withMappingModel:mappingModel
                                       toDestinationURL:destinationStoreURL
                                        destinationType:destinationStoreType
                                     destinationOptions:destinationStoreOptions
                                                  error:&error2];
        [mappingModel release];
    }
    
    //*/
    
    
}


+(BOOL)migrateWithManager:(NSMigrationManager *)migrationManager mappingModel:(NSMappingModel *)mapModel oldStore:(NSURL *)oldURL newStore:(NSURL *)newURL error:(NSError **)error {
    
    //NSURL *fileURL = [[NSBundle mainBundle] URLForResource:mappingModelName withExtension:@"cdm"];
    
    //NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:fileURL];
    
    BOOL ok = [migrationManager migrateStoreFromURL:oldURL
                                               type:NSSQLiteStoreType
                                            options:@{}
                                   withMappingModel:mapModel
                                   toDestinationURL:newURL
                                    destinationType:NSSQLiteStoreType
                                 destinationOptions: @{}
                                              error:error];

    if (!ok) {
        MMLog(@"Upgrade model error");
    }
    /*
    if (error != ni) {
        MMLog(@"Upgrade model error :");
    }
    */
    
    //[mappingModel release];
    return ok;
}


+(BOOL)upgradeSchemaFromModel:(NSManagedObjectModel *)oldModel toModel:(NSManagedObjectModel *)newModel usingManager:(NSMigrationManager *)migrationManager{
    
    
    return false;
    
}



+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSEntityDescription *)entityDescriptionForName:(NSString *)name{
    
    NSPersistentStoreCoordinator * coordinator = [[self class] storeCoordinator];
    
    return [[coordinator.managedObjectModel entitiesByName]objectForKey:name];

}


+(NSString *)predicateStringForDictionary:(NSString *)key value:(NSObject *)obj{
    
    NSString * comparatorString = @"==";
    NSString * objString = [NSString stringWithFormat:@"%@", obj];
    
    if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
        
    }
    if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        
    }
    if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
        
    }
    
    return [NSString stringWithFormat:@"%K%@%@", key, comparatorString, objString];
    
}

+(NSString *)predicateStringEqualsKey:(NSString *)key value:(NSObject *)obj{

    NSString * comparatorString = @"==";
    NSString * objString = [NSString stringWithFormat:@"%@", obj];
    
    if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
        
    }
    if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        
    }
    if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
        
    }
    
    return [NSString stringWithFormat:@"%K%@%@", key, comparatorString, objString];

}

+(NSEntityDescription *)entityDescriptorWithName:(NSString *)name{
    
    NSPersistentStoreCoordinator * storeCoordinator = [[self class] storeCoordinator];
    
    NSManagedObjectModel * model = storeCoordinator.managedObjectModel;
    
    return [[model entitiesByName] valueForKey:name];

}



@end

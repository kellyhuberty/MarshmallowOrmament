//
//  MMCoreData.h
//  Marshmallow
//
//  Created by Kelly Huberty on 4/10/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MMUtility.h"

/**
 @class MMCoreData is a Singleton class used to mold Marshmallow's core data infrastructure and provide single interface for all MArshmallow classes that use CoreData
 */
@interface MMCoreData : NSObject{
    

    
    
    
}


//+(NSManagedObjectContext *)mmManagedObjectContext;

+(NSManagedObjectContext *)managedObjectContext;
+(NSPersistentStoreCoordinator *)storeCoordinator;
//+(NSManagedObjectContext *)objectContext;
+(void)setDataModelFilename:(NSString*)name;
+(void)setDataModelFileURL:(NSURL*)url;
+(NSEntityDescription *)entityDescriptorWithName:(NSString *)name;
+(void)runBlock;

+(void)setUpgradeVersionMapDictionary:(NSDictionary *)dict;


@end

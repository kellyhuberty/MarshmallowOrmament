//
//  MMOrmManager.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/7/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMOrmManager.h"
#import "MMSchema.h"
#import "MMService.h"
#import "MMServiceMigrationDelegate.h"

static MMOrmManager * manager = nil;


@implementation MMOrmManager

+(instancetype)manager{
    
    if(!manager){
        
        manager = [[MMOrmManager alloc]init];
        
    }
    
    return manager;
    
}

+(void)resetSharedManager{
    
    manager = nil;
    
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
    
    [self resetSharedManager];
    
    MMOrmManager * manager = [self manager];
    
    [manager loadSchemas:schemas];
    
    //[manager loadSchemaServices]
    
}


-(void)loadSchemas:(NSArray *)scheamas{
    
    for (NSObject * obj in scheamas) {
        
        MMSchema * schema;
        
        if ([obj isKindOfClass:[NSURL class]]) {

        }
        else if([obj isKindOfClass:[NSString class]]){
            schema = [[MMSchema alloc] initWithFilename:(NSString *)obj];
        }
//        else if([obj isKindOfClass:[NSString class]]){
//            schema = [[MMSchema alloc] initWithFilename:(NSString *)obj];
//        }
//        else if([obj isKindOfClass:[MMSchema class]]){
//            schema = [[MMSchema alloc] initWithFilename:(NSString *)obj];
//        }
//        
        if (schema) {
            [self startSchemaServices:schema];
            [_schemas setObject:schema forKey:schema.name];
        }
        else{
            @throw MMException(@"Schema unable to load. No proper schema with name", @"MMInvalidArgumentException", nil);
        }
        
    }
    
}


-(void)startSchemaServices:(MMSchema *)schema{
    
    NSArray * serviceTypes = @[@"store", @"cloud"];
    
    
    
    
    for (NSString * type in serviceTypes) {
        
        
        NSError * error;
        
        NSString * serviceClassName = [schema valueForKey:[NSString stringWithFormat:@"%@ClassName", type]];
        
        if (!serviceClassName) {
            continue;
        }
        
        MMService * service = [[NSClassFromString(serviceClassName) alloc] initWithSchema:(schema)];
        
        
        NSLog(@"currentVersionForSchema %@" , [MMService currentVersionForSchemaName:schema.name type:type]);
        
        id<MMServiceMigrationDelegate>migrator = nil;
        
        MMVersionString * currentVersion = [MMService currentVersionForSchemaName:schema.name type:type];

        
        
        if ( currentVersion == nil ) {
            //initial data build....
            
            NSLog(@"Building inital store for %@", schema.name);
            
            if (schema.autoBuild) {
                
                //[[self class] buildServiceType:type forSchema:schema error:&error];
                
                [service build:&error];
                
            }
            else{
                
                if (migrator) {
                    migrator = [[self class] migrationDelegateForSchema:schema serviceType:type];
                }

                [migrator buildService:service schema:schema error:&error];
                
            }
            
        }
        else if( ![schema.version isEqualToString: currentVersion ]  ){
            //This is
            
            
            if ( [schema.version compareVersion:[MMService currentVersionForSchemaName:schema.name type:type]] == NSOrderedDescending ) {
                // downgrade schema...
                if (migrator) {
                    migrator = [[self class] migrationDelegateForSchema:schema serviceType:type];
                }

                MMVersionString * currentVersion = [MMService currentVersionForSchemaName:schema.name type:type];
                
                [migrator downgradeService:service schema:schema fromVersion:currentVersion toVersion:schema.version error:&error];
                
            }
            else if ( [schema.version compareVersion:[MMService currentVersionForSchemaName:schema.name type:type]] == NSOrderedAscending ) {
                // upgrade schema...
                if (migrator) {
                    migrator = [[self class] migrationDelegateForSchema:schema serviceType:type];
                }
                
                MMVersionString * currentVersion = [MMService currentVersionForSchemaName:schema.name type:type];
                
                [migrator upgradeService:service schema:schema fromVersion:currentVersion toVersion:schema.version error:&error];
                
            }
            
        }
        
    }
    
    
}


+(id<MMServiceMigrationDelegate>)migrationDelegateForSchema:(MMSchema *)schema serviceType:(NSString *)serviceType{
    
    NSString * classnameStr = (NSString *)[schema valueForKey:[NSString stringWithFormat:@"%@MigrationDelegateClassname", serviceType]];
    
    id<MMServiceMigrationDelegate> delegate = [[NSClassFromString(classnameStr) alloc]init];
    
    return delegate;
    
}



+(void)buildServiceType:(NSString *)serviceType forSchema:(MMSchema *)schema error:(NSError **)error{
    
    NSString * serviceClassName;
    
    if ((serviceClassName = [schema valueForKey:[NSString stringWithFormat:@"%@ClassName", serviceType]])) {
        
        
        if (NSClassFromString(serviceClassName)) {
            MMService * store = [[NSClassFromString(serviceClassName) alloc] initWithSchema:(schema)];
            
            BOOL suc = [store build:error];
            
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



@end

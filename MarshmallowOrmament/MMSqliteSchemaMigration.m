//
//  MMSqliteSchemaMigration.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/7/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSqliteSchemaMigration.h"
#import "MMSqliteStore.h"

@implementation MMSqliteSchemaMigration

-(BOOL)upgradeStore:(MMStore *)oldStore toStore:(MMStore *)newStore error:(NSError **)error{
    
    
    [self setupNewFile];
    [self renameEntityTables];
    
    //self upgradeStore:<#(MMStore *)#> toStore:<#(MMStore *)#> error:<#(NSError *__autoreleasing *)#>
    [self migrateStore];
    
    
    [self removeOldEntityTables];
    
    return NO;

}


-(BOOL)downgradeStore:(MMStore *)oldStore toStore:(MMStore *)newStore error:(NSError **)error{
    
    
    
    
    
    
    
    
    return NO;
}



-(BOOL)upgradeEntityWithName:(NSString *)entityName{
    
    
    
    
    
    
    
    
    return NO;
}


-(BOOL)migrateStore{
    
    NSArray * entities = [_olderStore.schema entities];
    
    for (MMEntity * entity in entities) {
        
        MMEntity * newEntity = [_newerStore.schema entityForName:entity.name];
        
        [self migrateEntity:newEntity fromEntity:entity migrationMap:@{}];
        
    }
    
    return true;
}

-(void)attributeMapWithEntityName:(NSString *)entityName{
    
    [self defaultAttributeMapWithEntityName:entityName];
    
}

-(BOOL)migrateEntity:(MMEntity *)newEntity fromEntity:(MMEntity *)oldEntity migrationMap:(NSDictionary *)additionalMigrations{
    
    NSMutableSet * oldNames = [NSMutableSet setWithArray:[[newEntity.attributes dictionaryForIndexKey:@"name"] allKeys]];
    NSMutableSet * newNames = [NSMutableSet setWithArray:[[oldEntity.attributes dictionaryForIndexKey:@"name"] allKeys]];
   
    [newNames intersectSet:oldNames];

    NSMutableDictionary * map = [@{} mutableCopy];
    
    for (NSString * attrName in newNames) {
        
        [map setObject:attrName forKey:attrName];
        
    }

    [map addEntriesFromDictionary:additionalMigrations];
    
    NSError __block * error;
    BOOL __block success;
    [[(MMSQLiteStore *)_newerStore dbQueue] inDatabase:^(FMDatabase * db){
       
        success = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (%@) SELECT %@ FROM %@", [self oldTableName:oldEntity.name],[self attributeNameListForKeys:map],[self attributeNameListForValues:map],[self oldTableName:oldEntity.name]] withErrorAndBindings:&error];
        
    }];
    
    
    
    
    return success;
    
}


-(NSString *)attributeNameListForKeys:(NSDictionary *)dict{
    
    NSArray * components = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSString * str = [components componentsJoinedByString:@", "];
    
    return  str;
}

-(NSString *)attributeNameListForValues:(NSDictionary *)dict{
    
    NSArray * components = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray * elements = [NSMutableArray array];
    
    for (NSString * key in components) {
        [elements addObject:dict[key]];
    }
    
    NSString * str = [components componentsJoinedByString:@", "];
    
    return  str;
    
}


-(NSDictionary *)defaultAttributeMapWithEntityName:(NSString *)entityName{
//    
//    MMEntity * oldEntity = [_olderStore.schema entityForName:entityName];
//    MMEntity * newEntity = [_newerStore.schema entityForName:entityName];
//    
    return nil;
}

- (void)setupNewFile
{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *newPath = [libraryPath stringByAppendingPathComponent:[(MMSQLiteStore *)_newerStore dbPathWithVersion:_newerStore.schema.version]];
    NSString *oldPath = [libraryPath stringByAppendingPathComponent:[(MMSQLiteStore *)_olderStore dbPathWithVersion:_olderStore.schema.version]];

    
    NSError *error;

    BOOL success = false;
   
    if (MMDebugOn()) {
        
        success = [fileManager copyItemAtPath:oldPath toPath:newPath error:&error];
        
    }
    else{
        
        success = [fileManager moveItemAtPath:oldPath toPath:newPath error:&error];
        
    }
    
    
    if (success) {
        //UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        //[removeSuccessFulAlert show];
    }
    else
    {
        NSLog(@"Could not provision file: %@ -:%@ ", newPath ,[error localizedDescription]);
    }
        
    
}


- (void)renameEntityTables
{
    
    
    NSArray * entities = [_olderStore.schema entities];
    
    for (MMEntity * entity in entities) {
        
        
        
        [((MMSQLiteStore *)_newerStore).dbQueue inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@__%@", [((MMSQLiteStore *)_olderStore) tableNameWithEntityName:entity.name ], [((MMSQLiteStore *)_olderStore) tableNameWithEntityName:entity.name] ]];
            
        }];
        
    }
    
    
}



- (void)removeOldEntityTables
{
    
    
    NSArray * entities = [_olderStore.schema entities];
    
    for (MMEntity * entity in entities) {
        
        
        
        [((MMSQLiteStore *)_newerStore).dbQueue inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@__%@", [((MMSQLiteStore *)_olderStore) tableNameWithEntityName:entity.name ], [((MMSQLiteStore *)_olderStore) tableNameWithEntityName:entity.name] ]];
            
        }];
        
        
        
        
        
    }
    
    
}


-(NSString *)oldTableName:(NSString *)entityName{
    
    return [NSString stringWithFormat:@"%@%@", [self migrationPrefix], [((MMSQLiteStore *)_olderStore) tableNameWithEntityName:entityName ]];
    
}

-(NSString *)newTableName:(NSString *)entityName{
    
    return [((MMSQLiteStore *)_newerStore) tableNameWithEntityName:entityName ];

}

- (NSString *)migrationPrefix
{
    
    
    return @"MM_OLDERVERSION__";
    
}



@end

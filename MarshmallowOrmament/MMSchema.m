//
//  MMSchema.m
//  Marshmallow
//
//  Created by Kelly Huberty on 11/8/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

//#import "MMUtility.h"

#import "MMSchema.h"
#import "MMAutoRelatedEntity.h"
#import "MMSchemaMigration.h"
#import <objc/runtime.h>
#import "MMRecord.h"
#import "MMOrmamentManager.h"

static NSMutableDictionary __strong * globalSchemas;


@interface MMSchema()



@end


NSArray * MMGetSubclasses(Class parentClass)
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}

@implementation MMSchema


+(void)initialize{
    
    //MMRelease(globalSchemas);

    globalSchemas = [[NSMutableDictionary alloc] init];
    
    
}

+(void)registerSchema:(MMSchema *)schema{
    
    NSMutableDictionary * schemaDicts = globalSchemas[schema.name];
    if (!schemaDicts) {
        globalSchemas[schema.name] = schemaDicts = [NSMutableDictionary dictionary];
    }
    schemaDicts[schema.version] = schema;
    
}


+(MMSchema *)registeredSchemaWithName:(NSString *)name version:(NSString *)version{
    
    NSMutableDictionary * schemaDicts = globalSchemas[name];
    if (!schemaDicts) {
            //globalSchemas[schema.name] = schemaDicts = [NSMutableDictionary dictionary];
        return nil;
    
    }
    
    
    
    return [schemaDicts objectForKey:version];
    
}

+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    NSLog(@"schema name file:%@", [NSString stringWithFormat:@"%@__%@", name, [[MMVersionString stringWithString:ver] pathString]]);
    
    return MMAutorelease([[MMSchema alloc]initWithDictionary:[self schemaDictionaryWithName:name version:ver]]);
    
}

+(NSDictionary *)schemaDictionaryWithName:(NSString *)name version:(NSString *)ver{
    
    NSString * filePath = [self schemaPathWithName:name version:ver ];
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
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

+(MMSchema *)currentSchemaWithName:(NSString *)name{
    
    MMVersionString * ver = [MMOrmamentManager currentVersionForSchemaName:name];
    
    return [self registeredSchemaWithName:name version:ver];
    
}


+(NSArray *)allSchemas{
    
    
    return [globalSchemas allValues];
    
}


//static MMSchema * schema;
-(id)initWithFilename:(NSString *)filename{
    
    MMLog(@"Init with filename.");

    //NSString * fullFilename = [filename stringByAppendingString:@".schema"];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    
    if(!path){
        
        [MMException([NSString stringWithFormat:@"no file found for filename: %@!", filename], @"MMFileException", nil) raise];
        return nil;
        
    }
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path] ;
    
    
    
    
    if(!dict){
        
        [MMException(@"Dictionary not parseable.", @"MMSchemaException", nil) raise];
        return nil;
        
    }
    

    if(self = [self initWithDictionary:dict]){
        
    }
    
    return self;
    
}

-(id)initWithName:(NSString *)name version:(MMVersionString *)version entities:(NSArray *)entities{
    
    
    self = nil;
    //if (!entities) {
    
        @try {
            self = [self initWithFilename:[NSString stringWithFormat:@"%@__%@",name,[[MMVersionString stringWithString:version] pathString]]];
        }
        @catch (NSException *exception) {
            if (entities) {
                [self setEntityArray:entities];
            }
            else{
                
                [MMException(@"A MMSchema must be initialized with entities, or a valid Schema discription plist with entities.", @"MMSchemaException", nil) raise];
                
            }
            
            
            
            
            
            
        }
        @finally {
            
        }
        
    //}
    
    //_name = MMRetain(name);
    self.name = name;
    self.version = version;
    //entities;
    
    
    return self;
    
}

-(id)initWithFilePath:(NSString *)path{
    
    //NSString * fullFilename = [filename stringByAppendingString:@".schema"];
    
    if(!path){
        
        [MMException([NSString stringWithFormat:@"no file found for filepath: %@!", path], @"MMFileException", nil) raise];
        return nil;
        
    }
    
    NSDictionary * dict = MMRetain([NSDictionary dictionaryWithContentsOfFile:path]);
    
    
    if(!dict){
        
        [MMException(@"Dictionary not parseable.", @"MMFileException", nil) raise];
        return nil;
        
    }
    
    
    if(self = [self initWithDictionary:dict]){
        
    }
    
    return self;
    
}

+(Class)entityClass{
    
    return [MMEntity class];
    
}



-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
        //self = [self init];
    
    NSLog(@"schema name___%@", dict[@"name"]);
    
    
        if (dict[@"name"]){
            _name = [dict[@"name"] copy];
            MMRetain(_name);
        }
        else{
            [MMException(@"Schema Dictionary contains no name", nil, nil) raise];
        }
        if ( dict[@"version"] ){
            _version = [[MMVersionString alloc] initWithString:(NSString *)dict[@"version"]];
        }
        else{
            NSLog(@"Notice: MMSchema `%@` has an unset version number. Assuming version 1.0.0.", _name);
            _version = [[MMVersionString alloc] initWithString:@"1.0.0"];
        }
        if (dict[@"storeClassName"]){
            _storeClassName = [dict[@"storeClassName"] copy];
            
            MMRetain(_storeClassName);
        }
        else{
            
        }
        if (dict[@"cloudClassName"]){
            _cloudClassName = [dict[@"cloudClassName"] copy];
            
            MMRetain(_cloudClassName);
        }
        else{
            
        }
        if ( dict[@"autoEntities"] ){
            //_version = [[MMVersionString alloc] initWithString:(NSString *)dict[@"version"]];
            self.autoEntities = YES;
        
        }
        else if ( dict[@"entities"] != nil && [dict[@"entities"] isKindOfClass:[NSArray class]]){
            NSArray * array = dict[@"entities"];

            NSMutableArray * entities = [NSMutableArray array];
            
            for ( NSDictionary * entityDict in array ) {
                
                MMEntity * entity = [[[[self class]entityClass] alloc]initWithDictionary:entityDict];
                
                //[_autoRelationships addObjectsFromArray:[entity.relationships objectsWithValue:[NSNumber numberWithBool:true] forKey:@"autoRelated"]];
                
                [entities addObject:entity];
                
                MMAutorelease(entity);
            }
            
            self.entities = entities;

        }
        else{
            //do nothing really... for serious, you don't have any entities?
        }
        if ( dict[@"migrations"] ){
            
            NSArray * array = dict[@"migrations"];
            
            NSMutableArray * migrations = [NSMutableArray array];
            
            for ( NSDictionary * migrationDictionary in array ) {
                
                MMSchemaMigration * migration = [[MMSchemaMigration alloc]initWithDictionary:migrationDictionary];
                
                //[_autoRelationships addObjectsFromArray:[entity.relationships objectsWithValue:[NSNumber numberWithBool:true] forKey:@"autoRelated"]];
                
                [migrations addObject:migration];
                
                MMAutorelease(migration);
            }
            
            self.migrations = [MMSet arrayWithArray:migrations];
            
        }
        else{
            
            //NSLog(@"Notice: MMSchema `%@` has an unset version number. Assuming version 1.0.0.", _name);
            //_version = [[MMVersionString alloc] initWithString:@"1.0.0"];
        
        }

    
    return YES;

}



-(MMEntity *)entityForModelClassName:(NSString *)className{

    NSArray * array = [_entities objectsWithValue:className forKey:@"modelClassName"];
    if ([array count] > 0) {
        return array[0];
    }
    return nil;
    
}


-(MMEntity *)entityForModelClass:(Class)class{
    
    return [self entityForModelClassName:NSStringFromClass(class)];
    
}




-(MMEntity *)entityForName:(NSString *)entityName{
    
    return [_entities objectWithValue:entityName forKey:@"name"];
    

    
    
}


-(void)setAutoEntities:(BOOL)autoEntities{
    
    _autoEntities = autoEntities;
    
    
    if(_autoEntities){
        
        [self autoLoadEntities];
        
    }
    
    
    
}



-(void)autoLoadEntities{
    
    NSArray * allSubclasses = [self allSubclassesOfClass:[MMRecord class]];
    
    NSMutableArray * entities = [NSMutableArray array];
    
    for (Class class in allSubclasses) {
        
        
        NSString * schemaName = nil;
        NSString * entityName = nil;
        
        if ((class != [MMRecord class]) && [((id<NSObject>)class) respondsToSelector:@selector(schemaName)]) {
            
            schemaName = [((id<MMRecord>)class) schemaName];
            
        }
        
        if ((class != [MMRecord class]) && [((id<NSObject>)class) respondsToSelector:@selector(entityName)]) {
            
            entityName = [((id<MMRecord>)class) entityName];
            
        }
        
        if ( [self.name isEqualToString:schemaName] && entityName) {
            
            MMEntity * entity = [MMEntity entityWithRecordClass:class];
            
            [entities addObject:entity];
            
        }
        
    }
    
    
    self.entities = entities;
    
}

-(NSArray *)allSubclassesOfClass:(Class)class{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != class);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}

-(void)setEntities:(NSArray *)entities{
    
    [_entities removeAllObjects];
    
    //return [_entities objectWithValue:entityName forKey:@"name"];
    
    for (MMEntity * en in entities) {
        
        NSArray * array = [en.relationships objectsWithValue:[NSNumber numberWithBool:YES] forKey:@"autoRelateNumber"];
        
        if (array && [array count] > 0) {
            [_autoRelationships addObjectsFromArray:array];
        }
        
        [_entities addObject:en];
        
    }
    //load dirived entities
    
    NSArray * autoRelateNames = [_autoRelationships allValuesForIndexKey:@"autoRelateName"];

    
    for (NSString * name in autoRelateNames) {
        
        //[_autoRelationships objectsWithValue:name forKey:@"autoRelateName"];
        
        MMAutoRelatedEntity * en = [MMAutoRelatedEntity autoRelatedEntityWithAutoRelationships:[_autoRelationships objectsWithValue:name forKey:@"autoRelateName"]];
        
        
        
        [_entities addObject:en];
        
    }
    
    
    
}

-(NSArray *)entities{
    
    
    return [NSArray arrayWithArray:_entities];
    
}


-(void)setMigrations:(NSArray *)migrations{
    
    [_migrations removeAllObjects];
    
    [_migrations addObjectsFromArray:migrations];
    
}

-(NSArray *)migrations{
    
    return [NSArray arrayWithArray:_migrations];
    
}








//
//-(id)initWithName:(NSString *)name version:(MMVersionString *)version entities:(NSArray *)entities{
//    
//    NSString * _name;
//    MMVersionString * _version;
//        //NSDictionary * _upgradePath;
//    NSMutableArray * _entities;
//    
//    
//}


-(id)init{
    
    self = [super init];
    NSLog(@"init");
    if (self) {
        
        //_name = ;
        //_version = ;
        //_entities = [[NSMutableDictionary alloc]init];
        _autoRelationships = [[MMSet alloc]init];
        [_autoRelationships addIndexForKey:@"autoRelateNumber"];
        [_autoRelationships addIndexForKey:@"autoRelateName"];
        [_autoRelationships addIndexForKey:@"name"];

        
        _entities = [[MMSet alloc]init];
        [_entities addIndexForKey:@"name"];
        //[_entities addIndexForKey:@"modelClassName"];

        _migrations = [[MMSet alloc]init];
        [_migrations addIndexForKey:@"fromVersion"];
        
    }
    return self;
    
}

-(NSString *)storeClassName{
    
    if (_storeClassName) {
        return _storeClassName;
    }
    
    return @"MMSQLiteStore";
    
}

-(void)setEntityArray:(NSArray *)array{
    
    MMRelease(_entities);
    
    //_entities = [[NSMutableDictionary alloc]init];
    //_entities = MMSet arrayWithArray:
    _entities = [[MMSet alloc]init];
    
    [_entities addIndexForKey:@"name"];
    //[_entities addIndexForKey:@"modelClassName"];
    
    for (MMEntity * ent in array) {
        [_entities addObject:ent];
    }
    
    
}


+(void)mainSchema{
    
    
    
}





-(void)build{
    
    
    
}

-(void)destroy{
    
    
    
    
}



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



-(BOOL)runUpgradeMigrationFromVersion:(NSString *)oldVersion toVersion:(NSString *)newVersion
{
    

    return false;
    
}

-(void)log{
    
    MMLog(@"{");

    MMLog(@"name:    %@",_name);
    MMLog(@"version: %@",_version);

    NSEnumerator * enumer = [_entities objectEnumerator];
    MMEntity * entity = nil;
    MMLog(@"entities:{");

    
    while (entity = [enumer nextObject]) {
    
        MMLog(@"    {");
        
        [entity log];
        
        MMLog(@"    }");

        
    }
    
    MMLog(@"}");
    
}

//-(BOOL)performMutation:(MMSchemaMutation *)mutation{
//    
//}
//
//
//


- (void)dealloc
{
    
    MMRelease(_name);
    MMRelease(_version);
    MMRelease(_entities);
    MMRelease(_modelClassNameIndex);
    
    #if __has_feature(objc_arc)
    #else
    [super dealloc];
    #endif
}



@end

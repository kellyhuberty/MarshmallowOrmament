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
static NSMutableDictionary __strong * globalSchemas;


@interface MMSchema()



@end


@implementation MMSchema


+(void)initialize{
    
    //MMRelease(globalSchemas);

    globalSchemas = [[NSMutableDictionary alloc] init];
    
    
}

+(void)registerSchema:(MMSchema *)schema{
    
    globalSchemas[schema.name] = schema;
    
}

+(MMSchema *)currentSchemaWithName:(NSString *)name{
    
    
    return globalSchemas[name];
    
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


-(id)initWithDictionary:(NSDictionary *)dict {
    
    self = [self init];
    
    NSLog(@"schema name___%@", dict[@"name"]);
    
    if (self) {
        
        if (dict[@"name"]){
            _name = MMRetain([dict[@"name"] copy]);
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
        if ( dict[@"entities"] != nil && [dict[@"entities"] isKindOfClass:[NSArray class]]){
            NSArray * array = dict[@"entities"];

            NSMutableArray * entities = [NSMutableArray array];
            
            for ( NSDictionary * entityDict in array ) {
                
                MMEntity * entity = [[MMEntity alloc]initWithDictionary:entityDict];
                
                //[_autoRelationships addObjectsFromArray:[entity.relationships objectsWithValue:[NSNumber numberWithBool:true] forKey:@"autoRelated"]];
                
                [entities addObject:entity];
                
                MMAutorelease(entity);
            }
            
            self.entities = entities;

        }
        else{
            //do nothing really... for serious, you don't have any entities?
        }

    }
    
    return self;

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

    }
    return self;
    
}

-(NSString *)storeClassName{
    
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

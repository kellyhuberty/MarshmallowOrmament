//
//  MMEntity.m
//  BandIt
//
//  Created by Kelly Huberty on 9/2/12.
//
//

#import "MMUtility.h"
#import "MMEntity.h"
#import "MMPreferences.h"
#import "MMAttribute.h"
#import "MMRelationship.h"
@interface MMEntity ()

+(void)initialize;
+(void)loadEntityFile;
-(void)setup;

@end


@implementation MMEntity

static NSMutableDictionary * registry;
static NSString * classPrefix;


@synthesize name = _name;
@synthesize modelClassName = _modelClassName;


/*
@synthesize controlNames = _controlNames;
@synthesize controlProperties = _controlProperties;
@synthesize displayNames = _displayNames;
@synthesize classNames = _classNames;
@synthesize attributeOrder = _attributeOrder;
*/

//+(void)initialize{
//    
//    registry = [[NSMutableDictionary alloc]init];
//
//    [[self class]loadEntityFile];
//    
//}

+(void)loadEntityFile{
    
    
    NSDictionary * dict = [MMPreferences grabPreferenceList:@"descriptors.plist"];
    
    if ([dict valueForKey:@"root"]) {
        dict = [dict valueForKey:@"root"];
    }
    
    
    
    if (dict != nil) {
        NSDictionary * entities = [dict valueForKey:@"entities"];
    }
    
    
    MMLog(@"loading entity descriptors");
}

//+(void)iterateEntities:(NSDictionary *)dict{
//    
//    NSArray * keys = [dict allKeys];
//    
//    for (NSString * key in keys) {
//        
//        NSDictionary * entityDict = [dict valueForKey:key];
//        
//        MMEntity * entity = nil;
//        
//        entity = [[MMEntity alloc]initWithName:key descriptors:[entityDict allValues]];
//        
//        entity.name = key;
//        
//        [[self class] registerEntity:entity withName:key];
//        
//    }
//
//}




-(id)init{
    self = [super init];
    if (self) {
        _attributes = [[MMSet alloc]init];
        [_attributes addIndexForKey:@"name" unique:YES];
        [_attributes addIndexForKey:@"autoincrement" unique:NO];

        
        
        _relationships = [[MMSet alloc]init];
        [_relationships addIndexForKey:@"name" unique:YES];
        [_relationships addIndexForKey:@"autoRelate" unique:NO];
        [_relationships addIndexForKey:@"autoRelateNumber" unique:NO];
        [_relationships addIndexForKey:@"autoRelateName" unique:NO];

        //[_relationships addIndexForKey:@"autoRelate" unique:NO];

    }
    
    return self;
}

-(id)initWithName:(NSString *)name{
    self = [self init];
    if (self){
        _name = name;
    }
    
    return self;
}

//-(id)initWithName:(NSString *)name attributes:(NSArray *)descript{
//    self = [self initWithName:name];
//    if (self){
//
//    }
//    
//    return self;
//}


//-(void)setup{
//    _entityMaps = [[NSMutableDictionary alloc]init];
//    
//    
//    
//}


-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
        
    if (dict[@"name"]) {
        _name = [dict[@"name"] copy];
    }
    if (dict[@"id_keys"]) {
        _idKeys = [dict[@"id_keys"] copy];
    }
    if (dict[@"idKeys"]) {
        _idKeys = [dict[@"idKeys"] copy];
    }
    if (dict[@"modelclassname"]) {
        _modelClassName = [dict[@"modelclassname"] copy];
    }
    if (self){
        NSArray * attributeDicts = [dict valueForKey:@"attributes"];
        NSMutableArray * attributes = [NSMutableArray array];
        
        for (NSDictionary * attDict in attributeDicts) {
            MMAttribute * descriptor = [MMAttribute attributeWithDictionary:attDict];
            [attributes addObject:descriptor];
        }
        [_attributes addObjectsFromArray:attributes];
        
        
        NSArray * relationshipDicts = [dict valueForKey:@"relationships"];
        NSMutableArray * relationships = [NSMutableArray array];
        
        for (NSDictionary * relDict in relationshipDicts) {
            MMRelationship * rel = [MMRelationship relationshipWithDictionary:relDict];
            rel.recordEntityName = self.name;
            [relationships addObject:rel];
        }
        [_relationships addObjectsFromArray:relationships];
        
        
    }
    
    return YES;
}





/*
-(id)initWithFileName:(NSString *)fileName{
    self = [super init];
    if (self){
        
    }
    
    return self;
}
*/


/*
+(BOOL)registerEntity:(MMEntity *)entity withName:(NSString *)name{
    
    [registry setValue:entity forKey:name];
    
}
 */

//+(void)registerEntity:(MMEntity *)entity{
//   
//    if (entity.name == nil) {
//        MMLog(@"Entity Name Nil");
//        [NSException raise:@"MMInvalidArgumentException" format:@"A vaild Entity with name must be specified."];
//    }
//    
//    [registry setValue:entity forKey:[entity name]];
//    
//}

//+(MMEntity *)registeredEntityWithName:(NSString *)name{
//    
//    return [registry valueForKey:name];
//    
//}

//+(MMEntity *)entityWithName:(NSString *)name{
//    
//    return [registry valueForKey:name];
//    
//}

/*
-(void)setDescriptionsWithName:(NSString *)name{
    
    NSDictionary * dict = [MMPreferences entityDescriptors];
    NSArray * attributes = [[dict objectForKey:name] objectForKey:@"attributes"];
    NSMutableArray * descriptors = [[NSMutableArray alloc] init];
    
    MMLog(@" %@", descriptors);
    MMLog(@" %@", attributes);
    MMLog(@" %@", dict);
    
    
    
    for (int i = 0; i < [attributes count]; ++i) {
        [descriptors addObject:[MMKeyValueDescriptor descriptorWithDictionary:[attributes objectAtIndex:i]]];
    }
    
    [self defineData:descriptors];
    
}
*/
/*
-(NSEntityDescription *)entityDescription{
    


}


-(BOOL)defineWithEntityFileName:(NSString *)fileName{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:name ofType:@"plist"] ];
    
    [ self defineData: [dict objectForKey:@"attributes"] ];

}
*/
-(NSString *)storeName{
    
    // MMRelease(_entityDescription);
    // _entityDescription = [MMCoreData entityDescriptorWithName:name];

    return _name;
    
}



-(void)setName:(NSString *)name{
   
   // MMRelease(_entityDescription);
   // _entityDescription = [MMCoreData entityDescriptorWithName:name];
    MMRelease(_name);
    _name = MMRetain(name);
    
}


-(MMAttribute *)attributeWithName:(NSString *)name{
    
    if ([_attributes objectWithValue:name forKey:@"name"]) {
        
        //NSLog(@"attr blah %@", [_attributes objectWithValue:name forKey:@"name"]);
        return [_attributes objectWithValue:name forKey:@"name"];
    }
    //NSLog(@"FUCK");exit(1);
    return nil;
}


-(MMRelationship *)relationshipWithName:(NSString *)name{
    
    if ([_relationships objectWithValue:name forKey:@"name"]) {
        
        //NSLog(@"attr blah %@", [_attributes objectWithValue:name forKey:@"name"]);
        return [_relationships objectWithValue:name forKey:@"name"];
    }
    //NSLog(@"FUCK");exit(1);
    return nil;
}


/*
-(void)setEntityDescription:(NSEntityDescription *)entityDescription{
    
    MMRelease(_entityDescription);
    _entityDescription = MMRelease(entityDescription);
    _name = _entityDescription.name;
    
}
 */
/*
-(NSEntityDescription *)entityDescription{
    if (_entityDescription == nil) {
        if (_name != nil) {
            
        
            _entityDescription = [MMCoreData entityDescriptorWithName:_name];
        }
        else{
            
            [NSException raise:@"MMInternalInconsistencyException" format:@"MMEntity instance cannot pull NSEntityDescription because name identifier is nil"];
            
        }
        if (_entityDescription == nil) {
            [NSException raise:@"MMInternalInconsistencyException" format:@"MMEntity instance cannot pull NSEntityDescription because name identifier is invalid. Make sure you have an entity in your core data model that matches name: %@", _name];
        }
        
    }
    
    
    return _entityDescription;
}
*/
//-(void)setEntityMap:(MMDataMap *)map forAPIName:(NSString *)apiName{
//    
//    if ( _defaultEntityMap == nil ) {
//        _defaultEntityMap = map;
//    }
//    
//    [_entityMaps setValue:map forKey:apiName];
//    
//}
//
//-(MMDataMap *)entityMapForAPIName:(NSString *)apiName{
//    
//    return [_entityMaps valueForKey:apiName];
//    
//}

//-(void)setDefaultEntityMap:(MMDataMap *)map{
//    MMRelease(_defaultEntityMap);
//    _defaultEntityMap = MMRetain(map);
//    
//    
//}


//-(void)setUniqueIndex:(NSArray *)index{
//
//    MMRelease(_uniqueIndex);
//    _uniqueIndex = MMRetain(index);
//    
//    
//}
//
//-(NSArray*)uniqueIndex{
//    
//    return _uniqueIndex;
//    
//}

//-(NSArray *)attributeOrder{
//    
//    if (!_attributeOrder && ([[_attributes allKeys] count] == [_attributeOrder count])) {
//        
//        _attributeOrder = MMRetain([[_attributes allKeys] sortedArrayUsingSelector:@selector(compare:)]);
//        
//    }
//    
//    return [NSArray arrayWithArray:_attributeOrder];
//}

//-(NSArray *)sqlAttributeOrder{
//    
//    NSMutableArray * array = [NSMutableArray array];
//    
//    for (NSString * key in _attributeOrder) {
//    
//        MMAttribute * attr = [_attributes :key];
//    
//        [array addObject:attr.storeName];
//    
//    }
//    
//    return [NSArray arrayWithArray:array];
//}


//-(NSString *)backingNameForKey:(NSString *)key{
//    
//    MMAttribute * attr = [_attributes valueForKey:key];
//
//    return attr.storeName;
//    
//}

+(void)setModelClassNamePrefix:(NSString *)prefix{
    classPrefix = MMRetain([prefix uppercaseString]);
}

//-(NSString *)createTableSQL{
//    
//    NSMutableString * sql = [NSMutableString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@ ", _resourceName];
//    
//    for (MMAttribute * attr in _attributes) {
//        [sql appendString:[NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@", _resourceName]];
//    }
//    
//    return [NSString stringWithString:sql];
//}

//-(NSDictionary *)defaultMutationAttributesMap{
//    
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//
//    for (NSString * attName in self.attributeOrder) {
//        
//        [dict setObject:attName forKey:attName];
//        
//    }
//    
//    return dict;
//    
//}





-(NSArray *)idKeys{
    
    if (_idKeys && [ _idKeys isKindOfClass:[NSArray class] ]) {
        return [_idKeys copy];
    }
    
    NSArray * keys = nil;
    
    if (keys = [_attributes objectsWithValue:[NSNumber numberWithBool:YES] forKey:@"autoincrement"]) {
        return [keys copy];
    }

    return @[@"ROWID"];
    
}



-(void)destroy{
    
    
    
    
}


-(void)log{
    
    
    MMLog(@"    name:    %@",_name);
    //MMLog(@"version: %@",_version);
    MMLog(@"    Model Class Name: %@", _modelClassName);

    MMLog(@"    Attributes:");

    MMLog(@"    {");

    
    for (MMAttribute * attr in _attributes) {
        
        MMLog(@"        {");
            [attr log];
        MMLog(@"        }");
        
        
    }
    
    MMLog(@"    }");

    
    MMLog(@"    Relationships:");
    
    MMLog(@"    {");
    
    
    for (MMRelationship * relationship in _relationships) {
        
        MMLog(@"        {");
            [relationship log];
        MMLog(@"        }");
        
        
    }
    
    MMLog(@"    }");
    
    
}


-(void)dealloc{
    
    
    MMRelease(_name);
    MMRelease(_modelClassName);
    MMRelease(_idKeys);
    //MMRelease( _defaultEntityMap);
    //MMRelease(_entityDescription);
    
        //MMDataMap * _recordMap;
    
    
#if __has_feature(objc_arc)
    
#else
    [super dealloc];
#endif
    
}




@end

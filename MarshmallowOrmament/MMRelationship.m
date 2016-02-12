//
//  MMRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRelationship.h"
#import "MMService.h"
#import "MMSet.h"
#import "MMRelation.h"
#import "MMRelater.h"
@implementation MMRelationship


//+(MMStore *)store{
//    
////    return [MMStore storeWithSchemaName:[self schemaName] version:nil];
//    
//}

//
//-(MMRelationship *)setNextRelation:(MMRelationship *)next{
//    
//    
//    next.lastRelation = self
//    _nextRelation = MMRetain(next);
//    
//}


+(instancetype)relationshipWithDictionary:(NSDictionary *)dict schema:(MMSchema *)schema{
    
    return MMAutorelease([[[self class] alloc] initWithDictionary:dict schema:schema]);
    
}



//+(instancetype)hasManyRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
//    
//    return [[[self class] alloc] initWithSchema:<#(MMSchema *)#>];
//
//    
//    
//}
//
//
//+(instancetype)hasOneRelationshipWithName:(NSString *)name localClass:(Class)localClass relatedClass:(Class)relatedClass storeRelater:(MMRelater *)storeRelator cloudRelater:(MMRelater *)cloudRelator{
//    
//    
//    
//    
//    
//}



-(id)init{
    NSAssert(false, @"%@ can not be instantiated with init. Use initWithSchema:", NSStringFromClass([self class]));
    return nil;
}

-(id)initWithDictionary:(NSDictionary *)dict{
    NSAssert(false, @"%@ can not be instantiated with initWithDictionary:. Use initWithDictionary:schema:", NSStringFromClass([self class]));
    return nil;
}

-(id)initWithDictionary:(NSDictionary *)dict schema:(MMSchema *)schema{
    
    //    NSArray * arr = [dict allKeys];
    //
    //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];
    //
    //    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
    //
    
    if(self = [self initWithSchema:schema]){
        
        NSError * error;
        
        [self loadFromDictionary:dict error:&error];
        
        [self loadMetaFromDictionary:dict error:&error];
        
        
    }
    
    return self;
    
}

-(instancetype)initWithSchema:(MMSchema *)schema{
    
    if(self = [super init]){
        _schema = schema;
        _links = [[MMSet alloc]init];
        _hasMany = YES;
        _autoRelate = NO;

    }
    
    return self;
    
}

-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
    
    NSArray * relations;

    _name = [dict[@"name"] copy];
    
    if ((relations = dict[@"links"])) {
        
        for (NSObject * relDat in relations) {
        
            if ([relDat isKindOfClass:[NSString class]]) {
                [_links addObject: [ MMRelation relationWithRelationFormat:relDat ]];
            }
            if ([relDat isKindOfClass:[NSDictionary class]]) {
                [_links addObject: [ MMRelation relationWithDictionary:relDat ]];
            }
            
        }
        
    }
    if (dict[@"hasMany"]) {
        
        _hasMany = [dict[@"hasMany"] boolValue];
        
    }
    if (dict[@"shareable"]) {
        
        _shareable = [dict[@"shareable"] boolValue];
        
    }
    if (dict[@"autoRelate"]) {
        
        _autoRelate = [dict[@"autoRelate"] boolValue];
        
    }
    if (dict[@"autoRelateName"]) {
        
        _autoRelateName = [dict[@"autoRelateName"] copy];
        
    }
    
    _className = [dict[@"className"] copy];
    _relatedEntityName = [dict[@"entityName"] copy];

    if (!_relatedEntityName) {
        _relatedEntityName = [[NSClassFromString(_className) entityName]copy];
    }
        
    
    return YES;
    
}



-(void)log{
    
    MMLog(@"                ");
    
    MMLog(@"            name:%@", _name);
    MMLog(@"            classname: %@", _className);
    MMLog(@"            classname: %@", _relatedEntityName);
    
    for (MMRelation * relation in _links) {
        
        MMLog(@"            {");
        MMLog(@"            }");
        
        
    }
    
}


-(BOOL)onSelf{
    
    return [_relatedEntityName isEqualToString:_localEntityName];
    
}


-(NSNumber *)autoRelateNumber{
    
    return [NSNumber numberWithBool:_autoRelate];
    
}


-(void)setCloudRelater:(MMRelater *)cloudRelater{
    
    cloudRelater.relationship = self;
    _cloudRelater = cloudRelater;
    
}

-(void)setStoreRelater:(MMRelater *)storeRelater{
    
    storeRelater.relationship = self;
    _storeRelater = storeRelater;
    
}



@end

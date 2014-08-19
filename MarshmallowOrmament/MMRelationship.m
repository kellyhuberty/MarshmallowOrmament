//
//  MMRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRelationship.h"
#import "MMStore.h"

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


+(instancetype)relationshipWithDictionary:(NSDictionary *)dict{
    
    return MMAutorelease([[[self class] alloc] initWithDictionary:dict]);
    
}

-(instancetype)init{
    
    if(self = [super init]){
        
        _links = [[MMSet alloc]init];
        _hasMany = YES;
        _autoRelate = YES;

    }
    
    return self;
    
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [self init]){
        
        NSArray * relations;

        _name = [dict[@"name"] copy];
        
        if (relations = dict[@"links"]) {
            
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
        if (dict[@"autoRelate"]) {
            
            _autoRelate = [dict[@"autoRelate"] boolValue];
            
        }
        if (dict[@"autoRelateName"]) {
            
            _autoRelateName = [dict[@"autoRelateName"] copy];
            
        }
        
        _className = [dict[@"className"] copy];
        _entityName = [dict[@"entityName"] copy];

        if (!_entityName) {
            _entityName = [[NSClassFromString(_className) entityName]copy];
        }
        
        
    }
    
    return self;
    
}



-(void)log{
    
    MMLog(@"                ");
    
    MMLog(@"            name:%@", _name);
    MMLog(@"            classname: %@", _className);
    MMLog(@"            classname: %@", _entityName);
    
    for (MMRelation * relation in _links) {
        
        MMLog(@"            {");
        MMLog(@"            }");
        
        
    }
    
}


-(BOOL)onSelf{
    
    return [_entityName isEqualToString:_recordEntityName];
    
}


-(NSNumber *)autoRelateNumber{
    
    return [NSNumber numberWithBool:_autoRelate];
    
}




@end

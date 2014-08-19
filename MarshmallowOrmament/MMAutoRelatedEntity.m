//
//  MMAutoRelatedEntity.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/14/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMAutoRelatedEntity.h"
#import "MMRelationship.h"
#import "MMAttribute.h"
@implementation MMAutoRelatedEntity

-(instancetype)initWithAutoRelationships:(NSArray *)relationships{
    
    MMRelationship * rel = relationships[0];
    
    if(self = [super init]){
        
        self.name = [rel.autoRelateName copy];
        
        [self.attributes addIndexForKey:@"name" unique:YES];
        
        [self deriveAttributes:relationships];
        
    }
 
    return self;
    
}

+(instancetype)autoRelatedEntityWithAutoRelationships:(NSArray *)relationships{
    
    MMAutoRelatedEntity * en = [[[self class] alloc]initWithAutoRelationships:relationships];
    
    MMAutorelease(en);
    
    return en;
    
}


-(void)deriveAttributes:(NSArray *)relationships{
    
//    MMAttribute * attribute = [MMAttribute attributeWithDictionary:@{@"name":[self attributeNameForRelation:]
//                                                                     @"classname":@"NSNumber",
//                                                                     @"primative":@"int",
//                                                                    }];

    
    for (MMRelationship * rel in relationships) {
        
        [rel log];
        
        MMAttribute * attribute = [MMAttribute attributeWithDictionary:@{@"name":[self attributeNameForRelation:rel],
                                                                         @"classname":@"NSNumber",
                                                                         @"primative":@"int"
                                                                         }];
        
        
        [self.attributes addObject:attribute];
        
        
        attribute = [MMAttribute attributeWithDictionary:@{@"name":[self foreignAttributeNameForRelation:rel],
                                                                         @"classname":@"NSNumber",
                                                                         @"primative":@"int"
                                                                         }];
        
        
        [self.attributes addObject:attribute];
        
        
        
        
    }
    
    
}

-(NSString *)attributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.recordEntityName];
    
//    if ([relationship onSelf]) {
//        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
//    }
    
    return name;
    
}


-(NSString *)foreignAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.entityName];
    
//    if ([relationship onSelf]) {
//        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
//    }
    
    return name;
    
}


@end

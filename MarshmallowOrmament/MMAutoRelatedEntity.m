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
        
        NSString * localAttrName = [self localAttributeNameForRelation:rel];
        NSString * foreignAttrName = [self foreignAttributeNameForRelation:rel];

        
        MMAttribute * localAttribute = [self.attributes objectWithValue:localAttrName forKey:@"name"];
        MMAttribute * foreignAttribute = [self.attributes objectWithValue:foreignAttrName forKey:@"name"];

        
        if(!localAttribute){

            localAttribute = [MMAttribute attributeWithDictionary:@{@"name":[self localAttributeNameForRelation:rel],
                                                                         @"classname":@"NSNumber",
                                                                         @"primative":@"int"
                                                                         }];
            [self.attributes addObject:localAttribute];

        
        }
        
        
        
        if(!foreignAttribute){
            foreignAttribute = [MMAttribute attributeWithDictionary:@{@"name":[self foreignAttributeNameForRelation:rel],
                                                                             @"classname":@"NSNumber",
                                                                             @"primative":@"int"
                                                                             }];
            [self.attributes addObject:foreignAttribute];
            
        }
        
        
        /*
        if (rel.shareable) {
            localAttribute.unique = NO;
        }
        else{
            localAttribute.unique = YES;
        }
        
    
        if (rel.hasMany) {
            foreignAttribute.unique = NO;
        }
        else{
            foreignAttribute.unique = YES;
        }
        */
        
        
    }
    
    
}

-(NSString *)localAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.recordEntityName];
    
//    if ([relationship onSelf]) {
//        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
//    }
    
    return name;
    
}


-(NSString *)foreignAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.entityName];
    
    
    [self.attributes objectWithValue:name forKey:@"name"];
    
//    if ([relationship onSelf]) {
//        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
//    }
    
    return name;
    
}


@end

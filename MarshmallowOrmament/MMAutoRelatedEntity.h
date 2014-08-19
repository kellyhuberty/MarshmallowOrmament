//
//  MMAutoRelatedEntity.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/14/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMEntity.h"

@interface MMAutoRelatedEntity : MMEntity


-(instancetype)initWithAutoRelationships:(NSArray *)relationships;
+(instancetype)autoRelatedEntityWithAutoRelationships:(NSArray *)relationships;

-(NSString *)attributeNameForRelation:(NSArray *)relationships;

@end

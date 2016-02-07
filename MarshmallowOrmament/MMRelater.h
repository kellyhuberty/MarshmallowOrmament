//
//  MMRelator.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/25/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMSchemaObject.h"
@class MMRelationship;
@interface MMRelater : MMSchemaObject{
    
    
    MMRelationship * __weak _relationship;
    
    
}
@property(nonatomic, weak)MMRelationship * relationship;

@end

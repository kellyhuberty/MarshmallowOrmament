//
//  NSMutableArray+Marshmallow.m
//  Marshmallow
//
//  Created by Kelly Huberty on 1/20/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import "NSMutableArray+Marshmallow.h"

@implementation NSMutableArray (Marshmallow)

-(void)insertObject:(id)anObject atAbsoluteIndex:(NSUInteger)index
{
    
    int count = [self count];
    
    if(index < count){
        
        id object;
        
        object = [self objectAtIndex:index];
        
        if ([object isKindOfClass:[NSNull class]]) {
            
            
            [self removeObjectAtIndex:index];
            [self insertObject:anObject atIndex:index];
            
        }
        else{
            
            [self insertObject:anObject atIndex:index];
            
        }
        
    }
    else if(index >= count){
        
        int startCount = count;
        
        while (startCount > ([self count] - 1) ) {
            
            [self addObject: [NSNull null]];
            
        }
        
        [self addObject: [NSNull null]];
        
    }
    
}


@end

//
//  MMOrmMeta.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMOrmMeta.h"

@implementation MMOrmMeta




- (instancetype)initWithObjects:(const id [])objects
                        forKeys:(const id<NSCopying> [])keys
                          count:(NSUInteger)count{
    if (self = [super init]) {
        _dict = [[NSMutableDictionary alloc]initWithObjects:objects forKeys:keys count:count];
    }
    
    return self;
    
}


-(id)objectForKey:(id)aKey{
    
    return _dict[aKey];
    
}


-(NSEnumerator *)keyEnumerator{
    
    return [_dict keyEnumerator];

}



@end

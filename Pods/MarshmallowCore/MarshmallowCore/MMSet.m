//
//  MMSet.m
//  Marshmallow
//
//  Created by Kelly Huberty on 2/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSet.h"
#import "MMUtility.h"
@implementation MMSet

#pragma mark init Overides

- (id)init
{
    self = [super init];
    if (nil == self){
        return nil;
    }
    _arr = [NSMutableArray new];
    _indexes = [NSMutableDictionary new];
    _unique = [NSMutableDictionary new];
    return self;
}


-(void)addIndexForKey:(NSString *)key{
    
    [self addIndexForKey:key unique:NO];
    
}

-(void)addIndexForKey:(NSString *)key unique:(BOOL)unique{
    
    if (!_indexes[key]) {
        _indexes[key] = [NSMutableDictionary dictionary];
    }
    
    if (unique) {
        [_unique setObject:key forKey:key];
    }
    
    
}

-(void)indexAllForKey:(NSString *)key{
    
    [self addIndexForKey:key];
    
    for (NSObject * obj in _arr) {
        [((NSMutableDictionary *)_indexes[key]) setObject:obj forKey:[obj valueForKey:key]];
    }
    
}

-(void)indexObject:(NSObject *)obj{
    
    NSArray * keys = [_indexes allKeys];
    
    for (NSString * key in keys) {
        
        NSObject * value = nil;
        
        @try {
            value = [obj valueForKey:key];
        }
        @catch (NSException *exception) {
            
        }

        if (value && [value conformsToProtocol:@protocol(NSCopying)]) {
            
            if ( [(NSMutableDictionary *)_indexes[key] objectForKey:value] == nil ) {
                
                [((NSMutableDictionary *) _indexes[key]) setObject:[NSMutableArray arrayWithObjects:obj, nil] forKey:(id<NSCopying>)value];
            
            }
            else{
                
                NSMutableArray * array = [(NSMutableDictionary *)_indexes[key] objectForKey:value];
                
                if ([_unique valueForKey:key] && obj) {
                    [array removeAllObjects];
                }
                
                [array addObject:obj];
                
            }
        
        
        }
        
    }
    
}

-(void)removeIndexForObject:(NSObject *)obj{
    
    NSArray * keys = [_indexes allKeys];
    
    for (NSString * key in keys) {
        
        NSObject * value = nil;
        
        @try {
            value = [obj valueForKey:key];
        }
        @catch (NSException *exception) {
            
        }
        
        if (value && [value conformsToProtocol:@protocol(NSCopying)]) {
            [((NSMutableDictionary *) _indexes[key]) setObject:obj forKey:(id<NSCopying>)value];
        }
        
    }
}

-(NSArray *)objectsWithValue:(id<NSCopying>)value forKey:(NSString *)key{
    
    NSMutableDictionary * dict = _indexes[key];
    
    if(dict){
        
        return [NSArray arrayWithArray:dict[value]];
        
    }
    
    return @[];
    
}


-(id)objectWithValue:(id<NSCopying>)value forKey:(NSString *)key{
    
    NSMutableDictionary * dict = _indexes[key];
    
    if(dict){
        
        return ((NSArray *)dict[value])[0];
        
    }
    
    return nil;
    
}



//-(void)indexAllForKey:(NSString *)key{
//    
//    [self addIndexForKey:key];
//    
//    for (NSObject * obj in _arr) {
//        [((NSMutableDictionary *)_indexes[key]) setObject:obj forKey:[obj valueForKey:key]];
//    }
//    
//}

-(void)checkObjectValidity:(id)obj{
    

    
}

-(void)dealloc{
    
    mmRelease(_arr);
    mmRelease(_indexes);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

#pragma mark NSArray Overides
-(int)count{
    
    return [_arr count];
    
}

-(id)objectAtIndex:(NSUInteger)index{
    
    return [_arr objectAtIndex:index];
    
}


#pragma mark NSMutableArray Overides
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    [self checkObjectValidity:anObject];
    
    [_arr insertObject:anObject atIndex:index];
    
    [self indexObject:anObject];

}


- (void)removeObjectAtIndex:(NSUInteger)index{
    
    NSObject * obj = [_arr objectAtIndex:index];
    
    [_arr removeObjectAtIndex:index];
    
    [self removeIndexForObject:obj];
    
}

- (void)addObject:(id)anObject{

    [self checkObjectValidity:anObject];
    
    [_arr addObject:anObject];

    [self indexObject:anObject];
    
}


- (void)removeLastObject{
    
    
    [_arr removeLastObject];
    
    
    
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    
    [self checkObjectValidity:anObject];
    
    [_arr replaceObjectAtIndex:index withObject:anObject];
    
}


@end

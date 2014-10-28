//
//  MMSet.h
//  Marshmallow
//
//  Created by Kelly Huberty on 2/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSet : NSMutableArray{
    
    BOOL _dirty;
    NSMutableArray * _arr;
    NSMutableDictionary * _indexes;
    NSMutableDictionary * _unique;

    //NSString * _indexPropertyName;
    //NSString * _enforcedClassName;
    
    NSLock * lock;
    BOOL _lockManually;
    
    
}
@property(nonatomic, retain)NSMutableDictionary * indexes;
@property(nonatomic, retain)NSString * indexPropertyName;
//@property(atomic, retain) Class enforcedClass;

-(void)objectForKey:(id)obj;
//-(void)setObject:(id)obj forKey:(NSObject *)key;

-(void)addIndexForKey:(NSString *)key;
-(void)addIndexForKey:(NSString *)key unique:(BOOL)unique;

-(void)indexAllForKey:(NSString *)key;

-(NSArray *)objectsWithValue:(id<NSCopying>)value forKey:(NSString *)key;


-(NSLock *)lockManually;
-(void)lockAutomatically;

@end

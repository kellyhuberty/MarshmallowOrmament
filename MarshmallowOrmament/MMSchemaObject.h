//
//  MMSchemaObject.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSchemaObject : NSObject{
    
    NSDictionary * _meta;
    
    
}

-(id)init;
-(id)initWithDictionary:(NSDictionary *)dict;


-(NSObject *)metaForKeyPath:(NSString *)keyPath;
-(void)setMeta:(NSObject *)obj forKeyPath:(NSString *)keyPath;

-(void)setMeta:(NSObject *)obj forKey:(NSString *)key serviceType:(NSString *)serviceType;
-(NSObject *)metaForKey:(NSString *)key serviceType:(NSString *)serviceType;

@end

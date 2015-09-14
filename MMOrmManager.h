//
//  MMOrmManager.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/7/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMOrmManager : NSObject{
    
    
    NSMutableDictionary * _schemas;
    NSMutableDictionary * _services;
    NSMutableDictionary * _records;

    
}


+(instancetype)manager;
+(void)resetSharedManager;
-(void)loadSchemasAtURLs:(NSArray *)scheamas;
+(void)startWithSchemas:(NSArray *)schemas;
-(void)startWithSchemas:(NSArray *)schemas;

@end

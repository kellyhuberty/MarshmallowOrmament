//
//  MMOrmMeta.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMOrmMeta : NSMutableDictionary{
    
    NSMutableDictionary * _dict;
    NSString * _type;
    
}
@property (nonatomic, retain)NSString * type;




@end

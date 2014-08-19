//
//  MMSQLiteRequest.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRequest.h"

@interface MMSQLiteRequest : MMRequest{
    
    NSString * _sqliteQuery;
    NSMutableDictionary * _parameterDictionary;
    
}
@property(nonatomic, readonly)NSMutableDictionary * parameterDictionary;

@property(nonatomic, retain)NSString * sqliteQuery;

@end

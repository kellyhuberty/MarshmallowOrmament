//
//  MMSQLiteRequest.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRequest.h"

@interface MMSQLiteRequest : MMRequest{
    
//    NSString * _sqliteQuery;
//    NSMutableDictionary * _parameterDictionary;

    NSString * _sqlSelect;
    NSString * _sqlFrom;
    NSString * _sqlWhere;
    NSString * _sqlGroupBy;
    NSString * _sqlOrderBy;
    NSMutableDictionary * _sqlBindValues;
    
}
@property(atomic, retain)NSString * sqlSelect;
@property(atomic, retain)NSString * sqlFrom;
@property(atomic, retain)NSString * sqlWhere;
@property(atomic, retain)NSString * sqlGroupBy;
@property(atomic, retain)NSString * sqlOrderBy;
@property(atomic, retain, readonly)NSMutableDictionary * sqlBindValues;
    //@property(nonatomic, retain)NSString * sqliteQuery;

@end

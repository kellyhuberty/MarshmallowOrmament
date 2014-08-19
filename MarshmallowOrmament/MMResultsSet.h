//
//  MMResultsSet.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSet.h"
#import "MMSQLiteStore.h"


@interface MMResultsSet : MMSet{
    
    MMSQLiteStore * _store;
    NSString * _fillClassName;
    NSString * _query;
    int _limit;
    int _offset;
    
}
@property (nonatomic, retain)MMStore * store;


@end

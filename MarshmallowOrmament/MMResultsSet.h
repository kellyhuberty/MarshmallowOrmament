//
//  MMResultsSet.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSet.h"
//#import "MMSQLiteStore.h"

enum {
    MMResultsSetNoTotal = -1,
    MMResultsSetNoOffset = -1
};

@interface MMResultsSet : MMSet{
    
//    MMSQLiteStore * _store;
//    NSString * _fillClassName;
//    NSString * _query;
    
      MMSet * _groups;
      int _offset;
      int _total;
    
    int _maxFetchSize;

}
@property (atomic, readonly)int total;
@property (atomic)int offset;


//-()setOffset:(int)offset totalResults:(int)totalResults;

-(MMSet *)groupAtIndex:(int)index;




@end

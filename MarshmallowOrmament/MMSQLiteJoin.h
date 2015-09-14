//
//  MMSQLiteJoin.h
//  Pods
//
//  Created by Kelly Huberty on 6/16/15.
//
//

#import <Foundation/Foundation.h>
#import "MMSet.h"

@interface MMSQLiteJoin : NSObject{
    
    NSString * _leftTableName;
    NSString * _joinType;
    NSString * _rightTableName;
    MMSet * _conditionals;
    
}

@end


@interface MMSQLiteConditional : NSObject{
    
    NSString * _leftTableName;
    NSString * _leftAttributeName;
    
    NSString * _operator;
    
    NSString * _rightTableName;
    NSString * _rightAttributeName;
    
    
}

@end

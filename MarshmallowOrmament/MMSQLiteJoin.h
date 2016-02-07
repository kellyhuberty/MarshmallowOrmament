//
//  MMSQLiteJoin.h
//  Pods
//
//  Created by Kelly Huberty on 6/16/15.
//
//

#import <Foundation/Foundation.h>
#import "MMSet.h"
@class MMSQLiteConditional;

@interface MMSQLiteJoin : NSObject{

//    NSString * _leftDatabaseName;
//    NSString * _leftTableName;
    NSString * _joinType;
    NSString * _rightDatabaseName;
    NSString * _rightTableName;

    //MMSQLiteJoin * _nextJoin;
    MMSet * _conditionals;
    
}
@property(nonatomic, readonly) NSString * leftTableName;
@property(nonatomic, readonly) NSString * joinType;
@property(nonatomic, readonly) NSString * rightTableName;

+(instancetype)joinWithLeftTable:(NSString *)leftTable toRightTable:(NSString *)rightTable joinType:(NSString *)joinType conditionals:(NSArray *)conditionals;

-(MMSet<MMSQLiteConditional *>*)allConditionals;

@end



@interface MMSQLiteConditional : NSObject{
    
    NSString * _leftTableName;
    NSString * _leftAttributeName;
    
    NSString * _operation;
    
    NSString * _rightTableName;
    NSString * _rightAttributeName;
    
    
}
@property(nonatomic, readonly) NSString * leftTableName;
@property(nonatomic, readonly) NSString * leftAttributeName;
@property(nonatomic, readonly) NSString * operation;
@property(nonatomic, readonly) NSString * rightTableName;
@property(nonatomic, readonly) NSString * rightAttributeName;


+(instancetype)conditionalWithLeftTable:(NSString *)leftTable attribute:(NSString *)leftAttribute operator:(NSString *)op rightTable:(NSString *)rightTable attribute:(NSString *)rightAttribute;

-(instancetype)initWithLeftTable:(NSString *)leftTable attribute:(NSString *)leftAttribute operator:(NSString *)op rightTable:(NSString *)rightTable attribute:(NSString *)rightAttribute;

@end

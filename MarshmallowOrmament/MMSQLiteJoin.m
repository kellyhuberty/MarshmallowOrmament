//
//  MMSQLiteJoin.m
//  Pods
//
//  Created by Kelly Huberty on 6/16/15.
//
//

#import "MMSQLiteJoin.h"

@implementation MMSQLiteJoin

+(instancetype)joinWithLeftTable:(NSString *)leftTable toRightTable:(NSString *)rightTable joinType:(NSString *)joinType conditionals:(NSArray *)conditionals{
    
    return [[[self class]alloc] initWithLeftTable:leftTable toRightTable:rightTable joinType:joinType conditionals:conditionals];
    
}

-(instancetype)initWithLeftTable:(NSString *)leftTable toRightTable:(NSString *)rightTable joinType:(NSString *)joinType conditionals:(NSArray *)conditionals{
    
    self = [super init];
    
    _leftTableName = leftTable;
    _joinType = joinType;
    _rightTableName = rightTable;
    _conditionals = [MMSet arrayWithArray:conditionals];
    
    return self;
}


-(MMSet<MMSQLiteConditional *>*)allConditionals{
    
    return [_conditionals copy];
    
}
//+(MMSQLiteJoin *)joinWithJoiningFormat:(NSString *)joiningFormat{
//    
//    MMSQLiteJoin * join = [[MMSQLiteJoin alloc]init];
//    
//    
//    
//    
//    
//    return join
//    
//}


@end


@implementation MMSQLiteConditional


-(instancetype)initWithLeftTable:(NSString *)leftTable attribute:(NSString *)leftAttribute operator:(NSString *)op rightTable:(NSString *)rightTable attribute:(NSString *)rightAttribute{
    
    self = [super init];
    
    _leftTableName = leftTable;
    _leftAttributeName = leftAttribute;
    _operation = op;
    _rightTableName = rightTable;
    _rightAttributeName = rightAttribute;
    
    
    return self;
    
}


+(instancetype)conditionalWithLeftTable:(NSString *)leftTable attribute:(NSString *)leftAttribute operator:(NSString *)op rightTable:(NSString *)rightTable attribute:(NSString *)rightAttribute{
    
    
    return  [[[self class] alloc]initWithLeftTable:leftTable attribute:leftAttribute operator:op rightTable:rightTable attribute:rightAttribute];
    
}


//+(MMSQLiteJoin *)joinWithJoiningFormat:(NSString *)joiningFormat{
//
//    MMSQLiteJoin * join = [[MMSQLiteJoin alloc]init];
//
//
//
//
//
//    return join
//
//}


@end

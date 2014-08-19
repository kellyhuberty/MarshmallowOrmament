//
//  MMCondition.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/28/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMCondition : NSObject{
    
    id _leftOperand;
    id _rightOperand;
    
    NSString * _leftOperandType;
    NSString * _rightOperandType;
    
    NSString * _operator;
}
@property(nonatomic, retain)id leftOperand;
@property(nonatomic, retain)id rightOperand;
@property(nonatomic, retain)NSString * leftOperandType;
@property(nonatomic, retain)NSString * rightOperandType;
@property(nonatomic, retain)NSString * operator;



@end

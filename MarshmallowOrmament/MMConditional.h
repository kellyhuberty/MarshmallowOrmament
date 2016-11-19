//
//  MMConditional.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/28/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMSet;

@interface MMConditional : NSObject{
    
    MMSet * _conditions;
    MMSet * _operators;
    
}
@property (nonatomic, retain)MMSet * conditions;
@property (nonatomic, retain)MMSet * operators;


-(void)processConditionalFormatString:(NSString *)string withArguements:(NSArray *)args;

+(instancetype)conditionalWithFormat:(NSString *)formatString, ...;
+(NSUInteger) numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack;
+(MMConditional *)processConditionalFormatString:(NSString *)formatString withArguements:(NSArray *)args;

@end

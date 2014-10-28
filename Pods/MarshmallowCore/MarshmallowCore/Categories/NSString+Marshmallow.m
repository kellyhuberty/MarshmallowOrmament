//
//  NSString+Marshmallow.m
//  Marshmallow
//
//  Created by Kelly Huberty on 12/8/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import "NSString+Marshmallow.h"
#import "MMUtility.h"

@implementation NSString (Marshmallow)

+(NSString *)implode:(NSMutableArray *)array glue:(NSString *)glue{
    
    NSMutableString * str = mmRetain([NSMutableString string]);
    
    if (glue == nil) {
        glue = @"";
    }
    
    for (int i = 0; i < ([array count] - 1); ++i) {
        
        [str appendFormat:@"%@%@", array[i], glue];
        
    }
    
    [str appendFormat:@"%@", array[([array count] - 1)]];
    
    NSString * rtnStr = [NSString stringWithString:str];
    
    mmRelease(str);

    return rtnStr;
}

-(NSArray *)explode:(NSString *)str{
    
    return [self componentsSeparatedByString:str];
    
}

@end

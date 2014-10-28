//
//  MMVersionString.m
//  Marshmallow
//
//  Created by Kelly Huberty on 2/1/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMVersionString.h"
#import "NSString+Marshmallow.h"

@implementation MMVersionString



-(id)initWithString:(NSString*)string
{
    if ((self = [self init]))
    {
        _string = [[NSMutableString stringWithString:string] copy];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])){
        
        if (_string == nil) {
            _string = [[NSMutableString alloc]init];
        }
    }
    return self;
}

-(int)length{

    return [_string length];
    
}

-(unichar)characterAtIndex:(NSUInteger)index{
    
    return [_string characterAtIndex:index];
    
}

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString{
    
    [_string replaceCharactersInRange:aRange withString:aString];
    
}

//+(NSString *)implode:(NSMutableArray *)array glue:(NSString *)glue{
//    
//    NSMutableString * str = mmRetain([NSMutableString string]);
//    
//    if (glue == nil) {
//        glue = @"";
//    }
//    
//    for (int i = 0; i < ([array count] - 1); ++i) {
//        
//        [str appendFormat:@"%@%@", array[i], glue];
//        
//    }
//    
//    [str appendFormat:@"%@", array[[array count]]];
//    
//    NSString * rtnStr = [NSString stringWithString:str];
//    
//    mmRelease(str);
//    
//    return rtnStr;
//}
//
//-(NSArray *)explode:(NSString *)str{
//    
//    return [self componentsSeparatedByString:str];
//    
//}

-(int)major{
    
    NSArray * arr = [_string explode:@"."];
    
    if([arr count] > 0){
        
        return [(NSString *)arr[0] intValue];
    }
    
    return nil;
}


-(int)minor{
    
    NSArray * arr = [_string explode:@"."];
    
    if([arr count] > 1){
        
        return [(NSString *)arr[1] intValue];
    }
    
    return nil;

}


-(int)maintenance{
    
    NSArray * arr = [_string explode:@"."];
    
    if([arr count] > 3){
        
        return [(NSString *)arr[2] intValue];
    }
    
    return nil;
    
}


-(NSString *)build{
    
    return nil;
}


@end

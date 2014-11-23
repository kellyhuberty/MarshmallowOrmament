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
    
    return 0;
}


-(int)minor{
    
    NSArray * arr = [_string explode:@"."];
    
    if([arr count] > 1){
        
        return [(NSString *)arr[1] intValue];
    }
    
    return 0;

}


-(int)maintenance{
    
    NSArray * arr = [_string explode:@"."];
    
    if([arr count] > 2){
        
        return [(NSString *)arr[2] intValue];
    }
    
    
    
    return 0;
}

-(NSComparisonResult)compareVersion:(NSString *)string{
    
    if (![string isKindOfClass:[MMVersionString class]]) {
        string = [MMVersionString stringWithString:string];
    }
    
    int me[3];
    int myFriend[3];

    me[0] = self.major;
    me[1] = self.minor;
    me[2] = self.maintenance;

    myFriend[0] = ((MMVersionString *)string).major;
    myFriend[1] = ((MMVersionString *)string).minor;
    myFriend[2] = ((MMVersionString *)string).maintenance;
    
    for(int i = 0; i < 3; ++i){
        if (me[i] > myFriend[i]) {
            return NSOrderedDescending;
        }else if(me[i] < myFriend[i]){
            return NSOrderedAscending;
        }
        
        
    }
    
    return NSOrderedSame;
}


-(NSString *)pathString{
    
    return [NSString stringWithString:[self stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
}


@end

//
//  NSURL+Marshmallow.m
//  MarshmallowCore
//
//  Created by Kelly Huberty on 3/16/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "NSURL+Marshmallow.h"

@implementation NSURL (Marshmallow)

-(NSURL *)URLWithQueryParams:(NSDictionary *)params{

    NSMutableString * queryString;
    
    if ([self query] == nil) {
        queryString = [NSMutableString stringWithString:@"?"];
    }
    
    
    for (NSString * key in [params allKeys]) {
        
        NSString * divi;
        
        if ([queryString isEqualToString:@"?"]) {
            divi = @"";
        }
        else{
            divi = @"&";
        }
        
        
        [queryString appendFormat:@"%@%@=%@", divi, key, [params objectForKey:key]];
        
    }
    
    return [NSURL URLWithString:[[self absoluteString] stringByAppendingString:queryString]];
    
}




@end

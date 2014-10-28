//
//  MMVersionString.h
//  Marshmallow
//
//  Created by Kelly Huberty on 2/1/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMVersionString : NSString{
    
    NSMutableString * _string;
    
}
@property (nonatomic)int major;
@property (nonatomic)int minor;
@property (nonatomic)int maintenance;

-(int)length;
-(unichar)characterAtIndex:(NSUInteger)index;


@end

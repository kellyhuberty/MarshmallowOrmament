//
//  NSString+Marshmallow.h
//  Marshmallow
//
//  Created by Kelly Huberty on 12/8/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Marshmallow)
+(NSString *)implode:(NSMutableArray *)array glue:(NSString *)glue;
-(NSArray *)explode:(NSString *)str;
@end

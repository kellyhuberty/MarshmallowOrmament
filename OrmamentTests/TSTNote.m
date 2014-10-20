//
//  TSTNote.m
//  MarshmallowORM
//
//  Created by Kelly Huberty on 4/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTNote.h"

@implementation TSTNote

@dynamic text;
@dynamic notebook;
@dynamic longitude;
@dynamic latitude;
//- (id)init
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(NSString *)schemaName{
    
    return @"noteit";
    
}

+(NSString *)entityName{
    
    return @"note";
    
}


@end

//
//  MMRecordLoadingPlaceholder.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/15/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMRecordLoadingPlaceholder : NSObject{
    
    
}
@property (atomic, copy) void (^loadCallback)();


@end

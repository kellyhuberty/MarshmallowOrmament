//
//  MMSectionDescriptor.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/13/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSectionDescriptor : NSObject

@property (nonatomic, copy) NSObject * (^sectionIdentifierBlock)(NSObject * model);
@property (nonatomic, copy) NSString * (^sectionTitleBlock)(NSObject * model);

@end

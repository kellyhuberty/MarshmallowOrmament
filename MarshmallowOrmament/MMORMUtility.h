//
//  MMORMUtility.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMORMUtility : NSObject

NSString * MMORMArrayValueHash(NSArray * array);

NSArray * MMORMSortedValueArray(NSDictionary * dict);

NSString * MMORMIdentifierHash(NSDictionary * dict);

NSNumber * MMORMThreadNSNumber();

@end

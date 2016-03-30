//
//  TSTTag.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 3/19/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import "TSTItem.h"

@interface TSTTag : TSTItem
@property(nonatomic)int identifier;
@property(nonatomic, retain)NSString * title;
@property(nonatomic, retain)NSString * description;

@end

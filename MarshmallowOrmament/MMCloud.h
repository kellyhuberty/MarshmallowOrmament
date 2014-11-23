//
//  MMCloud.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/15/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMService.h"

@interface MMCloud : MMService

+(MMService *)cloudWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver;

@end

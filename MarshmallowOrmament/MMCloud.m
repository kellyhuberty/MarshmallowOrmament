//
//  MMCloud.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/15/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMCloud.h"
#import "MMOrmManager.h"
@implementation MMCloud


+(MMService *)cloudWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver{
    
    return [[MMOrmManager manager] serviceWithType:@"cloud" schemaName:schemaName];
    
}



+(MMService *)newCloudWithSchemaName:(NSString *)schemaName version:ver{
    
    MMSchema * schema = [MMSchema schemaFromName:schemaName version:ver];
    
        //+(MMSchema *)schemaFromName:(NSString *)name version:(NSString *)ver{
    
    
    return [[NSClassFromString(schema.cloudClassName) alloc]initWithSchema:schema];
    
}


@end

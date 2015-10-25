//
//  MMSQLiteMutation.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/26/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMSchemaObject.h"

@interface MMSQLiteMutation : MMSchemaObject{
    
    
    
}

@end


typedef enum : NSInteger {
    MMSQLiteMutationAdd,
    MMSQLiteMutationSet,
    MMSQLiteMutationRemove
} MMSQLiteMutationType;
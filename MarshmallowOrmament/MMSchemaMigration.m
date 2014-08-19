//
//  MMSchemaMigration.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/4/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSchemaMigration.h"

@implementation MMSchemaMigration

-(instancetype)initWithOldSchema:(MMSchema *)oldSchema newSchema:(MMSchema *)newSchema options:(NSDictionary *)options{
    
    self = [super init];
    if(self){
        _olderSchema = MMRetain(oldSchema);
        _newerSchema = MMRetain(newSchema);
        [self setOptions:options];
        
    }
    return self;
    
}


+(instancetype)migrationForOldSchema:(MMSchema *)oldSchema newSchema:(MMSchema *)newSchema{
    
   return MMAutorelease([[[self class]alloc] initWithOldSchema:(MMSchema *)oldSchema newSchema:(MMSchema *)newSchema]);
    
}




-(BOOL)upgrade:(NSError **)error{
    
    
    
    
    
    
    
    
    return NO;
}


-(BOOL)downgrade:(NSError **)error{
    
    
    
    
    
    
    return NO;
}

-(void)setOptions:(NSDictionary *)options{
    
    
    for (NSString * key in [options allKeys]) {
        [self setValue:options[key] forKey:key];
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"undefinedkey");
    
}

@end

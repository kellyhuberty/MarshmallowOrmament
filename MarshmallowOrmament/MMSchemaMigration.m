//
//  MMSchemaMigration.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/4/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSchemaMigration.h"

@implementation MMSchemaMigration


+(instancetype)migrationWithDictionary:(NSDictionary *)dictionary{
    
    MMSchemaMigration * migration = nil;
    
    if(dictionary[@"className"]){
        migration = [[NSClassFromString(dictionary[@"className"]) alloc]initWithDictionary:dictionary entityDictionary:nil];
    }
    else{
        migration = [[MMSchemaMigration alloc]initWithDictionary:dictionary entityDictionary:nil];
    }
    
    MMAutorelease(migration);
    
    return migration;
    
}


+(instancetype)migrationWithDictionary:(NSDictionary *)dictionary entityDictionary:(NSDictionary *)entityDictionarys{
    
    MMSchemaMigration * migration = nil;
    
    if(dictionary[@"className"]){
        migration = [[NSClassFromString(dictionary[@"className"]) alloc]initWithDictionary:dictionary entityDictionary:entityDictionarys];
    }
    else{
        migration = [[MMSchemaMigration alloc]initWithDictionary:dictionary entityDictionary:entityDictionarys];
    }
    
    return migration;
    
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary entityDictionary:(NSDictionary *)entityDictionarys{
    
    if (self = [self init]) {
        
        if (dictionary[@"fromVersion"]) {
            _fromVersion = [MMVersionString stringWithString:dictionary[@"fromVersion"]];
        }
        
        if (!_fromVersion) {
            [NSException raise:@"MMInvaildInitailizerDictionary" format:@"the init dict does not contain a fromVersion string."];
        }

        if (dictionary[@"toVersion"]) {
            _fromVersion = [MMVersionString stringWithString:dictionary[@"fromVersion"]];
        }
        
        if (!_fromVersion) {
            [NSException raise:@"MMInvaildInitailizerDictionary" format:@"the init dict does not contain a toVersion string."];
        }
        
        
        //_className = [MMVersionString stringWithString:dictionary[@"className"]];
        //selfentityDictionarys;
        
    }
    
    return self;
}

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




-(BOOL)upgradeStore:(MMService *)oldStore toStore:(MMService *)newStore error:(NSError **)error{
    
    
    
    
    
    
    
    
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

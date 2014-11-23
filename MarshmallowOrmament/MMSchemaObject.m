//
//  MMSchemaObject.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSchemaObject.h"
#import "MMOrmMeta.h"


@implementation MMSchemaObject

-(id)initWithDictionary:(NSDictionary *)dict{
    
//    NSArray * arr = [dict allKeys];
//    
//    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];
//    
//    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
//    

    if(self = [self init]){
        
        NSError * error;
        
        [self loadFromDictionary:dict error:&error];
    
        [self loadMetaFromDictionary:dict error:&error];

        
    }
    
    return self;
    
}

-(id)init{
    
        //    NSArray * arr = [dict allKeys];
        //
        //    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];
        //
        //    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
        //
    
    if(self = [super init]){
        
        _meta = [[NSMutableDictionary alloc]init];
        
    }
    
    return self;
    
}


-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
    [NSException raise:@"MMInvalidDictionaryLoaderException"
                format:@"the method loadFromDictionary:error: in class %@ must be overridden.", NSStringFromClass([self class])];
    
    return NO;
}

-(BOOL)loadMetaFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
    NSArray * arr = [dict allKeys];

    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", @"."];

    NSArray * attrKeys = [arr filteredArrayUsingPredicate:pred];
    
    for (NSString * keyPath in attrKeys) {
        
        NSArray * components = [keyPath componentsSeparatedByString:@"."];
        
        [self setMeta:dict[keyPath] forKey:components[1] serviceType:components[0]];
        
    }
    
    return YES;
}

-(void)setMeta:(NSObject *)obj forKeyPath:(NSString *)keyPath{
    
    NSArray * components = [keyPath componentsSeparatedByString:@"."];
    
    [self setMeta:obj forKey:components[1] serviceType:components[0]];
    
}

-(void)metaForKeyPath:(NSString *)keyPath{
    
    NSArray * components = [keyPath componentsSeparatedByString:@"."];
    
    [self metaForKey:components[1] serviceType:components[0]];
    
}


-(void)setMeta:(NSObject *)obj forKey:(NSString *)key serviceType:(NSString *)serviceType{
    
    [(NSMutableDictionary *)[self metaForServiceType:serviceType] setValue:obj forKey:key];

    
}

-(NSObject *)metaForKey:(NSString *)key serviceType:(NSString *)serviceType{
    
    return [(NSMutableDictionary *)[self metaForServiceType:serviceType] valueForKey:key];
    
}

-(NSObject *)metaForServiceType:(NSString * )serviceType{
    
    NSMutableDictionary * metaObj = nil;
    
    if (!(metaObj = [_meta valueForKey:serviceType])) {
        metaObj = [[NSMutableDictionary alloc]init];
    
        [_meta setValue:metaObj forKey:serviceType];
    }
    
    return metaObj;
    
}


@end

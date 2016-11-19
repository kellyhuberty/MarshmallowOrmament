//
//  MMRelationLink.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/24/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRelation.h"

#import "MMUtility.h"

@implementation MMRelation


+(MMRelation *)relationWithDictionary:(NSDictionary *)dict{
    
    MMRelation* rel =  [[[self class] alloc] initWithDictionary:dict];
    
    return rel;
}


-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        if (dict[@"entityName"]) {
            self.entityName = dict[@"entityName"];
        }
        if (dict[@"referencingEntityName"]) {
            self.referencingEntityName = dict[@"referencingEntityName"];
        }
        if (dict[@"key"]) {
            self.key = dict[@"key"];
        }
        if (dict[@"referencingKey"]) {
            self.referencingKey = dict[@"referencingKey"];
        }
        if (dict[@"foreignKeyType"]) {
            if([dict[@"foreignKeyType"]isEqualToString:@"ref"] || [dict[@"foreignKeyType"]isEqualToString:@"referencing"]){
                self.foreignKeyType = MMRelationForeignKeyOnRef;
            }else{
                self.foreignKeyType = MMRelationForeignKeyOnSelf;
            }
        }
    }
    
    return self;
}


-(instancetype)initWithRelationFormat:(NSString *)format{
    
    if(self = [super init]){
//        if (dict[@"entityName"]) {
//            self.entityName = dict[@"entityName"];
//        }
//        if (dict[@"referencingEntityName"]) {
//            self.referencingEntityName = dict[@"referencingEntityName"];
//        }
//        if (dict[@"key"]) {
//            self.key = dict[@"key"];
//        }
//        if (dict[@"referencingKey"]) {
//            self.referencingKey = dict[@"referencingKey"];
//        }
//        if (dict[@"foreignKeyType"]) {
//            if([dict[@"foreignKeyType"]isEqualToString:@"ref"] || [dict[@"foreignKeyType"]isEqualToString:@"referencing"]){
//                self.foreignKeyType = MMRelationForeignKeyOnRef;
//            }else{
//                self.foreignKeyType = MMRelationForeignKeyOnSelf;
//            }
//        }

        
    
    }
    
    return self;
    
}


+(instancetype)relationWithRelationFormat:(NSString *)format{
    MMRelation * rel= [[MMRelation alloc]initWithRelationFormat:format];
    rel;
    return rel;
}




-(void)parseRelationFormat:(NSString *)format{


    format = [format stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray * specifiers = [format componentsSeparatedByString:@"="];

    if ([specifiers count] != 2) {
        
        //throw an exception!
    }

    if (specifiers[0]) {

        NSString * speci0 = specifiers[0];

        if ( ([speci0 rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]]).location == NSNotFound )
        {
        
            
            
        }
        else{
            
            speci0 = [speci0 stringByReplacingOccurrencesOfString:@"<" withString:@""];

            _foreignKeyType = MMRelationForeignKeyOnSelf;
 
        }
        
        [self parseEntityAndKey:speci0 forIndex:0];

        
    }
    if (specifiers[1]) {
        NSString * speci1 = specifiers[1];
        
        if ( ([speci1 rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]]).location == NSNotFound )
        {
            
            
            
        }
        else{
            
            speci1 = [speci1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
            
            _foreignKeyType = MMRelationForeignKeyOnRef;
            
        }
        
        [self parseEntityAndKey:speci1 forIndex:1];
        
    }
    
}

-(void)parseEntityAndKey:(NSString *)format forIndex:(int)index{
    
    NSArray * items = [format componentsSeparatedByString:@"."];

    NSString * entity = nil;
    NSString * key = nil;

    if ([items count] == 2) {
        entity = items[0];
        key = items[1];
    }else{
        
        //throw exception
    }
    
    if (index == 0) {
        _entityName = entity;
        _key = key;
    }
    else{
        _referencingEntityName = entity;
        _referencingKey = key;
    }
    
}

@end

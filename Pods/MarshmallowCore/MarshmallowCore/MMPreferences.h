//
//  MMPreferences.h
//  MyLolla
//
//  Created by Kelly Huberty on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MMPreferences : NSObject{
    
    NSMutableDictionary * _plistDictionary;
    
}
@property (nonatomic, retain) NSMutableDictionary * plistDictionary;


-(id)initWithName:(NSString *)filename;
+(MMPreferences *)preferencesWithName:(NSString *)filename;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
+(void)setValue:(id)value forKey:(NSString *)key;
+(id)valueForKey:(NSString *)key;
+(void)setValue:(id)value forKey:(NSString *)key forList:(NSString *)list;
+(id)valueForKey:(NSString *)key forList:(NSString *)list;
+(id)appInfoForKey:(NSString *)key;
+(NSDictionary *)grabPreferenceList:(NSString *)list;
+(void)setMainFileName:(NSString *)name;
+(void)setRecordFileName:(NSString *)name;
+(NSDictionary *)entityDescriptors;
+(NSDictionary*)controlPropertyMap;




@end

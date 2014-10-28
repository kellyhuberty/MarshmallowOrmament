//
//  MMPreferences.m
//  MyLolla
//
//  Created by Kelly Huberty on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MMUtility.h"
#import "MMPreferences.h"

@implementation MMPreferences


static NSMutableDictionary * marshmallowPrefs;
static NSMutableDictionary * recordPrefs;

-(id)initWithName:(NSString *)filename{
    self = [super init];
    if (self) {
        [self setup];
        _plistDictionary = mmRetain([NSMutableDictionary dictionaryWithDictionary:[[self class] grabPreferenceList:filename]]);
    }
    return self;
}

+(MMPreferences *)preferencesWithName:(NSString *)filename{

    return mmAutorelease([[MMPreferences alloc] initWithName:filename]);
}

-(void)setup{
    
    
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    [_plistDictionary setValue:value forKey:key];
    
}

-(id)valueForKey:(NSString *)key{
    
    return [_plistDictionary valueForKey:key];
    
}

-(void)save{
    
    
    
    
}

+(void)setValue:(id)value forKey:(NSString *)key{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    
        //[defaults release];
    
}

+(id)valueForKey:(NSString *)key{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id ret = [defaults valueForKey:key];
        //[defaults release];
    return ret;
}

+(void)setValue:(id)value forKey:(NSString *)key forList:(NSString *)list{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    
        //[defaults release];
    
}

+(id)valueForKey:(NSString *)key forList:(NSString *)list{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    id ret = [defaults valueForKey:key];
        //[defaults release];
    return ret;
}

+(id)appInfoForKey:(NSString *)key{
    id ret = [[[NSBundle mainBundle] infoDictionary] valueForKey:key];
        //[defaults release];
    return ret;
}


+(NSDictionary *)grabPreferenceList:(NSString *)list{
   return [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:list ofType:@"plist"] ] ;
}


+(void)setMainFileName:(NSString *)name{
    marshmallowPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"] ] ;
}

+(void)setRecordFileName:(NSString *)name{
    recordPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"] ];
}

+(NSDictionary *)entityDescriptors{
    return [recordPrefs objectForKey:@"entities"];
}


+(NSDictionary*)controlPropertyMap{
    NSString * mapName = @"MMDefaultValueControlPropertyMap";
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:mapName ofType:@"plist"]];
    return dictionary;
}

- (void)dealloc
{
    mmRelease(_plistDictionary);
    
    #if __has_feature(objc_arc)
    #else
    [super dealloc];
    #endif
}



@end

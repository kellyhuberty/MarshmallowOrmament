//
//  MMSchemaMigration.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/4/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSchema.h"
#import "MMStore.h"

@protocol MMSchemaMigration <NSObject>

+(instancetype)migrationForOldSchema:(MMSchema *)oldStr newSchema:(MMSchema *)newStr;

@end


@interface MMSchemaMigration : NSObject<MMSchemaMigration>{
    
    MMVersionString * _fromVersion;
    MMVersionString * _toVersion;

    
    NSString * _className;
    
    
    MMStore * _olderStore;
    MMStore * _newerStore;
    
    MMSchema * _olderSchema;
    MMSchema * _newerSchema;
    
}
+(instancetype)migrationWithDictionary:(NSDictionary *)dictionary;
+(instancetype)migrationWithDictionary:(NSDictionary *)dictionary entityDictionary:(NSDictionary *)entityDictionarys;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(instancetype)initWithOldSchema:(MMSchema *)oldSchema newSchema:(MMSchema *)newSchema;
-(instancetype)migrationForOldVersion:(MMVersionString *)oldStr newVersion:(MMVersionString *)newStr;

@property(nonatomic, retain)MMVersionString * fromVersion;
@property(nonatomic, retain)MMVersionString * toVersion;


@property(nonatomic, retain)MMStore * olderStore;
@property(nonatomic, retain)MMStore * newerStore;

@property(nonatomic, retain)MMSchema * olderSchema;
@property(nonatomic, retain)MMSchema * newerSchema;




-(BOOL)upgradeStore:(MMStore *)oldStore toStore:(MMStore *)newStore error:(NSError **)error;
-(BOOL)downgradeStore:(MMStore *)oldStore toStore:(MMStore *)newStore error:(NSError **)error;



@end

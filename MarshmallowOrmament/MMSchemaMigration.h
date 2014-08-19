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
    
    MMStore * _olderStore;
    MMStore * _newerStore;
    
    MMSchema * _olderSchema;
    MMSchema * _newerSchema;
    
}

-(instancetype)initWithOldSchema:(MMSchema *)oldSchema newSchema:(MMSchema *)newSchema;
-(instancetype)migrationForOldVersion:(MMVersionString *)oldStr newVersion:(MMVersionString *)newStr;


@property(nonatomic, retain)MMStore * olderStore;
@property(nonatomic, retain)MMStore * newerStore;

@property(nonatomic, retain)MMSchema * olderSchema;
@property(nonatomic, retain)MMSchema * newerSchema;

//@property(nonatomic)MMVersionString * oldVersion;
//@property(nonatomic)MMVersionString * newVersion;



-(BOOL)upgrade:(NSError **)error;
-(BOOL)downgrade:(NSError **)error;



@end

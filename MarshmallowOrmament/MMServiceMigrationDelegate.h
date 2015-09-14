//
//  MMServiceMigrationDelegate.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/20/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMVersionString.h"
#import "MMService.h"


@protocol MMServiceMigrationDelegate <NSObject>

-(void)buildService:(MMService *)service schema:(MMSchema *)schema error:(NSError **)error;

-(void)upgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;

-(void)downgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;

@end


@interface MMServiceMigrationDelegate : NSObject{
    
    
    
}

-(void)buildService:(MMService *)service schema:(MMSchema *)schema error:(NSError **)error;

-(void)upgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;

-(void)downgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;


@end

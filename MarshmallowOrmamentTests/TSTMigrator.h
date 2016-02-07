//
//  TSTMigrator.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/18/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MMServiceMigrationDelegate.h"

@interface TSTMigrator : NSObject<MMServiceMigrationDelegate>{
    
    
    
    
}
-(void)buildService:(MMService *)service schema:(MMSchema *)schema error:(NSError **)error;

-(void)upgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;

-(void)downgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error;
@end
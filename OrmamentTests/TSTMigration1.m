//
//  TSTMigration1.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/8/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "TSTMigration1.h"

@implementation TSTMigration1
-(BOOL)upgrade:(NSError **)error{

    NSError * error1;
    [self.newerStore copyFromVersion:self.olderSchema.version error:&error1];
    
    //self.newerStore
    
    
    
    
    
  
    return true;
    
}

-(BOOL)downgrade:(NSError **)error{
    
    
    return true;

}
@end

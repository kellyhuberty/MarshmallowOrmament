//
//  MMResultsSet.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMResultsSet.h"

@implementation MMResultsSet


-(id)init{
    
    if (self = [super init]) {
        //_sqlBindValues = [[NSMutableDictionary alloc]init];
    
        _offset = MMResultsSetNoTotal;
        _total = MMResultsSetNoOffset;
    
    }
    
    return self;
}


//-(void)_groupAlphaNumeric{
//    
//    
//    
//    
//}








-(int)total{
    
    @synchronized(self){
        if(MMResultsSetNoTotal){
            
            return [super count];
            
        }
        
        return _total;
        
    }

}




@end

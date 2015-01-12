//
//  MMResultsSet.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMResultsSet.h"
#import "MMUtility.h"

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


+(MMResultsSet *)mergeResultsSet:(MMResultsSet *)aSet withSet:(MMResultsSet *)bSet{
    
    if (aSet == nil) {
        return bSet;
    }
    if (bSet == nil) {
        return aSet;
    }
    
    MMResultsSet * a = [aSet copy];
    MMResultsSet * b = [bSet copy];
    
    MMAutorelease(a);
    MMAutorelease(b);
    
    if (a.count + a.offset == b.offset){
        
        [a addObjectsFromArray:b];
        
        return a;
        
    }
    else if (b.count + b.offset == a.offset){
    
        [b addObjectsFromArray:a];
        return b;
        
    }
    
    return nil;
    
}




-(void)setTotal:(int)total{
    
    @synchronized(self){
        
        _total = total;
        
    }
    
}



-(int)total{
    
    @synchronized(self){
        
        if(MMResultsSetNoTotal){
            
            return [super count];
            
        }
        
        return _total;
        
    }

}




@end

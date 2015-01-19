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
    
    if (aSet == nil || [aSet count] == 0) {
        return bSet;
    }
    if (bSet == nil || [bSet count] == 0) {
        return aSet;
    }
    
    MMResultsSet * a = aSet;
    MMResultsSet * b = bSet;
    
    MMResultsSet * retSet = [[MMResultsSet alloc]init];
    
    if (a.count + a.offset == b.offset){
        
        [retSet addObjectsFromArray:a];
        [retSet addObjectsFromArray:b];
        
        retSet.total = a.total;
        retSet.offset = a.offset;

        return retSet;
        
    }
    else if (b.count + b.offset == a.offset){
    
        [retSet addObjectsFromArray:b];
        [retSet addObjectsFromArray:a];
        
        retSet.total = b.total;
        retSet.offset = b.offset;
        
        return retSet;
        
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
        
        if(_total == MMResultsSetNoTotal){
            
            return [super count];
            
        }
        
        return _total;
        
    }

}




@end

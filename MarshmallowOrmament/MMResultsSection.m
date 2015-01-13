//
//  MMResultsSection.m
//  Pods
//
//  Created by Kelly Huberty on 1/10/15.
//
//

#import "MMResultsSection.h"

@implementation MMResultsSection

-(instancetype)init{
    
    if(self = [super init]){
        
        
        _objects = [[MMSet alloc]init];
        
        
    }
    return self;
    
}


-(NSUInteger)numberOfObjects{
    
    return [_objects count];
    
}

@end

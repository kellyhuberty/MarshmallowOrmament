//
//  MMRequest.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRequest.h"

@implementation MMRequest


-(id)init{
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(id)initWithStore:(MMStore *)store classname:(NSString *)className{
    
    if (self = [self init]) {
        //_className = MMRetain(className);
        //_store
        
        self.className = className;
        self.store = store;
        
    }
 
    return self;
}


-(void)setClassName:(NSString *)className{
    
    _className = [className copy];
    _entityName = [[NSClassFromString(_className) entityName] copy];
    
}


-(BOOL)executeOnStore:(MMStore *)store returnToTarget:(id)target selector:(SEL)selector{
    
    NSInvocationOperation * a = [[NSInvocationOperation alloc]initWithTarget:[self class] selector:@selector(executeReadWithRequest:) object:self];
    
    [a start];
    
    return YES;
}

-(void)executeWithError:(NSError **)error completionBlock:(completionBlock) block{
    
    if(!_completionBlock){
        self.completionBlock = block;
    }
    [self executeOnStore:_store error:error completionBlock:_completionBlock];
    
}

-(void)executeOnStore:(MMStore *)store error:(NSError**)error completionBlock:(void (^)(MMSet *, NSError *__autoreleasing *))block{
    
    if(!_completionBlock){
        self.completionBlock = block;
    }
    //NSInvocationOperation * a = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(executeReadWithRequest:error:) object:self];
    
    
    
    NSBlockOperation * a = [NSBlockOperation blockOperationWithBlock:^(){
       
        [self loadRequest:error];
        
    }];
    
    NSOperationQueue * queue = [store operationQueue] ;
    
    [queue addOperations:a waitUntilFinished:_synchronous];

    
    //[a start];
    
}

-(MMSet *)executeOnStore:(MMStore *)store error:(NSError**)error{
    
    if (_store == nil) {
        _store = MMRetain(store);
    }
    
    return [self loadRequest:error];
    
}

-(MMSet *)loadRequest:(NSError**) error{
    
    MMSet * set = [_store executeReadWithRequest:self error:error];
    
    MMLog(@"RSULT SET %@", set);
    
    [self completedWithResults:set error:error];
    
    return set;
    
}


-(void)completedWithResults:(MMSet *)set error:(NSError**)error {
    
    if (_invocation) {
        [_invocation invoke];
    }
    if(_completionBlock){
        _completionBlock(set, error);
    }
    
}



@end

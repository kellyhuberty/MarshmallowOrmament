//
//  MMRequest.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRequest.h"
#import "MMUtility.h"
#import "MMResultsSet.h"
#import "MMService.h"
#import "MMOrmMeta.h"

@implementation MMRequest


-(id)init{
    
    if (self = [super init]) {
            //_sqlBindValues = [[NSMutableDictionary alloc]init];
            //_meta = [[MMOrmMeta alloc]init];
        
        _order = NSOrderedAscending;
    }
    
    return self;
}

-(id)initWithService:(MMService *)store classname:(NSString *)className{
    
    if (self = [self init]) {
        //_className = MMRetain(className);
        //_store
        
        self.className = className;
        self.service = store;
        
    }
 
    return self;
}


-(void)setClassName:(NSString *)className{
    
    _className = [className copy];
    _entityName = [[NSClassFromString(_className) entityName] copy];
    
}


-(BOOL)executeOnStore:(MMService *)store returnToTarget:(id)target selector:(SEL)selector{
    
    NSInvocationOperation * a = [[NSInvocationOperation alloc]initWithTarget:[self class] selector:@selector(executeReadWithRequest:) object:self];
    
    [a start];
    
    return YES;
}

-(void)executeWithCompletionBlock:(completionBlock) block{
    
    if(!_completionBlock){
        self.completionBlock = block;
    }
    [self executeOnStore:_service error:nil completionBlock:_completionBlock];
    
}

-(void)executeWithError:(NSError **)error completionBlock:(completionBlock) block{
    
    if(!_completionBlock){
        self.completionBlock = block;
    }
    [self executeOnStore:_service error:error completionBlock:_completionBlock];
    
}

-(void)executeOnStore:(MMService *)store error:(NSError**)error completionBlock:(void (^)(MMSet *, NSError *__autoreleasing *))block{
    
    if(!_completionBlock){
        self.completionBlock = block;
    }
    //NSInvocationOperation * a = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(executeReadWithRequest:error:) object:self];
    
    
    
    NSBlockOperation * a = [NSBlockOperation blockOperationWithBlock:^(){
       
        [self loadRequest:error];
        
    }];
    
    NSOperationQueue * queue = [store operationQueue] ;
    
    [queue addOperations:@[a] waitUntilFinished:_synchronous];
    
    //[a start];
    
}

-(MMSet *)executeOnStore:(MMService *)store error:(NSError**)error{
    
    if (_service == nil) {
        _service = store;
    }
    
    return [self loadRequest:error];
    
}

-(MMResultsSet *)loadRequest:(NSError**) error{
    
    MMResultsSet * set = [_service executeReadWithRequest:self error:error];
    
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

//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//    
//    
//    
//}





@end

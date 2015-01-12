//
//  MMResultsController.m
//  Pods
//
//  Created by Kelly Huberty on 1/6/15.
//
//

#import "MMResultsController.h"
#import "MMRequestable.h"
#import "MMUtility.h"
@implementation MMResultsController

-(instancetype)initWithRequest:(id<MMRequestable>)request{
    
    if(self = [self init]){
        
        _request = request;
        MMRetain(_request);
        
    }
    
    return self;
}
#pragma mark load result set.
-(BOOL)performFetch:(NSError **)error{
    
    return [self load:error];

}

-(BOOL)load:(NSError **)error{
    
    
    _request
    
    
}

-(BOOL)load:(NSError **)error completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    [_request executeWithCompletionBlock:^void (MMSet *set, NSError *__autoreleasing *error) {
        
        BOOL suc = (set == nil?false:true);
        
        _results = 
        
        compBlock(suc, error);
    
    }];
    
    
    
    
}

#pragma quering results
-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath faultBlock:(void (^)(NSIndexPath * path))faultBlock completionBlock:(void (^)(NSIndexPath * path, id object))completionBlock{
    
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object{
    
    return nil;
    
}

#pragma quering sections

-(id)sectionAtIndex:(NSInteger)index{
    
    return nil;
}
    
- (id)sectionAtIndex:(NSInteger)index faultBlock:(void (^)(NSInteger index))faultBlock completionBlock:(void (^)(NSInteger index, id object))completionBlock{
    
    return nil;
}


- (NSInteger)sectionForSectionIndexTitle:(NSString *)title
                                 atIndex:(NSInteger)sectionIndex{
    
    return 0;
}
- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName{
    
    
    return nil;
}




@end

//
//  MMResultsController.m
//  Pods
//
//  Created by Kelly Huberty on 1/6/15.
//
//

#import "MMResultsController.h"
#import "MMResultsSection.h"
#import "MMUtility.h"
#import <UIKit/UIKit.h>
@implementation MMResultsController

-(instancetype)initWithRequest:(MMRequest *)request{
    
    if(self = [self init]){
        
        _request = request;
        MMRetain(_request);
        
    }
    
    return self;
}

-(instancetype)init{
    
    if(self = [super init]){

        _sections = [[MMSet alloc] init];
        [_sections addIndexForKey:@"sectionIdentifer" unique:YES];
        [_sections addIndexForKey:@"name" unique:YES];
        [_sections addIndexForKey:@"indexTitle" unique:YES];
        //[_sections addIndexForKey:@"" unique:YES];
        
        _leader = [[MMRecordLoadingPlaceholder alloc]init];
        _trailer = [[MMRecordLoadingPlaceholder alloc]init];
        _loadThreashhold = 20;
        _pageSize = 20;
        _initalOffset = 0;
    }
    
    return self;
    
}

#pragma mark load result set.
-(BOOL)performFetch:(NSError **)error{
    
    return [self initialLoad:error];

}


-(BOOL)initialLoad:(NSError **)error{
    
    return [self load:error limit:_pageSize offset:_initalOffset];
    
}

-(void)initialLoad:(NSError **)error  completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    [self load:error limit:_pageSize offset:_initalOffset completionBlock:compBlock];
    
}


-(BOOL)load:(NSError **)error{
    
    _results = [_request loadRequest:error];
    
    [self postMergeProcessResults];
    
    return YES;

}

-(void)loadPrevious{
    
    int offset = _results.offset -_pageSize;
    if (offset < 0) {
        offset = 0;
    }
    
    NSUInteger limit = _pageSize;
    
    if (limit + offset > _results.offset) {
        NSUInteger diff = (limit + offset) - _results.offset;
        limit = _pageSize - diff;
    }
    
    [self load:nil limit:limit offset:offset completionBlock:^(BOOL suc, NSError ** error){}];
    
}

-(void)loadNext{
    
    [self load:nil limit:_pageSize offset:(_results.offset + _results.count) completionBlock:^(BOOL suc, NSError ** error){}];
    
}

-(void)load:(NSError **)error limit:(NSUInteger)limit offset:(NSUInteger)offset completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    [_request executeWithCompletionBlock:^void (MMResultsSet *set, NSError *__autoreleasing *error) {
        
        _request.limit = limit;
        _request.offset = offset;
        
        BOOL suc = [self integratePayload:set];

        compBlock(suc, error);
    
    }];
    
}

-(BOOL)load:(NSError **)error limit:(NSUInteger)limit offset:(NSUInteger)offset{
    
    _request.limit = limit;
    _request.offset = offset;
    
    MMResultsSet *set = [_request loadRequest:error];

    BOOL suc = [self integratePayload:set];
    
    return suc;
    
}


-(BOOL)integratePayload:(MMResultsSet *)set{
    
    BOOL suc = (set == nil?false:true);
    
    [self preMergeProcessResults];
    
    BOOL additional = (_results == nil?false:true);
    
    _results = [MMResultsSet mergeResultsSet:_results withSet:set];
    
    [self postMergeProcessResults];
    
    if (additional && _delegate && [(NSObject *)_delegate respondsToSelector:@selector(controller:didLoadAdditionalResults:)]) {
        [_delegate controller:self didLoadAdditionalResults:set];
    }
    
    return suc;
    
}


-(void)preMergeProcessResults{
    
    [_results removeObject:_leader];
    [_results removeObject:_trailer];
    
}


-(void)postMergeProcessResults{
    
    if (_results.total != _results.count) {
        [_results addObject:_trailer];
    }
    if (_results.offset != 0) {
        [_results insertObject:_leader atIndex:0];
    }
    
    for (MMResultsSection * section in _sections) {
        
        [section.objects removeAllObjects];
        
    }
    
    for (NSObject * obj in _results) {
        
        if (_sectionDescriptor) {
            
            NSObject * sectionIdentifier = _sectionDescriptor.sectionIdentifierBlock(obj);
            NSObject * sectionTitle = _sectionDescriptor.sectionTitleBlock(obj);
            [self addObject:obj toSectionWithIdentifer:sectionIdentifier withTitle:sectionTitle];
        
        }
        else{
            
            [self addObjectToDefaultSection:obj];
            
        }
        
    }
    
}





-(void)addObject:(NSObject *)obj toSectionWithIdentifer:(NSObject *)sectionIdentifier withTitle:(NSString *)sectionTitle{
    
    MMResultsSection * section = [_sections objectWithValue:sectionIdentifier forKey:@"sectionIdentifer"];
    
    if (!section) {
        section = [[MMResultsSection alloc]init];
        
        section.name = sectionTitle;
        section.sectionIdentifer = sectionIdentifier;
        
        [_sections addObject:section];
    }
    
    NSLog(@"_sections: %@", _sections);
    
    [section.objects addObject:obj];
    
}


-(void)addObjectToDefaultSection:(NSObject *)obj{
    
    NSLog(@"obj:  %@", obj);
    
    [self addObject:obj toSectionWithIdentifer:@"MMDEFAULTSECTION" withTitle:@"MMDEFAULTSECTION"];
    
}

#pragma quering results
-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    MMResultsSection * section = _sections[indexPath.section];
    
    id rec = section.objects[indexPath.row];
    
    NSUInteger i =[_results indexOfObject:rec];
    
    if ( i < _loadThreashhold && _results.offset != 0 ) {
        [self loadPrevious];
    }
    if ( ((i > _results.count) - _loadThreashhold) && ((_results.offset + _results.count) < _results.total) ) {
        [self loadNext];
    }
    
    return rec;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath faultBlock:(void (^)(NSIndexPath * path))faultBlock completionBlock:(void (^)(NSIndexPath * path, id object))completionBlock{
    
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object{
    
    return nil;
    
}

#pragma quering sections

-(id)sectionAtIndex:(NSInteger)index{
    
    return _sections[index];
}
    
- (id)sectionAtIndex:(NSInteger)index faultBlock:(void (^)(NSInteger index))faultBlock completionBlock:(void (^)(NSInteger index, id object))completionBlock{
    
    return nil;
}


- (NSInteger)sectionForSectionIndexTitle:(NSString *)title
                                 atIndex:(NSInteger)sectionIndex{
    return nil;
    //return _sections objectsWithValue:<#(id<NSCopying>)#> forKey:<#(NSString *)#>;
}
- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName{
    
    
    return nil;
}




@end

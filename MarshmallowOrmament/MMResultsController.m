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
#import "MMRecord.h"
#import <UIKit/UIKit.h>
@implementation MMResultsController

-(instancetype)initWithRequest:(MMRequest *)request{
    
    if(self = [self init]){
        
        
        self.request = request;
    
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
        _results = [[MMResultsSet alloc]init];
    }
    
    return self;
    
}

#pragma mark load result set.
-(BOOL)performFetch:(NSError **)error{
    
    return [self initialLoad:error];

}


-(BOOL)initialLoad:(NSError **)error{
    
     [_results removeAllObjects];
    return [self load:error limit:_pageSize offset:_initalOffset];
    
}

-(void)initialLoad:(NSError **)error  completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    [_results removeAllObjects];
    [self load:error limit:_pageSize offset:_initalOffset completionBlock:compBlock];
    
}


-(BOOL)load:(NSError **)error{
    
    _results = [_request loadRequest:error];
    
    [self postMergeProcessResults];
    
    return YES;

}

-(void)loadPrevious{
    
    int offset = _results.offset -_pageSize;
    
    if ([_results[0] isKindOfClass:[MMRecordLoadingPlaceholder class]]) {
        --offset;
    }
    if ([[_results lastObject] isKindOfClass:[MMRecordLoadingPlaceholder class]]) {
        --offset;
    }
    
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
    
    int offset = (_results.offset + _results.count);
    
    if ([_results[0] isKindOfClass:[MMRecordLoadingPlaceholder class]]) {
        --offset;
    }
    if ([[_results lastObject] isKindOfClass:[MMRecordLoadingPlaceholder class]]) {
        --offset;
    }
    
    [self load:nil limit:_pageSize offset:offset completionBlock:^(BOOL suc, NSError ** error){}];
    
}

-(void)load:(NSError **)error limit:(NSUInteger)limit offset:(NSUInteger)offset completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    _request.limit = limit;
    _request.offset = offset;
    
    [_request executeWithCompletionBlock:^void (MMResultsSet *set, NSError *__autoreleasing *error) {
        
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

-(void)setRequest:(MMRequest *)request{
    @synchronized(self){
        
        _request = request;
        
        [self registerForNotifications];
    
    }
}

-(void)registerForNotifications{
    
    MMDebug(@"req: %@", _request.className);
    
    Class aClass = NSClassFromString( _request.className );
    
    if ([aClass isKindOfClass:[MMRecord class]] ) {
        
        [((MMRecord *)aClass) registerForRecordChangesWithTarget:self selector:@selector(entityDidChangeNotification:)];
        
    }
    
    
}


-(void)entityDidChangeNotification:(NSNotification *)notification{
    
    
    [self initialLoad:nil];
    
    
    if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(controllerDidLoadChanges:)]) {
        [_delegate controllerDidLoadChanges:self];
    }
    
    
}


-(BOOL)integratePayload:(MMResultsSet *)set{
    
    NSLock * lock = [[NSLock alloc]init];
    
    [lock lock];
    
    BOOL suc = (set == nil?false:true);
    
    [self preMergeProcessResults];
    
    BOOL additional = (_results == nil?false:true);
    
    //_results = [MMResultsSet mergeResultsSet:_results withSet:set];
    //Merge logic
    

    
    
    
    //set.offset
    NSUInteger offset = set.offset;
    NSUInteger total = set.total;
    NSUInteger count = set.count;
    _results.total = total;
    NSLog(@"integrating payload offset: %i, total: %i, count: %i", offset, total, count);
    NSLog(@"integrating payload offset: %i, total: %i, count: %i", _results.offset, _results.total, _results.count);

    if ([_results count] == 0) {
        //@synchronized(set){
        [_results addObjectsFromArray:set];
        //}
            _results.offset = set.offset;
        
        
    }
    
            //int i;
    if (offset >= _results.offset + _results.count) {
        while (_results.offset + _results.count < set.offset + set.count ) {
            [_results addObject:[NSNull null]];
        }
    }
    
    if (_results.offset > offset) {
        
        int inFront = _results.offset - offset;
        
        _results.offset = _results.offset - inFront;

        while (inFront > 0){
            [_results insertObject:[NSNull null] atIndex:0];
            --inFront;
        }
        
    }

    
    int i = set.offset - _results.offset;
    
    for (NSObject * obj in set) {
        
        
        
        
        NSObject *old = _results[i];
        
        
        if (![old isKindOfClass:[NSNull class]]) {
            if (old != obj) {
                //Do some magic to verifiy validity.
            }
        }
        
        [_results replaceObjectAtIndex:i withObject:obj];
        
        ++i;
        
    }
    
    
    
    
    
    
    [self postMergeProcessResults];
    
    if (additional && _delegate && [(NSObject *)_delegate respondsToSelector:@selector(controller:didLoadAdditionalResults:)]) {
        [_delegate controller:self didLoadAdditionalResults:set];
    }
    
        
    [lock unlock];
    
    return suc;
    
}


-(void)preMergeProcessResults{
    
        //[_results removeObject:_leader];
        //[_results removeObject:_trailer];
    
}


-(void)postMergeProcessResults{
    
    NSLog(@"total:%i/count:%i",_results.total, _results.count);
    
//    if (_results.total != _results.count) {
//        [_results addObject:_trailer];
//    }
//    if (_results.offset != 0) {
//        [_results insertObject:_leader atIndex:0];
//    }
    
    //@synchronized(section.objects){
    
    for (MMResultsSection * section in _sections) {
         //@synchronized(section.objects){
             [section.objects removeAllObjects];
         //}
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
        
    //}
    
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
    //@synchronized(section.objects){

    [section.objects addObject:obj];
    //}
}


-(void)addObjectToDefaultSection:(NSObject *)obj{
    
    NSLog(@"obj:  %@", obj);
    
    [self addObject:obj toSectionWithIdentifer:@"MMDEFAULTSECTION" withTitle:@"MMDEFAULTSECTION"];
    
}

#pragma quering results
-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    MMResultsSection * section = _sections[indexPath.section];
    
    id rec;
    
    @try {
        rec = section.objects[indexPath.row];

    }
    @catch (NSException *exception) {
        rec = [[MMRecordLoadingPlaceholder alloc]init];
    }
    @finally {
        
    }
    
    
    
    
    NSUInteger i =[_results indexOfObject:rec];
    
    if ( i == 1 && _results.offset != 0 ) {
        [self loadPrevious];
    }
    if ( ((_results.count - i) == _loadThreashhold) && ((_results.offset + _results.count) < _results.total) ) {
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

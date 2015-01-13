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
        [_sections addIndexForKey:@"sectionIdentifier" unique:YES];
        [_sections addIndexForKey:@"name" unique:YES];
        [_sections addIndexForKey:@"indexTitle" unique:YES];
        //[_sections addIndexForKey:@"" unique:YES];
    }
    
    return self;
    
}

#pragma mark load result set.
-(BOOL)performFetch:(NSError **)error{
    
    return [self load:error];

}


-(BOOL)load:(NSError **)error{
    
    _results = [_request loadRequest:error];
    
    [self processResults];
    
    return YES;

}


-(void)load:(NSError **)error completionBlock:(void (^)(BOOL success, NSError ** error))compBlock{
    
    [_request executeWithCompletionBlock:^void (MMResultsSet *set, NSError *__autoreleasing *error) {
        
        BOOL suc = (set == nil?false:true);
        
        _results = [MMResultsSet mergeResultsSet:_results withSet:set];
        
        [self processResults];
        
        compBlock(suc, error);
    
    }];
    
}


-(void)processResults{
    
    for (NSObject * obj in _results) {
        
        if (_sectionDescriptor) {
            
            NSObject * sectionIdentifier = _sectionDescriptor.sectionIdentifierBlock(obj);
            NSObject * sectionTitle = _sectionDescriptor.sectionTitleBlock(obj);
            [self addObject:obj toSectionWithIdentifer:sectionIdentifier withTitle:sectionTitle];
        }
        else{
            
            [self addObjectToDefaultSection:obj];
            
        }
        
        //[self addObject:obj toSectionWithIdentifer:sectionIdentifier withTitle:sectionTitle];
        
    }
    
}

-(void)addObject:(NSObject *)obj toSectionWithIdentifer:(NSObject *)sectionIdentifier withTitle:(NSString *)sectionTitle{
    
    MMResultsSection * section = [_sections objectWithValue:sectionIdentifier forKey:@"sectionIdentifier"];
    
    if (!section) {
        section = [[MMResultsSection alloc]init];
        
        section.name = sectionTitle;
        section.sectionIdentifer = sectionIdentifier;
        
    }
    
    [section.objects addObject:obj];
    
}


-(void)addObjectToDefaultSection:(NSObject *)obj{
    
    
//    MMResultsSection * section = [_sections objectWithValue:@"MMSECTIONDEFAULT" forKey:@"sectionIdentifier"];
//    
//    if (!section) {
//        section = [[MMResultsSection alloc]init];
//        
//        section.name = @"MMSECTIONDEFAULT";
//        section.sectionIdentifer = @"MMSECTIONDEFAULT";
//        
//    }
    
    [self addObject:obj toSectionWithIdentifer:@"MMDEFAULTSECTION" withTitle:@"MMDEFAULTSECTION"];
    
    
}

#pragma quering results
-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    MMResultsSection * section = _sections[indexPath.section];
    return section.objects[indexPath.row];
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

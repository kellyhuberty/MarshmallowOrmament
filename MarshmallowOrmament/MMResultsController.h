//
//  MMResultsController.h
//  Pods
//
//  Created by Kelly Huberty on 1/6/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MMRequest.h"
#import "MMSet.h"
#import "MMSectionDescriptor.h"
@interface MMResultsController : NSObject{
    
    MMRequest * _request;
    MMResultsSet * _results;
    MMSet * _sections;
    
    MMSectionDescriptor * _sectionDescriptor;
    
}

@property(nonatomic, retain)MMSectionDescriptor * sectionDescriptor;

@property(nonatomic, retain)NSSortDescriptor * resultsSort;

@property(nonatomic, retain)NSSortDescriptor * sectionSort;

@property(nonatomic, readonly) NSArray *sectionIndexTitles;
@property(nonatomic, readonly) NSArray *fetchedObjects;
@property(nonatomic, readonly) NSArray *sections;



-(instancetype)initWithRequest:(MMRequest *)request;





-(BOOL)performFetch:(NSError **)error;
-(BOOL)load:(NSError **)error;
-(void)load:(NSError **)error completionBlock:(void (^)(BOOL success, NSError ** error))compBlock;



- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
             faultBlock:(void (^)(NSIndexPath * path))faultBlock
        completionBlock:(void (^)(NSIndexPath * path, id object))completionBlock;



- (id)sectionAtIndex:(NSInteger)index;
- (id)sectionAtIndex:(NSInteger)index
          faultBlock:(void (^)(NSInteger * index))faultBlock
     completionBlock:(void (^)(NSInteger * index, id object))completionBlock;



- (NSIndexPath *)indexPathForObject:(id)object;
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title
                                 atIndex:(NSInteger)sectionIndex;
- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName;



@end

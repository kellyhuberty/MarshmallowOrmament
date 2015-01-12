//
//  MMResultsSection.h
//  Pods
//
//  Created by Kelly Huberty on 1/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface MMResultsSection : NSObject<NSFetchedResultsSectionInfo>

/* Name of the section
 */
@property (nonatomic, readonly) NSString *name;

/* Title of the section (used when displaying the index)
 */
@property (nonatomic, readonly) NSString *indexTitle;

/* Number of objects in section
 */
@property (nonatomic, readonly) NSUInteger numberOfObjects;

/* Returns the array of objects in the section.
 */
@property (nonatomic, readonly) NSArray *objects;

@end

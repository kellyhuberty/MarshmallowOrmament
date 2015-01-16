//
//  MMResultsSection.h
//  Pods
//
//  Created by Kelly Huberty on 1/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MMSet.h"
#import "MMResultsControllerAbstract.h"
@interface MMResultsSection : NSObject<MMResultsSectionInfo>

/* Section Identifier
 */
@property (nonatomic, retain) NSObject * sectionIdentifer;
/* Name of the section
 */
@property (nonatomic, retain) NSString *name;

/* Title of the section (used when displaying the index)
 */
@property (nonatomic, readonly) NSString *indexTitle;

/* Number of objects in section
 */
@property (nonatomic, readonly) NSUInteger numberOfObjects;

/* Returns the array of objects in the section.
 */
@property (nonatomic, readonly) MMSet *objects;

@end

//
//  MMUtility.h
//  BandIt
//
//  Created by Kelly Huberty on 10/27/12.
//
//
#import "MMDebug.h"
#import <Foundation/Foundation.h>




@interface MMUtility : NSObject

@end

/**
 */
void MMSetArcEnabled();
/**
 */
void MMSetArcDisabled();

/**
 Sends a ARC safe release message to the object reference passed, and sets the referencing pointer to `nil`
 @param ref A double reference to the The object being released
 @return A BOOL value indicating if the object was null or not upon release.
 */
BOOL MMReleaseRef(NSObject ** ref);

/**
 Sends a ARC safe release message to the object passed.
 @param obj The object being released.
 @return A BOOL value indicating if the object was null or not upon release.
 */
BOOL MMRelease(NSObject * obj);
BOOL mmRelease(NSObject * obj);

/**
 Sends a ARC safe autorelease message to the object passed.
 @param obj The object being autoreleased.
 @returns The object now with an autorelease pool.
 */
id MMAutorelease(NSObject * obj);
id mmAutorelease(NSObject * obj);

/**
 Sends a ARC safe retain message to the object passed.
 @param obj The object being retained.
 @returns the object passed in, after the calling `-retain` in an ARC safe mannor.
 */

id MMRetain(NSObject * obj);
id mmRetain(NSObject * obj);

/**
 Sends a ARC safe retain message to the object passed.
 @param obj The object being retained.
 @returns the object passed in, after the calling `-retain` in an ARC safe mannor.
 */
int MMRetainCount(NSObject * obj);

/**
 Sends a ARC safe autorelease message to the object passed.
 @param obj The object being retained.
 @returns the object passed in, after the calling `-retain` in an ARC safe mannor.
 
 NSObject * MMRetain(NSObject * obj);
 */
/**
 Sends a ARC safe dealloc message to the object passed. This is typically `super` in the delloc function.
 @param obj The object being retained.
 */
void MMDealloc(NSObject * obj);

/**
 Tests to see if the object is nil.
 @param obj The object pointer to test.
 @return BOOL true if the object is null
 */
BOOL MMNull(NSObject * obj);

/**
 Tests to see if the object is nil.
 @param obj The object pointer to test.
 @returns BOOL true if the object is not null
 */
BOOL MMNotNull(NSObject * obj);

/**
 Tests to see if the object has an avalible instance message.
 @param obj The object to test.
 @param selector The SEL to test for.
 @returns BOOL true if the object responds to the the selector `selector`
 */
BOOL MMSELCheck(NSObject * obj, SEL selector);

/**
 Tests to see if the object has an avalible instance message.
 @param obj The object to test.
 @param selector The name of the selector to test for.
 @returns BOOL true if the object responds to the the selector `selector`
 */
BOOL MMSelectorCheck(NSObject * obj, NSString * selector);

/**
 Creates a unique hash string of an array of values, typically used in identifying objects uniquely.
 @param array The array to encode.
 @returns NSString The unique hash.
 */
NSString * arrayValueHash(NSArray * array);

/**
Creates an Exception object
 @param array The array to encode.
 @returns NSString The unique hash.
 */
NSException * MMException(NSString * message, NSString * type, NSDictionary * other);



id mmCopy(id original);
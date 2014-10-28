//
//  MMAdapter.h
//  BandIt
//
//  Created by Kelly Huberty on 10/10/12.
//
//

#import <Foundation/Foundation.h>
#import "MMUtility.h"

@interface MMAdapter : NSObject



NSString * classPropertyType(Class controlClass, NSString * propertyName);
NSString * propertyClassNameForClassAndPropertyName(Class controlClass, NSString * propertyName);
BOOL setValueForPopertyName(id value, NSString * propertyName, NSObject * object);
NSString * getPropertyTypeName(Class aClass, NSString * propertyName);
void * makeMemoryAllocation(NSString * type);
void * getMemoryAllocationSize(NSString * type);
void freeMemoryAllocation(void * allocMem);
NSString * introspectKVOProperty(Class controlClass, NSString * propertyName);









@end

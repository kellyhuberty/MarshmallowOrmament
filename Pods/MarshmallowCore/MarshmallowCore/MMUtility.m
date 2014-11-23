//
//  MMUtility.m
//  BandIt
//
//  Created by Kelly Huberty on 10/27/12.
//
//

#import "MMUtility.h"
#import <float.h>
@implementation MMUtility

@end

static BOOL arcEnabled = false;

//This runtime compiler block will call release if ARC isn't enabled, or and will do nothing if it is enabled.

void MMSetArcEnabled(){
    
    arcEnabled = true;
    
}

void MMSetArcDisabled(){
    
    arcEnabled = false;
    
}

#if __has_feature(objc_arc)
BOOL MMReleaseRef(NSObject ** ref){
    NSObject * obj = *ref;
    if ( obj != NULL ) {
        //[obj release];
        return true;
    }
    return false;
}
#else
BOOL MMReleaseRef(NSObject ** ref){
    NSObject * obj = *ref;
    if ( obj != NULL ) {
        [obj release];
        obj = nil;
        return true;
    }
    return false;
}
#endif

BOOL MMRelease(NSObject * obj){
    if ( !arcEnabled && obj != NULL ) {
        SEL sel = NSSelectorFromString(@"release");
        //if ([obj respondsToSelector:sel] &&) {
        [obj performSelector:sel];
        //}
        
        return true;
    }
    return false;
}

#if __has_feature(objc_arc)
BOOL mmRelease(NSObject * obj){
    if ( obj != NULL ) {
        //[obj release];
        return true;
    }
    return false;
}
#else
BOOL mmRelease(NSObject * obj){
    if ( obj != NULL && [obj respondsToSelector:@selector(release)]) {
        
        //MMLog(@"@releasing");
        [obj release];
        //MMLog(@"@released");

        obj = nil;
        return true;
    }
    return false;
}
#endif

#if __has_feature(objc_arc)
void MMDealloc(NSObject * obj){
    if ( obj != NULL ) {
            //[obj release];
    }
}
#else
void MMDealloc(NSObject * obj){
    if ( obj != NULL && [obj respondsToSelector:@selector(dealloc)]) {
        
        //MMLog(@"@releasing");
        [obj dealloc];
        //MMLog(@"@released");
        
        obj = nil;
    }
}
#endif

id MMRetain(NSObject * obj){
    if (!arcEnabled) {
        SEL sel = NSSelectorFromString(@"retain");
        [obj performSelector:sel];
    }
    return obj;
}

#if __has_feature(objc_arc)
id mmRetain(NSObject * obj){
    /*
    if ( obj != NULL ) {
        //[obj release];
        return true;
    }
    */
    return obj;
}
#else
id mmRetain(NSObject * obj){
    return [obj retain];
}
#endif


#if __has_feature(objc_arc)
int MMRetainCount(NSObject * obj){
    return sizeof(int);
}
#else
int MMRetainCount(NSObject * obj){
    return [obj retainCount];
}
#endif

id MMAutorelease(NSObject * obj){
    if (!arcEnabled) {
        SEL sel = NSSelectorFromString(@"autorelease");
        [obj performSelector:sel];
    }
    return obj;
}

#if __has_feature(objc_arc)
id mmAutorelease(NSObject * obj){
    /*
     if ( obj != NULL ) {
     //[obj release];
     return true;
     }
     */
    return obj;
}
#else
id mmAutorelease(NSObject * obj){
    return [obj autorelease];
}
#endif

id mmCopy(id original){
    
    return [original copy];
    
}


void mmExceptionRaise(NSString * type, NSString * message){
    
    
//    va_list args;
//    va_start(args, text);
//    
//    //#if DEBUG
//    NSString *log_msg = [[[NSString alloc] initWithFormat:text arguments:args] autorelease];
//    //NSLogv(text, args);
//    //#else
//    if (_debug_mode > 0) {
//        //    MMLogDebugModeV(text, args);
//        NSLogv(text, args);
//    }
//    //#endif
//    va_end(args);
//
//    
//    
//    [NSException raise:type format:];
    
}


BOOL MMNull(NSObject * obj){
    if ( obj == NULL ) {
        return true;
    }
    return false;
}

BOOL MMNotNull(NSObject * obj){
    if ( obj != NULL ) {
        return true;
    }
    return false;
}

BOOL MMSELCheck(NSObject * obj, SEL selector){
    if ([obj respondsToSelector:selector]) {
        return true;
    }
    return false;
}

BOOL MMSelectorCheck(NSObject * obj, NSString * selectorString){
    
    SEL selector = NSSelectorFromString(selectorString);
    
    if ([obj respondsToSelector:selector]) {
        MMLog(@"TRUE");

        return true;
    }
    MMLog(@"FALSE");

    return false;
}

NSString * arrayValueHash(NSArray * array)
{
    
    NSMutableString * keyHash = [NSMutableString stringWithString:@""];
    
    for (id<NSCopying> key in array) {
        
        NSString * hashString = [[NSNumber numberWithInteger:[((id<NSObject>)key) hash]] stringValue];
        
        [keyHash appendString:hashString];
        
    }
    
    return keyHash;
}

NSArray * orderedArrayForDictionary(NSDictionary * dict)
{
    NSArray * keys = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray * values = [NSMutableArray array];

    for (NSString * key in keys) {
        [values addObject:[dict valueForKey:key]];
    }
    
    return values;
}



//NSString * orderedKeyValueArraysForDictionary(NSDictionary * dict, NSArray** keys, NSArray** values)
//{
//    
//    
//    
//}

//NSString * NSStringFromMMVersion(MMVersion ver){
//    
//    return [NSString stringWithFormat:@"%i.%i.%i", ver.major, ver.minor, ver.maintenance];
//    
//}
//
//
//MMVersion MMVersionFromNSString(NSString * string){
//    
//    MMVersion ver;
//    
//    NSArray * arr = [string componentsSeparatedByString:@"."];
//    
//    int count = [arr count];
//    
//    if (count > 1) {
//        ver.major = [(NSString *)arr[0] intValue];
//    }
//    if (count > 2) {
//        ver.minor = [(NSString *)arr[1] intValue];
//    }
//    if (count > 3) {
//        ver.maintenance = [(NSString *)arr[2] intValue];
//    }
//    
//    return ver;
//}
NSException * MMException(NSString * message, NSString * type, NSDictionary * other){
    
    if(type == nil){
        type = @"MMException";
    }
    
    return [NSException exceptionWithName:type reason:message userInfo:other];
    
}




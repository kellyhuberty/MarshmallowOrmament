//
//  MMInit.m
//  BandIt
//
//  Created by Kelly Huberty on 8/19/12.
//
//

#import "MMInit.h"
#import "MMDebug.h"

static NSMutableDictionary * mmIDAssignments;


NSString *nameGetter(id self, SEL _cmd) {
    
    //NSString * var = [mmIDAssignments objectForKey:self];
    
    
    /*
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"UIResponder"), "_mmID");
    id var = object_getIvar(self, ivar);
    */
     
     //MMLog(@"getNAme : %@", var);
    
     return nil;
}



@implementation MMInit

static NSDictionary * controlPropertyMap;
static NSDictionary * controlNameMap;

+(void)start{
    
    [MMDebug loadDebugMode];

}

@end

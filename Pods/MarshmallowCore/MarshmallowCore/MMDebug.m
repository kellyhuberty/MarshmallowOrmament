//
//  MMDebug.m
//  BandIt
//
//  Created by Kelly Huberty on 8/23/12.
//
//
#import "MMPreferences.h"
#include "MMDebug.h"
#include <stdio.h>
#include <stdlib.h>


static int _debug_mode = 0;
static int _debug_counter = 0;


void MMLog(id text, ...){
    va_list args;
    va_start(args, text);

    //#if DEBUG
            //NSString *log_msg = [[[NSString alloc] initWithFormat:text arguments:args] autorelease];
        //NSLogv(text, args);
    //#else
    if (_debug_mode > 0) {
            //    MMLogDebugModeV(text, args);
        NSLogv(text, args);
    }
    //#endif
    va_end(args);

}

BOOL MMDebugOn(){
    if (_debug_mode > 0) {
        //    MMLogDebugModeV(text, args);
        return true;
    }
    return false;
}

int MMDebugCount(){
    int count = _debug_counter;
    ++_debug_counter;
    return count;
}

void MMDebugCountReset(){
    _debug_counter = 0;
}


void MMLogDebugModeV(id text, va_list args){
    NSLogv(text, args);
}



@implementation MMDebug

+(void)loadDebugMode{
    //_debug_mode = [[MMPreferences valueForKey:@"MMDebugModeScheme"] intValue];
    
    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"MMDebugModeScheme"] != nil){
    
        _debug_mode = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"MMDebugModeScheme"] intValue];
    }
    else{
        
        _debug_mode = 1;
    }
    
}

+(void)setEnabled{
    _debug_mode = 1;
    [MMPreferences setValue:[NSNumber numberWithInteger:1] forKey:@"MMDebugModeScheme"];
}

+(void)setDisabled{
    _debug_mode = 0;
    [MMPreferences setValue:[NSNumber numberWithInteger:0] forKey:@"MMDebugModeScheme"];
}

+(BOOL)enabled{
    
    if (_debug_mode > 0) {
        //    MMLogDebugModeV(text, args);
        return true;
    }
    
    return false;
}

+(void)error:(NSError*)error withDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict{
    
    
    
}




@end


//
//  MMDebug.h
//  BandIt
//
//  Created by Kelly Huberty on 8/23/12.
//
//

#import <Foundation/Foundation.h>

@interface MMDebug : NSObject{
    
    
    
    
}

+(void)loadDebugMode;
+(void)setEnabled;
+(void)setDisabled;
+(BOOL)enabled;



@end

/**
 Checks whether the online file is newer than the local file.
 @param onlineURL
 The URL of the file to check.
 @param path
 The local path to check.
 @return YES if the online file is newer than the local one.
 */
void MMLog(id text, ...);

BOOL MMDebugOn();

int MMDebugCount();

void MMDebugCountReset();




enum {
    MMDebugModeSchemeNone = 0,
    MMDebugModeSchemeOff = -1,
    MMDebugModeSchemeOn = 1
};
typedef int MMDebugModeScheme;
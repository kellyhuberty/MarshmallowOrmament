    //
    //  TSTNote.h
    //  MarshmallowORM
    //
    //  Created by Kelly Huberty on 4/2/14.
    //  Copyright (c) 2014 Kelly Huberty. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import "MMRecord.h"
#import "TSAItem.h"
#import "TSANotebook.h"
@interface TSANote : TSAItem{
    
    
    
    
}

@property(nonatomic, retain)NSString * text;
@property(nonatomic, retain)TSANotebook * notebook;
@property(nonatomic)float longitude;
@property(nonatomic)float latitude;


@end

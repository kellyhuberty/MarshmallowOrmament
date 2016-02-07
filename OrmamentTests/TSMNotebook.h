    //
    //  TSANotebook.h
    //  MarshmallowOrmament
    //
    //  Created by Kelly Huberty on 8/5/14.
    //  Copyright (c) 2014 Kelly Huberty. All rights reserved.
    //

#import "MMRecord.h"

@interface TSMNotebook : MMRecord{
    
    
    
    
}

@property(nonatomic)int identifier;
@property(nonatomic)NSString * title;
@property(nonatomic)NSString * description;
@property(nonatomic)MMRelationshipSet * notes;

@end

//
//  TSTNote.h
//  MarshmallowORM
//
//  Created by Kelly Huberty on 4/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRecord.h"
#import "TSTItem.h"
#import "TSTNotebook.h"
@interface TSTNote : TSTItem{
    
    
    
    
}
@property(nonatomic)int identifier;
@property(nonatomic, retain)NSString * text;
@property(nonatomic, retain)MMRelationshipSet * tags;
@property(nonatomic, retain)TSTNotebook * notebook;
@property(nonatomic)float longitude;
@property(nonatomic)float latitude;


@end

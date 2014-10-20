//
//  MMRequestController.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 9/28/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSet.h"

@interface MMRequestController : NSObject{
    
    MMSet * _data;
    MMSet * _groups;
    MMSet * _groupDescriptors;
    int _total;
    int _offset;
    
}


-(instancetype)init;
-(int)total;
-(int)count;

-(id)itemAtIndex:(NSIndexPath *)path faultBlock:(MMRequestController * (^)(void))blockName;
-(id)itemAt:(int)index faultBlock:(MMRequestController * (^)(void))blockName;

-(void)loadPageOfSize:(int)page;
//-(void)loadPageOfSize:(int)page

-(void)loadPageBefore;
-(void)loadPageAfter;
-(void)loadPagesUntilItem:(int)item;



@end

//
//  NSMutableArray+Marshmallow.h
//  Marshmallow
//
//  Created by Kelly Huberty on 1/20/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Marshmallow)
/**
 @param anObject The object to be inserted.
 @param index The index where the object needs to be inserted.
 */
-(void)insertObject:(id)anObject atAbsoluteIndex:(NSUInteger)index;

@end

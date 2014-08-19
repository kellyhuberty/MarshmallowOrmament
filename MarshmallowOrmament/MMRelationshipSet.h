//
//  MMRelationshipSet.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/17/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRecordSet.h"
//#import "MMStore.h"
//#import "

//#import "MMRequest.h"
@class MMRecord;
@class MMRelationship;
@class MMRequest;
@interface MMRelationshipSet : MMRecordSet{
    
    MMSet * _recordsToAdd;
    MMSet * _recordsToDel;
    
    MMRecord * _record;
    MMRelationship * _relationship;
    MMRequest * _request;
    
    BOOL _fetched;
    BOOL _autosave;

    
}
@property (nonatomic, retain)MMRecord * record;
@property (nonatomic, retain)MMRelationship * relationship;
@property (nonatomic, retain)MMRequest * request;
@property (nonatomic)BOOL _fetched;

-(BOOL)fetch:(NSError **)error;
-(BOOL)save:(NSError **)error;
-(BOOL)objectIsValidForRelationship:(NSObject *)obj;


@end

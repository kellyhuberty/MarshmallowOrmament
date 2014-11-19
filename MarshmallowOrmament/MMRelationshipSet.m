//
//  MMRelationshipSet.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/17/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMRelationshipSet.h"
#import "MMRelationship.h"
#import "MMRecord.h"
#import "MMService.h"
#import "MMRequest.h"

@implementation MMRelationshipSet

-(id)init{
    
    if(self = [super init])
    {
        
        _recordsToAdd = [[MMSet alloc]init];
        _recordsToDel = [[MMSet alloc]init];
        
        
    }
    
    return self;
}




-(BOOL)willAddObject:(id)obj{
    
    if ([self objectIsValidForRelationship:obj] && [super willAddObject:obj]) {

        [self addObjectToRelationship:obj];

        
        

    }
    
    return YES;
    
}

-(BOOL)willRemoveObject:(id)obj{
    
    
    
    if ( [super willRemoveObject:obj] ) {
        
        
        [self removeObjectFromRelationship:obj];
        
        //[[[_record class ]store] addRecords:@[obj] toRelationship:_relationship onRecord:_record error:nil];
        
    }
    

    return YES;
    
}

-(void)didAddObject:(id)obj{
    
    
}

-(void)didRemoveObject:(id)obj{
    
    
}

-(NSUInteger)count{
    
    return [super count];
    
}

-(id)objectAtIndex:(NSUInteger)index{
    
    if (!_fetched) {
        
        NSError * error = nil;
        
        [[[_record class] store] executeReadWithRequest:_request error:&error];
    }
    
    return [super objectAtIndex:index];
    
}

-(BOOL)fetch:(NSError **)error{

    
    [self removeAllObjects];
    
    NSError * error2;
    
    [self addObjectsFromArray:[_request executeOnStore:[[_record class] store] error:&error2]];
    
    
    if (error2) {
        *error = error2;
        return NO;
    }
    
    return YES;
}

-(void)addObjectToRelationship:(id)obj{
    
    [_recordsToAdd addObject:obj];
    
    NSError * error = nil;
    
    if (_autosave) {
        [self save:&error];
    }
    
}

-(void)removeObjectFromRelationship:(id)obj{
    
    [_recordsToDel addObject:obj];

    NSError * error = nil;
    
    if (_autosave) {
        [self save:&error];
    }
    
}

-(BOOL)objectIsValidForRelationship:(NSObject *)obj{
    
    if ( ! [obj isKindOfClass:NSClassFromString(_relationship.className)] ) {
        
        [NSException raise:@"MMInvalidObjectInRelationship" format:@"The object of class %@ is not valid for the relationship %@", [obj class], _relationship.name];
        
        return false;
        
    }

    return true;
    
}

-(BOOL)save:(NSError **)error{
    
    BOOL addSuccess = NO;
    BOOL delSuccess = NO;
    
    if ([_recordsToAdd count] > 0) {
        
        addSuccess = [[[_record class ]store] addRecords:_recordsToAdd toRelationship:_relationship onRecord:_record error:error];
        
        [_recordsToAdd removeAllObjects];
        
    }
    else{
        
        addSuccess = YES;
        
    }
    if ([_recordsToDel count] > 0) {
        
        delSuccess = [[[_record class ]store] removeRecords:_recordsToAdd fromRelationship:_relationship onRecord:_record error:error];
        
        [_recordsToDel removeAllObjects];
        
    }
    else{
        
        delSuccess = YES;
        
    }
    
    if(error){
        
        NSLog(@"ERR SAVING RELSET %@",[*error localizedDescription]);
        
    }
    
    
    return addSuccess && delSuccess;

}


-(BOOL)dirty{
    
    if ([_recordsToAdd count] > 0) {
        return true;
    }
    if ([_recordsToDel count] > 0) {
        return true;
    }
    
    return false;

}

@end
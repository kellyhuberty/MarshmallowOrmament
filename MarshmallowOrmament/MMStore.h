//
//  MMStore.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 11/17/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMService.h"

@protocol MMStore <NSObject>

-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(MMRelationshipSet *)buildRelationshipObjectWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values;
-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;
-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error;
-(MMRequest *)newRequestForClassname:(NSString *)className;

-(BOOL)build:(NSError **)error;

@end

@interface MMStore : MMService<MMStore>

@end

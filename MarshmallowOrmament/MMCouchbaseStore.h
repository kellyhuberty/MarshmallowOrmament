//
//  MMCouchbaseStore.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 12/26/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMStore.h"
#import "CouchbaseLite.h"

@interface MMCouchbaseStore : MMStore<MMStore>{
    
    CBLManager * _manager;
    CBLDatabase * _db;
    
}

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error;
-(MMRequest *)newRequestForClassname:(NSString *)className;

-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(MMRelationshipSet *)buildRelationshipObjectWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values;
-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;
-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;


@end

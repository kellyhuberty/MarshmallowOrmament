////
////  MMStore.h
////  BandIt
////
////  Created by Kelly Huberty on 7/13/12.
////  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
////
/**
 MMStore is meant to be an abstract class for 
 */
#import <Foundation/Foundation.h>
//#import "MMBuilder.h"
#import "MMSchema.h"
#import "MMService.h"


#import "MMRelationship.h"
#import "MMRelationshipSet.h"

#import "MMVersionString.h"
#import "MMConditional.h"

@class MMRequest;
@class MMRecord;

@interface MMService : NSObject{

    MMSchema * _schema;
    
    NSOperationQueue * _operationQueue;
    
}
@property(nonatomic, retain)MMSchema * schema;
@property(nonatomic, readonly)NSOperationQueue * operationQueue;


-(instancetype)initWithSchema:(MMSchema *)schema;
+(MMService *)storeWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver;
+(MMService *)newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)serviceType version:ver;
-(BOOL)build:(NSError **)error;

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error;
-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)refreshRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values forRowId:(long long)rowId;
-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(NSOperationQueue *)operationQueue;


-(MMRelationshipSet *)buildRelationshipObjectWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values;
-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;
-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;

@end

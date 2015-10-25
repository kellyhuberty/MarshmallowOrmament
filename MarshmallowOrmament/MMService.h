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
//+(MMService *)storeWithSchemaName:(NSString *)schemaName version:(MMVersionString *)ver;
//+(MMService *)serviceWithSchemaName:(NSString *)schemaName type:(NSString *)serviceType version:(MMVersionString *)ver;
//+(MMService *)newServiceWithSchemaName:(NSString *)schemaName serviceType:(NSString *)serviceType version:ver;
-(BOOL)build:(NSError **)error;

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error;
-(MMRequest *)newRequestForClassname:(NSString *)className;


-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;
-(BOOL)refreshRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values forRowId:(long long)rowId;
-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(NSOperationQueue *)operationQueue;


-(MMRelationshipSet *)buildRelationshipObjectWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values;
-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;
-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;


-(MMSet *)wrapData:(NSArray *)array intoRecordsOfType:(NSString *)classname inSet:(MMSet *)set created:(BOOL)created;
-(MMRecord *)wrapValues:(NSDictionary *)values intoRecordOfType:(NSString *)classname created:(BOOL)created;


+(void)addRecordToActiveRecords:(MMRecord *)rec;
+(void)removeRecordFromActiveRecords:(MMRecord *)rec;
+(MMRecord *)retrieveActiveRecord:(NSString *)hash;



+(MMVersionString *)currentVersionForSchemaName:(NSString *)schemaName type:(NSString *)type;
+(void)setCurrentVersion:(MMVersionString *)version forSchemaName:(NSString *)schemaName type:(NSString *)type;
+(void)unsetVersionForSchemaName:(NSString *)schemaName type:(NSString *)type;


@end


typedef enum : NSUInteger {
   
    MMCrudOperationCreate,
    MMCrudOperationRead,
    MMCrudOperationUpdate,
    MMCrudOperationDelete
    
} MMCrudOperation;

NSString * MMStringFromCrudOperation(MMCrudOperation op);
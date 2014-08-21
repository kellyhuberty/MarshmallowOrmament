//
//  MMSQLiteStore.h
//  Marshmallow
//
//  Created by Kelly Huberty on 2/23/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMStore.h"
//#import <sqlite3.h>
#import <FMDB/FMDB.h>

@class MMRecord;

@interface MMSQLiteStore:MMStore{
  
    FMDatabase * _db;
    FMDatabaseQueue * _dbQueue;

    
}
@property (nonatomic, retain)FMDatabaseQueue * dbQueue;
@property (nonatomic, retain)FMDatabase * db;
//@property (nonatomic, retain)FMDatabase * db;


-(BOOL)copyFromVersion:(MMVersionString *)ver error:(NSError **)error;

-(NSArray *)loadRecordOfType:(NSString *)classname withResultsOfQuery:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary;





+(NSString *)rowidColumnNameForRecord:(MMRecord *)rec;
+(NSString *)rowidColumnNameForEntity:(MMEntity *)entity;
-(NSString *)rowidColumnNameForEntityName:(NSString *)name;

+(NSString *)primaryKeyWhereClauseForRecord:(MMRecord *)rec;

+(NSString *)queryWithRequest:(MMRequest *)req;

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error;

-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;

-(BOOL)refreshRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values forRowId:(long long)rowId;

-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error;


+(NSString *)buildInsertQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values;
+(NSString *)buildSelectQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values;
+(NSString *)buildUpdateQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values;
+(NSString *)buildDeleteQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values;
+(NSString *)buildParameterList:(NSArray *)paramNames;
+(NSString *)buildList:(NSArray *)listItems;
+(NSString *)buildSetList:(NSArray *)params;


-(MMRelationshipSet *)buildRelationshipSetWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values;
-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;
-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error;

-(NSString *)tableNameWithEntityName:(NSString *)str;

@end
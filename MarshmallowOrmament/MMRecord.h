//
//  MMModel.h
//  Marshmallow
//
//  Created by Kelly Huberty on 4/24/13.
//  Copyright (c) 2013 Kelly Huberty. All rights reserved.
//

//#import <CoreData/CoreData.h>
//#import "MMCoreData.h"
#import "MMAttribute.h"
#import "MMService.h"
#import <Foundation/Foundation.h>
    //#import "MMEntity.h"

id fetchRelationshipSet(MMRecord * self, NSString * key, MMRelationship* relationship);

@class MMRecord;
typedef enum{
    MMRecordUninserted,
    MMRecordClean,
    MMRecordDirty,
    MMRecordDestroyed
}MMRecordState;


@protocol MMRecord

+(NSString *)entityName;
+(NSString *)schemaName;

+(NSArray *)idKeys;
-(NSDictionary *)idValues;
-(NSString *)idHash;

-(instancetype)initWithFillValues:(NSDictionary *)values created:(BOOL)inserted fromStore:(MMService *)store;
-(instancetype)create;
-(instancetype)create:(NSDictionary*)values;

-(BOOL)destroy;

-(BOOL)save:(NSError **)error;
-(BOOL)save;
-(void)revert;
-(BOOL)valid:(NSError **)err;
-(BOOL)validForUpdate:(NSError **)err;
-(BOOL)validForCreate:(NSError **)err;

-(void)logValues;


@property (atomic, readonly)NSArray * attributes;

@property (atomic, readonly)BOOL deleted;
@property (atomic, readonly)BOOL inserted;
@property (atomic, readonly)BOOL dirty;


@end






@interface MMRecord : NSObject<MMRecord>{
    
    //MMEntity * _entity;
    //
    
    NSMutableDictionary * _values;
    NSMutableDictionary * _relationValues;
    
    //
    //NSMutableDictionary * _dirtyValues;
    //
    //NSMutableDictionary * _conflictValues;

    
    BOOL _inserted;
    BOOL _deleted;
    BOOL _dirty;

    
}
@property (atomic, readonly)BOOL deleted;
@property (atomic, readonly)BOOL inserted;
@property (atomic)BOOL dirty;


//@property (nonatomic, retain)NSDictionary * values;
//@property (nonatomic, readonly)NSString * identifier;
//@property (nonatomic, readonly)NSDictionary * identifierDictionary;


//@property (nonatomic, retain)MMEntity * mmEntity;
//@property (nonatomic, retain)MMService * mmService;
//@property (nonatomic, retain)NSMutableDictionary * mmValues;
+(MMSet *)attributes;
+(MMEntity *)entity;
+(MMService *)store;
+(MMRequest *)newRequest;


+(instancetype)create;


-(id)init;
-(BOOL)save:(NSError **)error;
-(BOOL)save;

//-(BOOL)delete:(NSError **)error;
//-(BOOL)delete;

-(BOOL)destroy:(NSError **)error;
-(BOOL)destroy;

-(void)revert;



-(BOOL)valid:(NSError **)err;
-(BOOL)validForUpdate:(NSError **)err;
-(BOOL)validForCreate:(NSError **)err;


+(BOOL)executeCreateOnRecord:(MMRecord *)record withValues:(NSMutableDictionary *)dictionary error:(NSError **)err;
+(BOOL)executeReadOnRecord:(MMRecord *)record withValues:(NSMutableDictionary *)dictionary error:(NSError **)err;
+(BOOL)executeUpdateOnRecord:(MMRecord *)record withValues:(NSMutableDictionary *)dictionary error:(NSError **)err;
+(BOOL)executeDestroyOnRecord:(MMRecord *)record withValues:(NSMutableDictionary *)dictionary error:(NSError **)err;
+(MMService *)store;

@end



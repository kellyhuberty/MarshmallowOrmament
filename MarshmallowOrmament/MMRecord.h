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
#import "MMStore.h"
#import <Foundation/Foundation.h>
    //#import "MMEntity.h"
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

-(instancetype)initWithFillValues:(NSDictionary *)values created:(BOOL)inserted fromStore:(MMStore *)store;
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


@property (nonatomic, readonly)NSArray * attributes;

@property (nonatomic, readonly)BOOL deleted;
@property (nonatomic, readonly)BOOL inserted;
@property (nonatomic, readonly)BOOL dirty;


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
@property (nonatomic, readonly)BOOL deleted;
@property (nonatomic, readonly)BOOL inserted;


//@property (nonatomic, retain)NSDictionary * values;
//@property (nonatomic, readonly)NSString * identifier;
//@property (nonatomic, readonly)NSDictionary * identifierDictionary;


//@property (nonatomic, retain)MMEntity * mmEntity;
//@property (nonatomic, retain)MMService * mmService;
//@property (nonatomic, retain)NSMutableDictionary * mmValues;
+(MMSet *)attributes;
+(MMEntity *)entity;
+(MMStore *)store;
+(MMRequest *)newRequest;


-(void)create;


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
+(MMStore *)store;

@end



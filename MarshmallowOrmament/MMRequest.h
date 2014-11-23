//
//  MMRequest.h
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/18/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMService.h"
#import "MMOrmMeta.h"


typedef void (^completionBlock)(MMSet *, NSError *__autoreleasing *);

@interface MMRequest : NSObject{
    
    NSString * _sqlSelect;
    NSString * _sqlFrom;
    NSString * _sqlWhere;
    NSMutableDictionary * _sqlBindValues;
    
    MMOrmMeta * _meta;
    
    MMSet * _predicates;
    NSString * _schemaName;    
    
    MMConditional * _conditional;
    
    //SEL _selector;
    //id _target;
    NSInvocation * _invocation;
    
    completionBlock _completionBlock;
    
    BOOL _synchronous;
    
    int _offset;
    int _limit;
    
    NSString * _className;
    NSString * _entityName;
    MMService * _service;
    
}

@property(atomic, retain)MMSet * results;
@property(nonatomic, retain)NSString * className;
@property(nonatomic, retain)NSString * entityName;

@property(atomic, retain)MMService * service;

@property(atomic, retain)NSString * _sqlQuery;

@property(atomic)int limit;
@property(atomic)int offset;


//@property(nonatomic, retain)NSString * sqlSelect;
//@property(nonatomic, retain)NSString * sqlFrom;
//@property(nonatomic, retain)NSString * sqlWhere;
//@property(nonatomic, retain, readonly)NSMutableDictionary * sqlBindValues;


@property(atomic, copy) void (^completionBlock)(MMSet* set, NSError *__autoreleasing* error);


-(id)init;
-(id)initWithService:(MMService *)store classname:(NSString *)className;

-(void)executeWithCompletionBlock:(void (^)(MMRecordSet* set, NSError ** error))block;

-(void)executeOnStore:(MMService *)store completionBlock:(void (^)(MMRecordSet* set, NSError ** error))block;
-(void)completedWithResults:(MMSet *)set error:(NSError**)error;

-(MMSet *)executeOnStore:(MMService *)store error:(NSError**)error;
//@property(nonatomic, retain)

@end

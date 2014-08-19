//
//
//  MMCoreDataRecord.h
//  Vehicular
//
//  Created by Kelly Huberty on 5/5/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/foundation.h>
#import "MMRecord.h"
//#import "MMRecord+private.h"

#import "MMSet.h"
@interface MMSQLiteRecord : MMRecord<MMRecord>{
    
    NSString * _timestampKey;

    //NSMutableDictionary * _values;
    NSMutableDictionary * _relationships;
    
}
//@property(nonatomic)BOOL inserted;
//@property(nonatomic)BOOL deleted;
//@property(nonatomic)BOOL dirty;



+(NSString *)entityName;
+(MMSQLiteRecord *)create;
+(MMSQLiteRecord *)create:(NSDictionary *)dictionary;



-(BOOL)valid:(NSError **)error;



-(NSString *)buildInsertQuery;
-(NSString *)buildUpdateQuery;




-(void)setValue:(id)value forKey:(NSString *)path;
-(id)valueForKey:(NSString *)key;


@end

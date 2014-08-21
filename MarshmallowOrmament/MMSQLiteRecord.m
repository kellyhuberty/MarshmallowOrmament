//
//  MMCoreDataRecord.m
//  Vehicular
//
//  Created by Kelly Huberty on 5/5/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteRecord.h"
#import <FMDB/FMDB.h>
#import "MMUtility.h"
#import "MMAttribute.h"
#import "MMSQLiteStore.h"
@implementation MMSQLiteRecord

-(id)init{
    
    self = [super init];
    
    if(self){
        
        //_values = [[NSMutableArray alloc]init];
        
        //_values = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : @1 , @"time" : [NSDate date], @"price" : @3.23, @"odometer" : @12232 }];
        
        //_relationships = [[NSMutableArray alloc]init];
        //_inserted = NO;
        //_dirty = NO;
        //_deleted = NO;
    }
    
    return self;
    
}

+(NSString *)entityName{

    return @"tablename";
    
}

+(NSString *)tableName{
    
    return [self entityName];
    
}

//+(NSString *)rowidColumnNameForRecord:(MMRecord *)rec{
//    
//    NSArray * idKeys = [self idKeys];
//    
//    //return [self entityName];
//    if([idKeys count] == 1){
//        
//        NSString * key = idKeys[0];
//        
//        NSString * className = [[[[rec class] entity] attributeWithName:key] classname];
//        NSString * primativeName = [[[[rec class] entity] attributeWithName:key] primativeType];
//
//        if ([className isEqualToString:@"NSNumber"] && [primativeName isEqualToString:@"int"]) {
//            return key;
//        }
//        
//        
//    }
//    
//    
//    return @"ROWID";
//}


+(NSArray *)primaryKeyNames{
    
    return @[@"id", @"time"];
    
}


-(NSDictionary *)primaryKey{
    
    NSArray * names = [[self class]primaryKeyNames];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString * name in names) {
        [dict setObject:_values[name] forKey:name];
    }
    
    return dict;
}

+(NSString *)primaryKeyWhereClauseForRecord:(MMRecord *)rec{
    
    NSArray * params = [[rec class] idKeys];
    NSMutableArray * paramStringArray = [NSMutableArray array];
    
    for (NSString * pName in params) {
        [paramStringArray addObject: [NSString stringWithFormat:@" %@ = :%@" , pName, pName ]];
    }
    
    return [paramStringArray componentsJoinedByString:@" AND "];
    
}



+(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    FMDatabase * db = [[self class] database];
    
    NSLog(@"UPDATEING");
    
    [db executeUpdate:[self buildUpdateQueryForRecord:rec values:values] withParameterDictionary:values];
    
    return true;

}

+(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    

    
    
    FMDatabase * db = [[self class] database];
    
    
    
    [db executeUpdate:[self buildInsertQueryForRecord:rec values:values] withParameterDictionary:values];
    
    //if ( [values count] != [[[rec class] entity] count]) {
        
        //[db lastInsertRowId];
        
        [self.store refreshRecord:rec withValues:values forRowId:[db lastInsertRowId]];
        
    //}
    
    return true;

}

//+(BOOL)refreshRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values forRowId:(long long)rowId{
//    
//    FMDatabase * db = [[self class] database];
//    
//    [values removeAllObjects];
//    
//    NSString * rowIdKey = [()self.store rowidColumnNameForRecord:rec];
//    
//    NSLog(@"REFRESHED VALUES %@", [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `%@` = :%@", [[rec class] tableName] , rowIdKey, rowIdKey]);
//    
//    
//    FMResultSet * res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE `%@` = :%@", [[rec class] tableName], rowIdKey, rowIdKey] withParameterDictionary:@{rowIdKey:[NSNumber numberWithLongLong:rowId]}];
//    
//    BOOL crap = [res next];
//    
//    [values addEntriesFromDictionary: [res resultDictionary]];
//    
//    [res close];
//    
//    NSLog(@"REFRESHED VALUES %@", values);
//    
//    
//    
//    return true;
//    
//}

+(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    NSLog(@"DELDELDEL");
    
    
    [[[rec class] database]executeUpdate:[self buildDeleteQueryForRecord:rec values:values] withParameterDictionary:[rec idValues]];
    return true;

}

//-(BOOL)executeDelete:(NSError **)error{
//    
//    [[[self class] database]executeUpdate:[self buildDeleteQuery] withParameterDictionary:[self idValues]];
//    return true;
//    
//}


+(NSString *)buildInsertQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    NSLog(@" insert %@", [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",[[self class] tableName], [self buildList:[values allKeys]], [self buildParameterList:[values allKeys]] ]);
    
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",[[self class] tableName], [self buildList:[values allKeys]], [self buildParameterList:[values allKeys]] ];
    
}


+(NSString *)buildSelectQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", [[rec class] tableName], [self primaryKeyWhereClauseForRecord:rec] ];
    
}


+(NSString *)buildUpdateQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",[[self class] tableName], [self buildSetList:[values allKeys]], [self primaryKeyWhereClauseForRecord:rec]];
    
}

+(NSString *)buildDeleteQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{

        NSLog( @"deltesdfas %@", [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[[rec class] tableName], [self primaryKeyWhereClauseForRecord:rec]]);
    
    
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[[rec class] tableName], [self primaryKeyWhereClauseForRecord:rec]];
    
}

+(NSString *)buildParameterList:(NSArray *)paramNames{
    
    //NSMutableString * paramString = [NSMutableString stringWithString:@""];
    NSMutableArray * paramStringArray = [NSMutableArray array];
    
    for (NSString * pName in paramNames) {
        [paramStringArray addObject: [NSString stringWithFormat:@":%@" , pName ]];
    }
    
    return [self buildList:paramStringArray];
    
}

+(NSString *)buildList:(NSArray *)listItems{
    
    //NSMutableString * paramString = [NSMutableString stringWithString:@""];
    
    return [listItems componentsJoinedByString:@","];
    
}

+(NSString *)buildSetList:(NSArray *)params{
    
    //NSMutableString * paramString = [NSMutableString stringWithString:@""];
    NSMutableArray * paramStringArray = [NSMutableArray array];
    
    for (NSString * pName in params) {
        [paramStringArray addObject: [NSString stringWithFormat:@" %@ = :%@" , pName, pName ]];
    }
    
    return [paramStringArray componentsJoinedByString:@","];
    
}

+(FMDatabase *)database{
    

    return [((MMSQLiteStore *)[[self class] store]) db];
    
    
}



@end

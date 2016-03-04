//
//  MMSQLiteStore.m
//  Marshmallow
//
//  Created by Kelly Huberty on 2/23/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteStore.h"
#import "MMAutoRelatedEntity.h"
#import "MMAttribute.h"
#import "MMRecord.h"
#import "MMSQLiteRequest.h"
#import "MMRelationship.h"
#import "MMSQLiteRelater.h"
#import "MMSQLiteJoin.h"

#import <objc/runtime.h>
 
//#import <sqlite3.h>



@implementation MMSQLiteStore



-(instancetype)initWithSchema:(MMSchema *)schema;
{
    self = [super init];
    if (self) {
        
        _schema = MMRetain(schema);
        
    }
    return self;
}


-(FMDatabase *)db{
    
    if (!_db) {
        _db = [[FMDatabase alloc]initWithPath:[self dbPath]];
        [_db open];
    
    }
    
    
    return _db;
}


-(FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    }
    return _dbQueue;
}


-(NSString *)dbPath{
    
    return [self dbPathWithVersion:_schema.version];

}


-(NSString *)dbPathWithVersion:(MMVersionString *)ver{
    
    NSString * dataDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSLog(@"PATHS::: %@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    
    //NSLog(@" db dir :%@", [NSString stringWithFormat:@"%@/%@__%@.db", dataDir, _schema.name, [_schema.version pathString]]);
    
    NSString * path = [NSString stringWithFormat:@"%@/%@__%@.db", dataDir, _schema.name, [_schema.version pathString]];
    
    NSLog(@" db dir :%@", path);
    
    return path;
    
}


-(BOOL)build:(NSError **)error{
    
    //BOOL worked = [[self db] executeUpdate:[self buildSql] withErrorAndBindings:error];
    
    
    FMDatabase * db = [self db];
    
    
    BOOL worked = [db executeStatements:[self buildSchemaSql]];

    
    NSLog(@"err---   %@", [self buildSchemaSql]);
    
    if (!worked) {
        NSLog(@"SQL QUery Failed! %@", [[self db] lastErrorMessage]);
    
    }
    
    if (!worked) {
        NSLog(@"SQL QUery Failed! %@", [[self db] lastErrorMessage]);
        
        //NSLog(@"SQL QUery Failed! %@", [*error description]);

        
    }
    
    return worked;
}


-(BOOL)copyFromVersion:(MMVersionString *)ver error:(NSError **)error{
    
    //BOOL worked = [[self db] executeUpdate:[self buildSql] withErrorAndBindings:error];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL worked = [fileManager copyItemAtPath:[self dbPathWithVersion:ver]  toPath:[self dbPath]  error:error];
    
    return worked;
}


-(NSString *)buildSchemaSql{
    
    NSMutableString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.schema.entities){
        
        NSLog(@"buis");
        
        [fullSQL appendString:[[self class] createSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}

-(NSString *)destroySchemaSql{
    
    NSMutableString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.schema.entities){
        
        [fullSQL appendString:[[self class] dropSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}



-(NSString *)upgradeSchemaSql{
    
    NSMutableString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.schema.entities){
        
        [fullSQL appendString:[[self class] createSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}


+(NSString *)createSQLForEntity:(MMEntity *)entity{
    
    return [NSString stringWithFormat:@"\nCREATE TABLE `%@` ( %@ %@ );", entity.name, [[self class] createSQLForAttributes: entity.attributes], [[self class] createSQLForConstraints: entity] ];
    
}

+(NSString *)createSQLForConstraints:(MMEntity *)entity{
    if ([entity.idKeys count] > 0) {
        return [NSString stringWithFormat:@",\n PRIMARY KEY (%@) ON CONFLICT ROLLBACK", [entity.idKeys componentsJoinedByString:@", "] ];
    }
    
    return @"";
}

+(NSString *)dropSQLForEntity:(MMEntity *)entity{
    
    return [NSString stringWithFormat:@"DROP TABLE `%@`;", entity.name];
    
}


+(NSString *)createSQLForAttributes:(NSArray *)attributes{
    
    //[NSString stringWithFormat:@" %@ %@ %@", attribute.name, attribute.type];
    
    //NSMutableString * sql = [NSMutableString stringWithString:@""];
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (MMAttribute * attribute in attributes) {
        [array addObject:[self createSQLForAttribute:attribute]];
    }
    
    return [array componentsJoinedByString:@",\n"];
    
}


+(NSString *)createSQLForAttribute:(MMAttribute *)attribute{
    
    return [NSString stringWithFormat:@" `%@` %@ %@", attribute.name, [[self class] sqlTypeForClassName:attribute.classname primativeType:attribute.primativeType], [[self class] sqlAttributeConstraintsForAttribute:attribute] ];
    
}



+(NSString *)sqlAttributeConstraintsForAttribute:(MMAttribute *)attribute{
    
    //return [NSString stringWithFormat:@" `%@` %@ %@", attribute.name, [[self class] sqlTypeForClassName:attribute.classname primativeType:attribute.primativeType], [[self class] sqlAttributeConstraintsForAttribute:attribute] ];
    
    NSMutableString * constraints = [NSMutableString stringWithString:@""];
    
    if (attribute.unique == true) {
        [constraints appendString:@" UNIQUE"];
    }

    if (!attribute.nullable) {
        [constraints appendString:@" NOT NULL"];
    }
    
    if (attribute.defaultValue) {
        [constraints appendFormat:@" DEFAULT %@", attribute.defaultValue];
    }
    
    return constraints;
    
}
//+(NSString *)createSQLForEntity:(MMEntity *)entity{
//
//    return [NSString stringWithFormat:@"CREATE TABLE `%@` ( %@ )", entity.tableName, [[self class] createSQLForAttributes: entity.attributes]];
//
//}


+(NSString *)sqlTypeForClassName:(NSString *)className primativeType:(NSString *)primativeType{
    
    NSLog(@"class_name:%@", [NSString class]);
    
    if ([className isEqualToString:@"NSString"]) {
        return @"TEXT";
    }
    //if ([ className isEqualToString:(@"NSNumber") ]) {
        if([primativeType isEqualToString:@"integer"] || [primativeType isEqualToString:@"int"]){
            return @"INTEGER";
        }
        if([primativeType isEqualToString:@"boolean"] || [primativeType isEqualToString:@"BOOL"]){
            return @"INTEGER (1)";
        }
        if([primativeType isEqualToString:@"float"] || [primativeType isEqualToString:@"double"] ){
            return @"REAL";
        }
    //}
    if ([className isEqualToString:@"NSDate"]) {
        return @"TEXT";
    }
    
    return @"BLOB";
    
}


-(MMResultsSet *)loadRecordOfType:(NSString *)classname withResultsOfQuery:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary{

    MMResultsSet * array = nil;
    
    NSError * error = nil;
    
    if(!(array = [self loadRecordOfType:classname withResultsOfQuery:query withParameterDictionary:dictionary error:&error])){
        
        [NSException raise:@"MMInvalidSQLQueryException" format:@"The query performed on this sqlite database is failing. Error:%@", [error localizedDescription]];
        
    }
    
    return array;
    
}

-(int)loadCountOfRequest:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary{
    
    int count = MMResultsSetNoOffset;
    
    NSError * error = nil;
    
    count = [self loadCountOfRequest:query withParameterDictionary:dictionary error:&error];

    return count;
    
}

-(MMResultsSet *)loadRecordOfType:(NSString *)classname withResultsOfQuery:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary error:(NSError **)error{
    
    MMResultsSet * __block ret;
    
    if (! NSClassFromString(classname)) {
        [NSException raise:@"MMInvalidClassnameException" format:@"The classname provided %@ does not reference a valid class.", classname];
    }
    
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
    
        FMResultSet * result = nil;
        
        if(dictionary && [dictionary count] > 0){
            result = [db executeQuery:query withParameterDictionary:dictionary];
        }
        else{
            result = [db executeQuery:query];
        }
        
        if (result) {
            
            ret = [[MMResultsSet alloc]init];
            
            while ([result next]) {
                
                NSDictionary * values = [result resultDictionary];
                
                //MMRecord * rec = [[ NSClassFromString(classname) alloc]initWithFillValues:values created:YES fromStore:self];
                
                MMRecord * rec = [self wrapValues:values intoRecordOfType:classname created:YES];
                
                [ret addObject:rec];
                
                MMRelease(rec);
                
            }
            
            [result close];
            
        }
        else{
            
           // *error = [db lastError];
            
        }
        
    }];
    
    MMResultsSet * resultSet = MMAutorelease([[MMResultsSet alloc]init]);;
    
    [resultSet addObjectsFromArray:ret];
    
    return resultSet;
}


-(int)loadCountOfRequest:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary error:(NSError **)error{
    
    NSMutableArray * __block ret;
    
    int __block count = MMResultsSetNoTotal;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * result = nil;
        
        if(dictionary && [dictionary count] > 0){
            result = [db executeQuery:query withParameterDictionary:dictionary];
        }
        else{
            result = [db executeQuery:query];
        }
        
        if (result) {
            
            ret = [NSMutableArray array];
            
            if ([result next]) {
                
                NSDictionary * values = [result resultDictionary];
                
                    //MMRecord * rec = [[ NSClassFromString(classname) alloc]initWithFillValues:values created:YES fromStore:self];
                
                //MMRecord * rec = [self wrapValues:values intoRecordOfType:classname created:YES];
                
                //[ret addObject:rec];
                
                //MMRelease(rec);
                
                count = [(NSNumber *)values[@"count"] intValue];

                [result close];
            }
            

            
        }
        else{
            
            //*error = [db lastError];
            
        }
        
    }];
    
    NSLog(@"load Count : %i", count);
    
    return count;
}



-(NSString *)tableNameWithEntityName:(NSString *)entityName{
    
    return [NSString stringWithFormat:@"`%@`", entityName];
    
}


+(NSString *)buildRelationshipReadSqlWithRelationship:(MMRelationship *)relationship{
    
    NSMutableString * clause = [NSMutableString stringWithString:@""];
    
    MMSQLiteRelater * relater = nil;
    
    
    if([relationship.storeRelater isKindOfClass:[MMSQLiteRelater class]]){
        
        relater = (MMSQLiteRelater*)relationship.storeRelater;
        
    }
    
    
    NSString* sql =nil;

    
    sql = [NSString stringWithFormat:@"SELECT %@.* FROM %@ JOIN ON (%@.%@ = %@.%@",
             [relater relatedEntityName],
             [relater recordEntityName],
             [relater relatedEntityName],
             [relater recordEntityName],
             [relater recordEntityAttribute],
             [relater relatedEntityName],
             [relater relatedEntityAttribute]
             ];
    
    
    sql = [NSString stringWithFormat:@"SELECT %@.* FROM %@ JOIN %@ WHERE %@.%@ = %@.%@",
           [relater relatedEntityName],
           [relater recordEntityName],
           [relater relatedEntityName],
           [relater recordEntityName],
           [relater recordEntityAttribute],
           [relater relatedEntityName],
           [relater relatedEntityAttribute]
           ];
    
    
    
    
    
    
    return sql;
}


-(NSString *)buildJoinSqlWithAutoRelationship:(MMRelationship *)relationship{
    
    NSMutableString * clause = [NSMutableString stringWithString:@""];
    
    MMEntity * local = [self.schema entityForName:relationship.localEntityName];
    MMEntity * foreign = [self.schema entityForName:relationship.relatedEntityName];
    MMAutoRelatedEntity * inter = (MMAutoRelatedEntity *)[self.schema entityForName:relationship.autoRelateName];
    
    [clause appendFormat:@"%@ JOIN %@ ON %@.%@ = %@.%@ JOIN %@ ON %@.%@ = %@.%@",
     local.name,
     inter.name,
     local.name,
     [[self class] rowidColumnNameForEntity:local],
     inter.name,
     [inter localAttributeNameForRelation:relationship],
     foreign.name,
     inter.name,
     [inter foreignAttributeNameForRelation:relationship],
     foreign.name,
     [[self class] rowidColumnNameForEntity:foreign]
     ];
    
    return [NSString stringWithString:clause];
}

-(MMRelationshipSet *)buildRelationshipObjectWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values{
    
    MMRelationshipSet * set = nil;
    
    if(!relationship.storeRelater){
        
        set = [self buildAutomaticRelationshipSetWithRelationship:relationship record:record values:values];
        
    }
    else{
        
        set = [self buildManualRelationshipSetWithRelationship:relationship record:record values:values];

    }
    
    //NSLog(@"%@", set);
    
    
    return set;
}


-(MMRelationshipSet *)buildAutomaticRelationshipSetWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values{
    
    MMRelationshipSet * set = [[MMRelationshipSet alloc]init];
    
    MMSQLiteRequest * request = MMAutorelease([[MMSQLiteRequest alloc] init]);
    
    request.className = relationship.relatedClassName;
    
    request.sqlSelect = [NSString stringWithFormat:@"%@.*", relationship.relatedEntityName];
    
    request.sqlFrom = [NSString stringWithFormat:@"%@", [self buildJoinSqlWithAutoRelationship:relationship]];
    
    request.sqlWhere = [[self class]primaryKeyWhereClauseForRecord:record];
    
    
    NSDictionary * idValues = [record idValues];
    
    
    @synchronized(request.sqlBindValues){
        for (NSString * key in [idValues allKeys]) {
            request.sqlBindValues[key] = idValues[key];
        }
    }
    
        //request.sqlBindValues[key] idValues;//[[self class]primaryKeyWhereClauseForRecord:record];

    
    NSLog(@"%@ %@ %@",request.sqlSelect, request.sqlFrom, request.sqlWhere);
    
    set.relationship = relationship;
    
    set.request = request;
    
    set.record = record;
    
    NSError * error = nil;
    
    //[set fetch:&error];
    
    if ([set fetch:&error]) {
        NSLog(@"cant fetch error ___%@", [error localizedDescription]);
    }
    
    NSLog(@"SETT:%@", set);
    
    return set;
}


-(MMRelationshipSet *)buildManualRelationshipSetWithRelationship:(MMRelationship *)relationship record:(MMRecord *)record values:(NSDictionary *)values{
    
    MMRelationshipSet * set = [[MMRelationshipSet alloc]init];
    
    set.relationship = relationship;
    
    MMSQLiteRequest * request = [[MMSQLiteRequest alloc] init];
    
    request.className = relationship.relatedClassName;
    
    MMSQLiteRelater * relater = nil;
    
    
    if([relationship.storeRelater isKindOfClass:[MMSQLiteRelater class]]){
        
        relater = (MMSQLiteRelater*)relationship.storeRelater;
        
    }
    
    
//    
//    sql = [NSString stringWithFormat:@"SELECT %@.* FROM %@ JOIN %@ WHERE %@.%@ = %@.%@",
//           [relater relatedEntityName],
//           [relater recordEntityName],
//           [relater relatedEntityName],
//           [relater recordEntityName],
//           [relater recordEntityAttribute],
//           [relater relatedEntityName],
//           [relater relatedEntityAttribute]
//           ];
//    
//    
//    
    
    
    request.sqlSelect = [NSString stringWithFormat:@"%@.*", [relater relatedEntityName]];
    
    request.sqlFrom = [NSString stringWithFormat:@"%@ JOIN %@ ON (%@.%@ = %@.%@)",
                                                   [relater recordEntityName],
                                                   [relater relatedEntityName],
                                                   [relater recordEntityName],
                                                   [relater recordEntityAttribute],
                                                   [relater relatedEntityName],
                                                   [relater relatedEntityAttribute]];
    
    request.sqlWhere = [[self class]primaryKeyWhereClauseForRecord:record];
    
    [request.sqlBindValues addEntriesFromDictionary:[record idValues]];
    
    set.request = request;
    
    set.record = record;
    
    [set fetch:nil];
    
    NSLog(@"SETT:%@", set);
    
    return set;
}


-(MMRelationshipSet *)buildManualRelationshipDeleteSQLOfRecords:(NSArray *)records toRelationship:(MMRelationship *)relationship record:(MMRecord *)record {
    
    //MMSQLiteRelater * relater = relationship.storeRelater;

    
    
    
    
    //INSERT OR UPDATE?
    //[NSString stringWithFormat:@"INSERT INTO %@"];
    
    //TABLE TO Evaluate.
    
    
    //WHERE CLAUSE
    
    
    //relater.m
    return nil;
}


-(MMRelationshipSet *)buildManualRelationshipAddSQLOfRecords:(NSArray *)records toRelationship:(MMRelationship *)relationship record:(MMRecord *)record bindValues:(NSMutableArray **)bindValuesRef{

    
    NSMutableArray * __autoreleasing bindValues = [NSMutableArray array];
    
    
    MMSQLiteRelater * relatr= (MMSQLiteRelater *)relationship.storeRelater;

    NSAssert([relatr isKindOfClass:[MMSQLiteRelater class]], @"Class Missmatch for MMSQLiteRelater");

    
    NSString * tableToUpdate = [relatr tableToUpdateName] ;
    NSString * foreignColumnName = relatr.foreignKeyColumnName;
    
    NSString * query = nil;
    
    NSAssert([relatr isKindOfClass:[MMSQLiteRelater class]], @"");
    
    //INSERT OR UPDATE?
    
    if (relatr.intermediateTableName) {
        query = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@) VALUES ", tableToUpdate, relatr.recordIntermediateAttribute, relatr.relatedIntermediateAttribute] mutableCopy];
        
        NSMutableArray * valuesStrings = [NSMutableArray array];
        
        for (MMRecord * relatedRecord in records) {
            
            [valuesStrings addObject:@"(?,?)"];
            id firstValue = [[self class] rowidColumnValueForRecord:record];
            id secondValue = [[self class] rowidColumnValueForRecord:relatedRecord];
            
            NSAssert(firstValue, @"record %@ does not have primary key", record);
            NSAssert(secondValue, @"record %@ does not have primary key", relatedRecord);

            [bindValues addObject:firstValue];
            [bindValues addObject:secondValue];
            
        }
        
        NSString * valuesString = [valuesStrings componentsJoinedByString:@","];
        
        query = [query stringByAppendingString:valuesString];
        
    }
    else{
        
//        NSString * tableToUpdatePrimaryKeyColumnName = [relatr tableToUpdatePrimaryKeyColumnName];
//
//        query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ IN ", tableToUpdate, foreignColumnName, primaryKeyColumnName, nil];
//        
//        if (relatr.keyOptions == MMSQLiteForeignKeyOnTarget) {
//            
//        }
//        
//        
//        bindValues addObject:<#(nonnull id)#>

    }
    
    
    bindValuesRef = &bindValues;
    
    //INSERT OR UPDATE?

    
    
    //TABLE TO Evaluate.
    
    
    //WHERE CLAUSE
    
    return query;

}


-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error{

    BOOL __block success;
    
    NSLog(@"unable to update");
    
    
    if (relationship.autoRelate) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            NSString * query = [NSString stringWithFormat:@" INSERT OR REPLACE INTO `%@` (`%@`, `%@`) VALUES (:local, :foreign)",
                                relationship.autoRelateName,
                                [[self class] localAttributeNameForRelation:relationship],
                                [[self class] foreignAttributeNameForRelation:relationship]
                                ];
            
            MMDebug(query);
            
            for (MMRecord * recf in set) {
                
                
                MMDebug(@"(:local: %@, :foreign: %@)", [[self class] rowidColumnValueForRecord:record], [[self class] rowidColumnValueForRecord:recf]);
                
                
                success = [db executeUpdate:query withParameterDictionary:@{
                                                                            @"local":[[self class] rowidColumnValueForRecord:record],
                                                                            @"foreign":[[self class] rowidColumnValueForRecord:recf]
                                                                            }];
                if (!success) {
                    
                    NSLog(@"unable to update  %@", [db lastError]);
                    
                    *error = [db lastError];
                }
                
            }
            
        }];
    } else {
        
        if ([relationship.storeRelater isKindOfClass:[MMSQLiteRelater class]]) {
            if (((MMSQLiteRelater *)relationship.storeRelater).addToRelationship) {
                ((MMSQLiteRelater *)relationship.storeRelater).addToRelationship(self, relationship, record, set);
            }
        }
        
        
        
        NSLog(@"Add records %@ to relationship %@ on record %@", set, relationship, record);
        
    }

    
    return YES;

}


-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error{
    
    BOOL __block success;
    
    
    if (relationship.autoRelate) {

        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            NSString * query = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE `%@` = :local AND `%@` =  :foreign)",
                                relationship.autoRelateName,
                                [[self class] localAttributeNameForRelation:relationship],
                                [[self class] foreignAttributeNameForRelation:relationship]
                                ];
            
            for (MMRecord * recf in set) {
                
                 success = [db executeUpdate:query withParameterDictionary:@{
                                                                 @"local":[[self class] rowidColumnValueForRecord:record],
                                                                 @"foreign":[[self class] rowidColumnValueForRecord:recf]
                                                                 }];
                
                if (!success) {
                    *error = [db lastError];
                }
                
            }
            
        }];
    }
    else{
        
        
        
    }
    
    return success;
}




+(NSString *)localAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.localEntityName];
    
    //    if ([relationship onSelf]) {
    //        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
    //    }
    
    return name;
    
}


+(NSString *)foreignAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.relatedEntityName];
    
    
    //[self.attributes objectWithValue:name forKey:@"name"];
    
    //    if ([relationship onSelf]) {
    //        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
    //    }
    
    return name;
    
}


















#pragma Mark begin MMSQLiteRecord stuff


+(NSString *)tableNameForRecord:(MMRecord *)rec{
    
    return [[rec class] entityName];
    
}


+(NSObject *)rowidColumnValueForRecord:(MMRecord *)rec{
    
    NSString * name = [((MMSQLiteStore *)[[rec class] store]) rowidColumnNameForEntityName:[[rec class]entityName]];
    
    Ivar ivar = class_getInstanceVariable([rec class], "_values");
    return [((NSMutableDictionary *)object_getIvar(rec, ivar)) objectForKey:name];
    
}


+(NSString *)rowidColumnNameForRecord:(MMRecord *)rec{
    
//    NSArray * idKeys = [[rec class] idKeys];
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
    
    
    return [((MMSQLiteStore *)[[rec class] store]) rowidColumnNameForEntityName:[[rec class]entityName]];
    
}


+(NSString *)rowidColumnNameForEntity:(MMEntity *)entity{
    
    NSArray * idKeys = [entity idKeys];
    
    //return [self entityName];
    if([idKeys count] == 1){
        
        NSString * key = idKeys[0];
        
        MMAttribute * attr = [entity attributeWithName:key];
        if (!attr) {
            [NSException raise:@"MMInvalidDataException" format:@"Can't find key %@ for attribute in %@", key, NSStringFromSelector(_cmd)];
        }
        
        NSString * className = [[entity attributeWithName:key] classname];
        NSString * primativeName = [[entity attributeWithName:key] primativeType];
        
        MMDebug(@"name: %@ key: %@ primativeName:%@ classNAme: %@ ", entity.name, key, primativeName, className);
        
        if ([className isEqualToString:@"NSNumber"] || [primativeName isEqualToString:@"int"]) {
            return key;
        }
        
        
    }
    
    
    return @"ROWID";
}

-(NSString *)rowidColumnNameForEntityName:(NSString *)name{

    MMEntity * en = [self.schema entityForName:name];

    return [[self class] rowidColumnNameForEntity:en];

}


//+(NSArray *)primaryKeyNames{
//    
//    return @[@"id", @"time"];
//    
//}


//-(NSDictionary *)primaryKey{
//    
//    NSArray * names = [[self class]primaryKeyNames];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    for (NSString * name in names) {
//        [dict setObject:_values[name] forKey:name];
//    }
//    
//    return dict;
//}

+(NSString *)primaryKeyWhereClauseForRecord:(MMRecord *)rec{
    
    NSArray * params = [[rec class] idKeys];
    NSMutableArray * paramStringArray = [NSMutableArray array];
    
    if (params == nil || [params count] == 0) {
        return [NSString stringWithFormat:@" %@.rowid = :rowid", [[self class] tableNameForRecord:rec] ];
    }
    
    for (NSString * pName in params) {
        [paramStringArray addObject: [NSString stringWithFormat:@" %@.%@ = :%@", [[self class] tableNameForRecord:rec] , pName, pName ]];
    }
    
    return [paramStringArray componentsJoinedByString:@" AND "];
    
}

-(NSString *)queryWithRequest:(MMSQLiteRequest *)req countOnly:(BOOL)onlyCount{
    
    NSMutableString * query = [NSMutableString stringWithString:@""];
    
    NSString * sqlSelect = req.sqlSelect;
    NSString * sqlFrom = req.sqlFrom;
    NSString * sqlWhere = req.sqlWhere;
    NSString * sqlGroupBy = req.sqlGroupBy;
    NSString * sqlOrderBy = req.sqlOrderBy;
    NSString * sqlLimit = nil;

    //[self tableNameWithEntityName:req.entityName]
    
    if (!sqlSelect) {
        sqlSelect = [NSString stringWithFormat:@" %@.*", [self tableNameWithEntityName:req.entityName]];
    }
    if (onlyCount){
        
        sqlSelect = @"COUNT(*) AS count";
        
    }
    if (!sqlFrom) {
        sqlFrom = [NSString stringWithFormat:@"%@", [self tableNameWithEntityName:req.entityName]];
    }
    if (!sqlWhere) {
        
    }
    
    if (req.limit > 0) {
        sqlLimit = [NSString stringWithFormat:@"LIMIT %i", req.limit];
    }
    if (req.offset > 0) {
        sqlLimit = [NSString stringWithFormat:@"%@ OFFSET %i", sqlLimit, req.offset];
    }
    
    [query appendFormat:@"SELECT %@ FROM %@", sqlSelect, sqlFrom];
    
    if (sqlWhere) {
        [query appendFormat:@" WHERE %@", sqlWhere];
    }
    if (sqlGroupBy) {
        [query appendFormat:@" GROUP BY %@ ", sqlGroupBy];
    }
    if (sqlOrderBy) {
        [query appendFormat:@" ORDER BY %@ ", sqlOrderBy];
    }
    if (!onlyCount) {
        if (sqlLimit) {
            [query appendFormat:@"%@", sqlLimit];
        }
    }

    
    return [NSString stringWithString:query];
    
}

-(MMResultsSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error{
    
    //FMDatabase * db = [self db];
    
    MMResultsSet * __block set = MMAutorelease([[MMResultsSet alloc]init]);
    
    //[self.dbQueue inDatabase:^(FMDatabase * db){
        
    
    MMSQLiteRequest * request = (MMSQLiteRequest *)req;
    
    
        //[set addObjectsFromArray:[self loadRecordOfType:req.className withResultsOfQuery:[self queryWithRequest:req countOnly:false] withParameterDictionary:req.sqlBindValues]];
        
    set = [self loadRecordOfType:req.className withResultsOfQuery:[self queryWithRequest:request countOnly:false] withParameterDictionary:request.sqlBindValues error: error];
    
    set.offset = req.offset;
    
    [set setTotal:
        [self loadCountOfRequest:[self queryWithRequest:(MMSQLiteRequest *)request countOnly:true] withParameterDictionary:request.sqlBindValues error: error]
     ];
    
    //}];
    
    return set;
}


-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    BOOL __block success = NO;
        
    [self.dbQueue inDatabase:^(FMDatabase * db){

        success = [db executeUpdate:[[self class] buildUpdateQueryForRecord:rec values:values] withParameterDictionary:values];
    
        if ( ! success ) {
            [self generateDatabaseErrorWithDatabase:db error:error ];
        }
        
    }];
    
    return success;
    
}

-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    BOOL __block success = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase * db){
        
        success = [db executeUpdate:[[self class] buildInsertQueryForRecord:rec values:values] withParameterDictionary:values];

        if ([[values allKeys]count] == 0) {
            NSLog(@"issue");
        }
        
        [self refreshRecord:rec withValues:values forRowId:[db lastInsertRowId] database:db];
        
        if ( ! success ) {
            [self generateDatabaseErrorWithDatabase:db error:error ];
        }
        
    }];
    
    return success;
}

-(BOOL)refreshRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values forRowId:(long long)rowId database:(FMDatabase *)db{
    
    //FMDatabase * db = [self db];
    
    BOOL __block crap;
    
    [values removeAllObjects];
    
    NSString * rowIdKey = [[self class] rowidColumnNameForRecord:rec];
    
    //NSLog(@"REFRESHED VALUES %@", [NSString stringWithFormat:@"SELECT * FROM %@ WHERE `%@` = :%@", [[self class] tableNameForRecord:rec] , rowIdKey, rowIdKey]);
    
    FMResultSet * res = [db executeQuery:[NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE `%@` = :%@",
                                          [[self class] buildSelectColumnsClauseForRecord:rec values:values],
                                          [[self class] tableNameForRecord:rec],
                                          rowIdKey,
                                          rowIdKey]
                 withParameterDictionary:@{rowIdKey:[NSNumber numberWithLongLong:rowId]}];
    
    crap = [res next];
    
    NSDictionary * resultsDictionary = [res resultDictionary];
    
    [values addEntriesFromDictionary: [res resultDictionary]];
    
    [res close];
    
    
    
    NSLog(@"REFRESHED VALUES %@", resultsDictionary);
    
    return crap;
    
}

-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    BOOL __block success = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase * db){

        success = [db executeUpdate:[[self class] buildDeleteQueryForRecord:rec values:values] withParameterDictionary:[rec idValues]];
    
        if ( ! success ) {
            [self generateDatabaseErrorWithDatabase:db error:error ];
        }
        
    }];
    
    return success;
}


-(MMRequest *)newRequestForClassname:(NSString *)className{
    
    MMSQLiteRequest * req = [[MMSQLiteRequest alloc]initWithService:self classname:className];
    
    
    return req;
    
}

//-(BOOL)executeDelete:(NSError **)error{
//
//    [[[self class] database]executeUpdate:[self buildDeleteQuery] withParameterDictionary:[self idValues]];
//    return true;
//
//}


+(NSString *)buildInsertQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    NSString * query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",[[self class] tableNameForRecord:rec], [self buildList:[values allKeys]], [self buildParameterList:[values allKeys]] ];
    
    NSLog(@" insert %@", query);
    
    return  query ;
}


+(NSString *)buildSelectQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    return [NSString stringWithFormat:@"SELECT rowid, * FROM %@ WHERE %@",
                        [self buildSelectColumnsClauseForRecord:rec values:values],
                        [self tableNameForRecord:rec],
                        [self primaryKeyWhereClauseForRecord:rec]
            ];
    
}

+(NSString *)buildSelectColumnsClauseForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    MMEntity * entity = [[((MMRecord *)rec) class] entity];
    
    if (entity.idKeys == nil || [entity.idKeys count] == 0) {
        return @"*, ROWID";
    }
    
    return @"*";
    
}


+(NSString *)buildUpdateQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",[[self class] tableNameForRecord:rec], [self buildSetList:[values allKeys]], [self primaryKeyWhereClauseForRecord:rec]];
    
}

+(NSString *)buildDeleteQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    NSLog( @"deltesdfas %@", [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[[self class] tableNameForRecord:rec], [self primaryKeyWhereClauseForRecord:rec]]);
    
    
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[[self class] tableNameForRecord:rec], [self primaryKeyWhereClauseForRecord:rec]];
    
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
        if (![pName isEqualToString:@"rowid"]) {
            [paramStringArray addObject: [NSString stringWithFormat:@" %@ = :%@" , pName, pName ]];
        }
    }
    
    return [paramStringArray componentsJoinedByString:@","];
    
}


-(void)prepareForMigrationAttemptFromVersion:(MMVersionString *)versionString{
    
    NSString * oldPath = [self dbPathWithVersion:versionString];
    NSString * newPath = [self dbPathWithVersion:_schema.version];

    _db = nil;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    [fileManager copyItemAtPath:oldPath toPath:newPath error:nil];
    
}


#pragma Mark end MMSQLiteRecord stuff


-(void)generateDatabaseErrorWithDatabase:(FMDatabase *)db error:(NSError **)error{
    
    NSLog(@"DATABASE ERR::: %@", db.databasePath);
    NSLog(@"DATABASE CODE::: %i", [db lastErrorCode]);
    NSLog(@"DATABASE MSG::: %@", [db lastErrorMessage]);

    
    
    NSError * lastError = [db lastError];
    
    
    *error = lastError;
    
    //NSError * lastError = NSError errorWithDomain:@"com.kellyhuberty.MarshmallowOrmament" code: userInfo:<#(NSDictionary *)#>
    
    
    
}

@end

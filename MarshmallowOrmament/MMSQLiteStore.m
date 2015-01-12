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
    
    NSLog(@" db dir :%@", [NSString stringWithFormat:@"%@/%@__%@.db", dataDir, _schema.name, [_schema.version pathString]]);
    
    return [NSString stringWithFormat:@"%@/%@__%@.db", dataDir, _schema.name, [ver pathString]];
    
}


-(BOOL)build:(NSError **)error{
    
    //BOOL worked = [[self db] executeUpdate:[self buildSql] withErrorAndBindings:error];
    
    BOOL worked = [[self db] executeStatements:[self buildSchemaSql]];

    
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
    if ([ className isEqualToString:(@"NSNumber") ]) {
        if([primativeType isEqualToString:@"integer"] || [primativeType isEqualToString:@"int"]){
            return @"INTEGER";
        }
        if([primativeType isEqualToString:@"boolean"] || [primativeType isEqualToString:@"BOOL"]){
            return @"INTEGER (1)";
        }
        if([primativeType isEqualToString:@"float"] || [primativeType isEqualToString:@"double"] ){
            return @"REAL";
        }
    }
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

-(MMResultsSet *)loadRecordOfType:(NSString *)classname withResultsOfQuery:(NSString *)query withParameterDictionary:(NSDictionary *)dictionary error:(NSError **)error{
    
    NSMutableArray * __block ret;
    
    if (! NSClassFromString(classname)) {
        [NSException raise:@"MMInvalidClassnameException" format:@"The classname provided does not reference a valid class."];
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
            
            ret = [NSMutableArray array];
            
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
            
            *error = [db lastError];
            
        }
        
    }];
    
    return [MMResultsSet arrayWithArray:ret];
}



-(NSString *)tableNameWithEntityName:(NSString *)entityName{
    
    return [NSString stringWithFormat:@"`%@`", entityName];
    
}


+(NSString *)buildJoinSqlWithRelationship:(MMRelationship *)relationship{
    
    NSMutableString * clause = [NSMutableString stringWithString:@""];
    
    NSEnumerator * enu = [relationship.links objectEnumerator];
    
    MMRelation * rel = nil;
    
    while (rel = (MMRelation *)[enu nextObject]) {
    
        if (![clause isEqualToString:@""]) {
            
            [clause appendFormat:@"%@ JOIN %@ ON %@.%@ = %@.%@",
                rel.entityName,
                rel.referencingEntityName,
                rel.entityName,
                rel.key,
                rel.referencingEntityName,
                rel.referencingKey
             ];
        
        }else{
        
            [clause appendFormat:@" JOIN %@ ON %@.%@ = %@.%@",
                                rel.referencingEntityName,
                                rel.entityName,
                                rel.key,
                                rel.referencingEntityName,
                                rel.referencingKey
             ];
            
        }
    }
    
    return [NSString stringWithString:clause];
}


-(NSString *)buildJoinSqlWithAutoRelationship:(MMRelationship *)relationship{
    
    NSMutableString * clause = [NSMutableString stringWithString:@""];
    
    MMEntity * local = [self.schema entityForName:relationship.recordEntityName];
    MMEntity * foreign = [self.schema entityForName:relationship.entityName];
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
    
    if(relationship.autoRelate){
        
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
    
    request.className = relationship.className;
    
    request.sqlSelect = [NSString stringWithFormat:@"%@.*", relationship.entityName];
    
    request.sqlFrom = [NSString stringWithFormat:@"%@", [self buildJoinSqlWithAutoRelationship:relationship]];
    
    request.sqlWhere = [[self class]primaryKeyWhereClauseForRecord:record];
    
    [request.sqlBindValues addEntriesFromDictionary:[record idValues]];//[[self class]primaryKeyWhereClauseForRecord:record];

    
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
    
    MMSQLiteRequest * request = MMAutorelease([[MMRequest alloc] init]);
    
    request.className = relationship.className;
    
    request.sqlSelect = [NSString stringWithFormat:@"%@.*", relationship.entityName];
    
    request.sqlFrom = [NSString stringWithFormat:@"%@", [[self class] buildJoinSqlWithRelationship:relationship]];
    
    request.sqlWhere = [[self class]primaryKeyWhereClauseForRecord:record];
    
    set.request = request;
    
    set.record = record;
    
    [set fetch:nil];
    
    NSLog(@"SETT:%@", set);
    
    
    return set;
}

-(BOOL)addRecords:(NSArray *)set toRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error{

    BOOL __block success;
    
    NSLog(@"unable to update");
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {

        NSString * query = [NSString stringWithFormat:@" INSERT OR REPLACE INTO `%@` (`%@`, `%@`) VALUES (:local, :foreign)",
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
                
                NSLog(@"unable to update  %@", [[db lastError] localizedDescription]);
                
                *error = [db lastError];
            }
            
        }
        
    }];
    
    return YES;

}


-(BOOL)removeRecords:(NSArray *)set fromRelationship:(MMRelationship *)relationship onRecord:(MMRecord *)record error:(NSError **)error{
    
    BOOL __block success;
    
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
    
    return success;
}




+(NSString *)localAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.recordEntityName];
    
    //    if ([relationship onSelf]) {
    //        name = [NSString stringWithFormat:@"%@__%@", relationship.name, name];
    //    }
    
    return name;
    
}


+(NSString *)foreignAttributeNameForRelation:(MMRelationship *)relationship{
    
    NSString * name = [NSString stringWithFormat:@"%@__id", relationship.entityName];
    
    
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
        
        NSString * className = [[entity attributeWithName:key] classname];
        NSString * primativeName = [[entity attributeWithName:key] primativeType];
        
        MMError(@"primativeName:%@ classNAme: %@ ", className, primativeName);
        
        if ([className isEqualToString:@"NSNumber"] && [primativeName isEqualToString:@"int"]) {
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
    NSString * sqlLimit = nil;

    //[self tableNameWithEntityName:req.entityName]
    
    if (!sqlSelect) {
        sqlSelect = [NSString stringWithFormat:@" %@.*", [self tableNameWithEntityName:req.entityName]];
    }
    else if (onlyCount){
        
        sqlSelect = @"COUNT(*)";
        
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
    
    if (sqlLimit) {
        [query appendFormat:@" LIMIT %@", sqlLimit];
    }
    
    return [NSString stringWithString:query];
    
}

-(MMSet *)executeReadWithRequest:(MMRequest *)req error:(NSError **)error{
    
    //FMDatabase * db = [self db];
    
    MMResultsSet * __block set = MMAutorelease([[MMResultsSet alloc]init]);
    
    //[self.dbQueue inDatabase:^(FMDatabase * db){
        
        
        //[set addObjectsFromArray:[self loadRecordOfType:req.className withResultsOfQuery:[self queryWithRequest:req countOnly:false] withParameterDictionary:req.sqlBindValues]];
        
    set = [self loadRecordOfType:req.className withResultsOfQuery:[self queryWithRequest:req countOnly:false] withParameterDictionary:req.sqlBindValues];
    
    
    set.total = [self loadCountOfRequest:[self queryWithRequest:req countOnly:true]];
    
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
        
        [values addEntriesFromDictionary: [res resultDictionary]];
        
        [res close];
        
    
    
    NSLog(@"REFRESHED VALUES %@", values);
    
    return crap;
    
}

-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    BOOL __block success = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase * db){

        [db executeUpdate:[[self class] buildDeleteQueryForRecord:rec values:values] withParameterDictionary:[rec idValues]];
    
        if ( ! success ) {
            [self generateDatabaseErrorWithDatabase:db error:error ];
        }
        
    }];
    
    return success;
}


-(MMRequest *)newRequestForClassname:(NSString *)className{
    
    MMSQLiteRequest * req = [[MMSQLiteRequest alloc]initWithService:self classname:className];
    
    MMAutorelease(req);
    
    return req;
    
}

//-(BOOL)executeDelete:(NSError **)error{
//
//    [[[self class] database]executeUpdate:[self buildDeleteQuery] withParameterDictionary:[self idValues]];
//    return true;
//
//}


+(NSString *)buildInsertQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    NSLog(@" insert %@", [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",[[self class] tableNameForRecord:rec], [self buildList:[values allKeys]], [self buildParameterList:[values allKeys]] ]);
    
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",[[self class] tableNameForRecord:rec], [self buildList:[values allKeys]], [self buildParameterList:[values allKeys]] ];
    
}


+(NSString *)buildSelectQueryForRecord:(MMRecord *)rec values:(NSDictionary *)values{
    
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",
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

#pragma Mark end MMSQLiteRecord stuff


-(void)generateDatabaseErrorWithDatabase:(FMDatabase *)db error:(NSError **)error{
    
    
    
    
    
}

@end

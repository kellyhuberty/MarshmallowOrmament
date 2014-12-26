//
//  MMCouchbaseStore.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 12/26/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMCouchbaseStore.h"

@implementation MMCouchbaseStore

-(instancetype)initWithSchema:(MMSchema *)schema;
{
    self = [super initWithSchema:schema];
    if (self) {
        
        
        
    }
    return self;
}





-(BOOL)build:(NSError *__autoreleasing *)error{
    
    
        // create a name for the database and make sure the name is legal
        // NSString *dbname = @"my-new-database";
    
    NSString *dbname = self.schema.name;

    if (![CBLManager isValidDatabaseName: dbname]) {
        NSLog (@"Bad database name");
        return NO;
    }
    
        // create a new database
    _db = [self.manager databaseNamed: dbname error: error];
    if (!_db) {
        NSLog (@"Cannot create database. Error message: %@", [*error localizedDescription]);
        return NO;
    }
    
    
    return YES;
}


-(CBLDatabase *)db{
    
    NSString *dbname = self.schema.name;
    
    if (!_db) {
        _db = [self.manager databaseNamed: dbname error: nil];
        
    }

    return _db;
}



-(CBLManager *)manager{
    
    if (!_manager) {
        _manager = MMRetain([CBLManager sharedInstance]);
    }
    
    return _manager;
}

-(BOOL)executeUpdateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    
        // retrieve the document from the database
    CBLDocument * doc = [_db documentWithID: values[@"docID"]];
    
    CBLRevision * newRevision = [doc putProperties: values error: error];
    
    NSError * theError = *error;
    
    if (!newRevision) {
        MMError(@"Cannot write document to database. Error message: %@", theError.localizedDescription);
        return NO;
    }
        // display the retrieved document
        //NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    return YES;
}


-(BOOL)executeCreateOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    CBLDocument* doc = [_db createDocument];
    
    CBLRevision * newRevision = [doc putProperties: values error: error];
    
    NSError * theError = *error;
    
    if (!newRevision) {
        MMError(@"Cannot write document to database. Error message: %@", theError.localizedDescription);
        return NO;
    }
        // display the retrieved document
        //NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    values[@"docID"] = doc.documentID;
    
    return YES;
}

-(BOOL)executeDestroyOnRecord:(MMRecord *)rec withValues:(NSMutableDictionary *)values error:(NSError **)error{
    
    // retrieve the document from the database
    CBLDocument * doc = [_db documentWithID: values[@"docID"]];
    
    if (![doc deleteDocument:error]) {
        
        NSError * theError = *error;

        MMError(@"Cannot write document to database. Error message: %@", theError.localizedDescription);
        return NO;
    }
        // display the retrieved document
        //NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    return YES;
}


@end

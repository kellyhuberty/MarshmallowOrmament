//
//  MMRelationshipTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/6/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "MMOrmamentManager.h"
#import "MMSQLiteStore.h"
//#import "MMRecordTests.m"
#import "MMRecord.h"
#import "TSTNote.h"
#import "MMSQLiteRequest.h"

@interface MMRelationshipTests : XCTestCase

@end

@implementation MMRelationshipTests


- (void)setUp
{
    
    [self removeFiles];
    
    [MMService unsetVersionForSchemaName:@"noteit" type:@"cloud"];
    [MMService unsetVersionForSchemaName:@"noteit" type:@"store"];
    
    [MMOrmamentManager resetSharedManager];
    
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    
    
    
    [self removeFiles];
    
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)removeFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSArray * pathsToDelete = @[
                                [libraryPath stringByAppendingPathComponent:@"noteit__1_0_0.db"],
                                [libraryPath stringByAppendingPathComponent:@"noteit__0_1_0.db"],
                                [libraryPath stringByAppendingPathComponent:@"noteit__0_2_0.db"],
                                [libraryPath stringByAppendingPathComponent:@"noteit__0_3_0.db"]
                                ];
    
    for (NSString * filePath in pathsToDelete) {
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            //UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            //[removeSuccessFulAlert show];
        }
        else
        {
            NSLog(@"Could not delete file@: %@ -:%@ ",filePath ,[error localizedDescription]);
        }
        
    }
    
}

- (void)testGetHasManyNORelationshipResults
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);

    [[store db]executeUpdate:
     @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
     ];
    
    [[store db]executeUpdate:
        @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
     ];

    [[store db]executeUpdate:
        @"INSERT INTO NotesInNotebook (notebook__id , note__id) VALUES (2,0),(2,1),(2,2),(2,3)"
     ];
    
    
    MMSQLiteRequest * req = [TSTNote newStoreRequest];
    
    req.sqlWhere = @" id = 1 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    if (error) {
        MMLog(@"%@", [error description]);

    }
    //MMLog(@"%@", [error description])
    
    MMLog(@"SETCOUNT >>%i",[set count]);
    
    //XCTAssertNotNil((((TSTNote *)set)), @"Failed to fetch relationship");

    NSLog(@"notebook %@", NSStringFromClass([ set[0] class]) );
    
    NSLog(@"notebook %@", NSStringFromClass([(((TSTNote *)set[0]).notebook) class]) );

    TSTNotebook * nb = ((TSTNote *)set[0]).notebook;
    
    
    XCTAssertEqualObjects(NSStringFromClass([(((TSTNote *)set[0]).notebook) class]), @"TSTNotebook", @"Notebook class is wrong...");
    
    
    XCTAssertNotNil((((TSTNote *)set[0]).notebook), @"Failed to fetch relationship");
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}



- (void)testGetHasManyYESRelationshipResults
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);
    
    [[store db]executeUpdate:
     @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
     ];
    
    [[store db]executeUpdate:
     @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
     ];
    
    [[store db]executeUpdate:
     @"INSERT INTO NotesInNotebook (notebook__id , note__id) VALUES (2,0),(2,1),(2,2),(2,3)"
     ];
    
    
    MMSQLiteRequest * req = [TSTNotebook newStoreRequest];
    
    req.sqlWhere = @" id = 2 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    if (error) {
        MMLog(@"%@", [error description]);
        
    }
    //MMLog(@"%@", [error description])
    
    MMLog(@"SETCOUNT >>%i",[set count]);
    
    //XCTAssertNotNil((((TSTNote *)set)), @"Failed to fetch relationship");
    
    NSLog(@"notebook %@", NSStringFromClass([ set[0] class]) );
        
    TSTNotebook * nb = ((TSTNotebook *)set[0]);
    
    MMRelationshipSet * rset = nb.notes;
    
    
    //XCTAssertEqualObjects(NSStringFromClass([nb.notes class]), @"MMRelationshipSet", @"Notebook class is wrong...");
    
    
    //XCTAssertNotNil((nb.notes), @"Failed to fetch relationship");
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testGetBadRelationshipResults
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[@{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);
    
    [[store db]executeUpdate:
     @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
     ];
    
    [[store db]executeUpdate:
     @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
     ];
    
    [[store db]executeUpdate:
     @"INSERT INTO NotesInNotebook (notebook__id , note__id) VALUES (2,0),(2,1),(2,2),(2,3)"
     ];
    
    
    MMSQLiteRequest * req = [TSTNotebook newStoreRequest];
    
    req.sqlWhere = @" id = 2 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    if (error) {
        MMLog(@"%@", [error description]);
        
    }
    //MMLog(@"%@", [error description])
    
    MMLog(@"SETCOUNT >>%i",[set count]);
    
    //XCTAssertNotNil((((TSTNote *)set)), @"Failed to fetch relationship");
    
    NSLog(@"notebook %@", NSStringFromClass([ set[0] class]) );
    
    TSTNote * nb = ((TSTNote *)set[0]);
    
    TSTNotebook * notebook;
    
    XCTAssertThrows((notebook = [nb notebook]), @" Did throw exception for invalid key");
    
//    @try {
//        notebook = [nb notebook];
//    }
//    @catch (NSException * *exception) {
//        XCTAssertTrue(true, @"Passed test");
//        return;
//    }
//    @finally {
//        
//    }
    
    //XCTAssertEqualObjects(NSStringFromClass([nb.notes class]), @"MMRelationshipSet", @"Notebook class is wrong...");
    
    
    //XCTAssertNotNil((nb.notes), @"Failed to fetch relationship");
    
}





- (void)testAddItemToRelationshipHasManyNO
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);
    
    [[store db]executeUpdate:
     @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
     ];
    
    [[store db]executeUpdate:
     @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
     ];
    
    
    MMSQLiteRequest * req = [TSTNote newStoreRequest];
    
    req.sqlWhere = @" id = 1 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    if (error) {
        MMLog(@"%@", [error description]);
        
    }
    
    TSTNote * note = set[0];
    
    
    
    

    

    MMSQLiteRequest * nbReq = [TSTNotebook newStoreRequest];
    
    nbReq.sqlWhere = @" id = 1 ";
    
    NSError * nberror;
    
    MMSet * nbset = [nbReq executeOnStore:nil error:&nberror];
    if (nberror) {
        MMLog(@"%@", [error description]);
        
    }
    
    TSTNotebook * nb = nbset[0];
    
    
    
    note.notebook = nb;
    
    NSError * saveError;

    [note save:&saveError];
    
    
    
    //First let's make sure there was no errors....
//    if(saveError){
//        
//        XCTFail(@"error on save");
//
//    }
    
    
    
    FMResultSet * res = [[store db]executeQuery:@"SELECT * FROM NotesInNotebook"];
    
    NSDictionary * dict = nil;
    
    if ( [res next ] ) {
        
        dict = [res resultDictionary];
    
    }
    
    //[dict[@"notebook__id"] intValue] == 1
    
    if(dict){
    
        XCTAssertEqual([dict[@"notebook__id"] intValue], 1, @"notebook id not equivalent.");

        XCTAssertEqual([dict[@"note__id"] intValue], 1, @"note id not equivalent.");

    }else{
        
        XCTFail(@"No dict value for....");

    }
    // note.date = [NSDate date];
    
    //XCTAssertTrue(1 == 1, @"is true");
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testRemoveItemToRelationshipHasManyNO
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    
    
    
    
    
    // note.date = [NSDate date];
    
    //XCTAssertTrue(1 == 1, @"is true");
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


@end
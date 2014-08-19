//
//  MMRelationshipTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 8/6/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "MMOrmamentBootstrap.h"
#import "MMSQLiteStore.h"
//#import "MMRecordTests.m"
#import "MMRecord.h"
#import "TSTNote.h"
#import "MMRequest.h"

@interface MMRelationshipTests : XCTestCase

@end

@implementation MMRelationshipTests


- (void)setUp
{
    
    [self removeFiles];
    
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

- (void)testGetRelationshipResults
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentBootstrap startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMStore storeWithSchemaName:@"noteit" version:nil]);

    [[store db]executeUpdate:
     @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
     ];
    
    [[store db]executeUpdate:
        @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
     ];
    
    MMRequest * req = [TSTNote newRequest];
    
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
    
    XCTAssertEqualObjects(NSStringFromClass([(((TSTNote *)set[0]).notebook) class]), @"TSTNotebook", @"Notebook class is wrong...");
    
    
    XCTAssertNotNil((((TSTNote *)set[0]).notebook), @"Failed to fetch relationship");
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testAddItemToRelationship
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentBootstrap startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMStore storeWithSchemaName:@"noteit" version:nil]);
    // note.date = [NSDate date];
    
    //XCTAssertTrue(1 == 1, @"is true");
    
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testRemoveItemToRelationship
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentBootstrap startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMStore storeWithSchemaName:@"noteit" version:nil]);
    // note.date = [NSDate date];
    
    //XCTAssertTrue(1 == 1, @"is true");
    
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


@end
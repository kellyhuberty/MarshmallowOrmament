//
//  MMRequestTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/26/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTNote.h"
#import "MMSQLiteStore.h"
#import "MMOrmamentManager.h"
#import "MMSQLiteRequest.h"

@interface MMRequestTests : XCTestCase

@end

@implementation MMRequestTests

- (void)setUp
{
    
    [self removeFiles];

    [MMOrmamentManager unsetVersionForSchema:@"noteit"];
    
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

- (void)testBasicReadMAnualWhereClause
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);
    
    
    [[store dbQueue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
         @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
         ];
        
        
       [db executeUpdate:
         @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
         ];
        
    }];
    

    
    MMSQLiteRequest * req = [TSTNote newStoreRequest];
    
    req.sqlWhere = @" id = 1 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    
    if (error) {
        
        NSLog(@"ERROR %@", [error description]);
        
    }
    //MMLog(@"%@", [error description])
    
    NSLog(@"SETCOUNT >>%i",[set count]);
    
    XCTAssertNotNil(set, @"Failed to fetch");
    
    XCTAssertTrue([set count] > 0, @"Failed to fetch");


    
}


- (void)testBasicReadAllObjects
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    MMSQLiteStore * store = ((MMSQLiteStore *)[MMService storeWithSchemaName:@"noteit" version:nil]);
    
    
    [[store dbQueue] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
                             @"INSERT INTO notebook (id, title, description) VALUES (2, 'correct notebook', 'the right one'),(1, 'incorrect notebook', 'the wrong one')"
                             ];
        
        
        [db executeUpdate:
                              @"INSERT INTO note (notebookid ,created, text) VALUES (2,1,'note1'),(2,1, 'note2'),(2,1, 'note3'),(2,1, 'note4')"
                              ];
        
    }];
    
    
    
    MMRequest * req = [TSTNote newStoreRequest];
    
    //req.sqlWhere = @" id = 1 ";
    
    NSError * error;
    
    MMSet * set = [req executeOnStore:nil error:&error];
    if (error) {
        NSLog(@"ERROR %@", [error description]);
        
    }
    //MMLog(@"%@", [error description])
    
    NSLog(@"SETCOUNT >>%i",[set count]);
    
    XCTAssertNotNil(set, @"Failed to fetch");
    
    XCTAssertTrue([set count] == 4, @"Failed to fetch");
    
    
    
}


@end

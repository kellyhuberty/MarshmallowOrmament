//
//  MMManualRelationshipTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/18/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMOrmManager.h"
#import "MMSchema.h"
#import "TSANote.h"
#import "TSANotebook.h"
#import "TSTNote.h"
#import "TSTNotebook.h"
#import "MMSQLiteStore.h"

@interface MMManualRelationshipTests : XCTestCase

@end

@implementation MMManualRelationshipTests

- (void)setUp {
    [super setUp];
    
    MMSchema * schema = [[MMSchema alloc]initWithFilename:@"noteit_manual"];

    
    [MMOrmManager startWithSchemas:@[schema]];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testForeignKeyOnRecord_AddItem {
    
    TSTNote * note = [TSTNote create];
    note.text = @"note text";
    [note save];
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    note.notebook = notebook;
    [note save];
    [notebook save];
    
    
    XCTAssertEqual([notebook.notes count], 1);
    XCTAssertEqualObjects([notebook.notes objectAtIndex:0], note);
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
}

- (void)testForeignKeyOnRelationship_AddItem {
    
    TSTNote * note = [TSTNote create];
    note.text = @"note text";
    [note save];
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook.notes addObject:note];
    [note save];
    [notebook save];
    
    
    //[notebook.notes count] == 1
    XCTAssertEqual([notebook.notes count], 1);
    XCTAssertEqualObjects([notebook.notes objectAtIndex:0], note);

    
}

- (void)testForeignKeyOnRelationship_DeleteItem {

    TSTNote * note = [TSTNote create];
    note.text = @"note text";
    [note save];
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    note.notebook = notebook;
    [note save];
    [notebook save];
    
    
    //[notebook.notes count] == 1
    XCTAssertEqual([notebook.notes count], 1);
    XCTAssertEqualObjects([notebook.notes objectAtIndex:0], note);

    
    
    
}

- (void)testIntermediateTableKeyOnRelationship {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

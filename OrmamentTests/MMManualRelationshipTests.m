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
    
    [self removeFiles];
    
    MMSchema * schema = [[MMSchema alloc]initWithFilename:@"noteit_manual"];

    
    [MMService unsetVersionForSchemaName:@"noteit" type:@"store"];
    
    [MMOrmManager startWithSchemas:@[schema]];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)removeFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSArray * pathsToDelete = @[
                                [libraryPath stringByAppendingPathComponent:@"noteit__0_1.db"],
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


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testForeignKeyOnRecord_AddItem_PersistenceCheck {
    
    TSTNote * note = [TSTNote create];
    note.text = @"note text";
    [note save];
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook save];
    note.notebook = notebook;
    [note save];
    [notebook save];
    
    
    FMResultSet * resultSet = [((MMSQLiteStore *)[[note class] store]).db executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier = :PARAM" withParameterDictionary:@{@"PARAM":[NSNumber numberWithInt:note.identifier]} ];
    
    NSMutableArray * array = [NSMutableArray array];
    
    while ([resultSet next]) {
        
        NSDictionary * values = [resultSet resultDictionary];
        
        [array addObject:values]; 
        
    }
    
    
    
    XCTAssertEqual([array count], 1);
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
}

- (void)testForeignKeyOnRelationship_AddItem_PersistenceCheck {
    
    TSTNote * note1 = [TSTNote create];
    TSTNote * note2 = [TSTNote create];
    TSTNote * note3 = [TSTNote create];

    note1.text = @"note text 1";
    note2.text = @"note text 2";
    note3.text = @"note text 3";

    [note1 save];
    [note2 save];
    [note3 save];

    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook save];
    [notebook.notes addObject:note1];
    [notebook.notes addObject:note2];
    [notebook.notes addObject:note3];
    [notebook save];
    
//    
//    FMResultSet * resultSet = [((MMSQLiteStore *)[[note class] store]).db executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"  ];
//    
    FMDatabase * db = ((MMSQLiteStore *)[[note1 class] store]).db;
    
    FMResultSet * addResultSet = [db
            executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
    withArgumentsInArray:@[
                           [NSNumber numberWithInteger:note1.identifier],
                           [NSNumber numberWithInteger:note2.identifier],
                           [NSNumber numberWithInteger:note3.identifier]
                           ]
     ];
    
    NSMutableArray * addResultSetArray = [NSMutableArray array];
    
    while ([addResultSet next]) {
        
        NSDictionary * values = [addResultSet resultDictionary];
        
        [addResultSetArray addObject:values];
        
    }
    
    
    
    XCTAssertEqual([addResultSetArray count], 3);
    

    
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
}





- (void)testForeignKeyOnRelationship_DeleteItem_PersistenceCheck {
    
    TSTNote * note1 = [TSTNote create];
    TSTNote * note2 = [TSTNote create];
    TSTNote * note3 = [TSTNote create];
    
    note1.text = @"note text 1";
    note2.text = @"note text 2";
    note3.text = @"note text 3";
    
    [note1 save];
    [note2 save];
    [note3 save];
    
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook save];
    [notebook.notes addObject:note1];
    [notebook.notes addObject:note2];
    [notebook.notes addObject:note3];
    [notebook save];
    
    //
    //    FMResultSet * resultSet = [((MMSQLiteStore *)[[note class] store]).db executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"  ];
    //
    FMDatabase * db = ((MMSQLiteStore *)[[note1 class] store]).db;
    
    FMResultSet * addResultSet = [db
                                  executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
                                  withArgumentsInArray:@[
                                                         [NSNumber numberWithInteger:note1.identifier],
                                                         [NSNumber numberWithInteger:note2.identifier],
                                                         [NSNumber numberWithInteger:note3.identifier]
                                                         ]
                                  ];
    
    NSMutableArray * addResultSetArray = [NSMutableArray array];
    
    while ([addResultSet next]) {
        
        NSDictionary * values = [addResultSet resultDictionary];
        
        [addResultSetArray addObject:values];
        
    }
    
    
    
    XCTAssertEqual([addResultSetArray count], 3);
    
    
    
    
    
    [notebook.notes removeLastObject];
    
    [notebook save];
    
    
    
    FMResultSet * deleteResultSet = [db
                                     executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
                                     withArgumentsInArray:@[
                                                            [NSNumber numberWithInteger:note1.identifier],
                                                            [NSNumber numberWithInteger:note2.identifier],
                                                            [NSNumber numberWithInteger:note3.identifier]
                                                            ]
                                     ];
    
    NSMutableArray * deleteResultSetArray = [NSMutableArray array];
    
    while ([deleteResultSet next]) {
        
        NSDictionary * values = [deleteResultSet resultDictionary];
        
        [deleteResultSetArray addObject:values];
        
    }
    
    XCTAssertEqual([deleteResultSetArray count], 2);
    
    
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
}





- (void)testForeignKeyOnTarget_AddItem_PersistenceCheck {
    
    TSTNote * note1 = [TSTNote create];
    TSTNote * note2 = [TSTNote create];
    TSTNote * note3 = [TSTNote create];
    
    note1.text = @"note text 1";
    note2.text = @"note text 2";
    note3.text = @"note text 3";
    
    [note1 save];
    [note2 save];
    [note3 save];
    
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook save];
    note1.notebook = notebook;
    note2.notebook = notebook;
    note3.notebook = notebook;
    [note1 save];
    [note2 save];
    [note3 save];

    FMDatabase * db = ((MMSQLiteStore *)[[note1 class] store]).db;
    
    FMResultSet * addResultSet = [db
                                  executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
                                  withArgumentsInArray:@[
                                                         [NSNumber numberWithInteger:note1.identifier],
                                                         [NSNumber numberWithInteger:note2.identifier],
                                                         [NSNumber numberWithInteger:note3.identifier]
                                                         ]
                                  ];
    
    NSMutableArray * addResultSetArray = [NSMutableArray array];
    
    while ([addResultSet next]) {
        
        NSDictionary * values = [addResultSet resultDictionary];
        
        [addResultSetArray addObject:values];
        
    }
    
    
    
    XCTAssertEqual([addResultSetArray count], 3);
    
    
    
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
}





- (void)testForeignKeyOnTarget_DeleteItem_PersistenceCheck {
    
    TSTNote * note1 = [TSTNote create];
    TSTNote * note2 = [TSTNote create];
    TSTNote * note3 = [TSTNote create];
    
    note1.text = @"note text 1";
    note2.text = @"note text 2";
    note3.text = @"note text 3";
    
    [note1 save];
    [note2 save];
    [note3 save];
    
    TSTNotebook * notebook = [TSTNotebook create];
    notebook.title = @"notebook1";
    [notebook save];
    note1.notebook = notebook;
    note2.notebook = notebook;
    note3.notebook = notebook;
    [note1 save];
    [note2 save];
    [note3 save];

    FMDatabase * db = ((MMSQLiteStore *)[[note1 class] store]).db;
    
    FMResultSet * addResultSet = [db
                                  executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
                                  withArgumentsInArray:@[
                                                         [NSNumber numberWithInteger:note1.identifier],
                                                         [NSNumber numberWithInteger:note2.identifier],
                                                         [NSNumber numberWithInteger:note3.identifier]
                                                         ]
                                  ];
    
    NSMutableArray * addResultSetArray = [NSMutableArray array];
    
    while ([addResultSet next]) {
        
        NSDictionary * values = [addResultSet resultDictionary];
        
        [addResultSetArray addObject:values];
        
    }
    
    
    
    XCTAssertEqual([addResultSetArray count], 3);
    
    
    
    
    
    note3.notebook = nil;
    
    [note3 save];
    
    
    
    FMResultSet * deleteResultSet = [db
                                     executeQuery:@"SELECT notebook.* FROM note join notebook ON (notebook.identifier = note.notebookId) WHERE note.identifier IN (?, ?, ?)"
                                     withArgumentsInArray:@[
                                                            [NSNumber numberWithInteger:note1.identifier],
                                                            [NSNumber numberWithInteger:note2.identifier],
                                                            [NSNumber numberWithInteger:note3.identifier]
                                                            ]
                                     ];
    
    NSMutableArray * deleteResultSetArray = [NSMutableArray array];
    
    while ([deleteResultSet next]) {
        
        NSDictionary * values = [deleteResultSet resultDictionary];
        
        [deleteResultSetArray addObject:values];
        
    }
    
    XCTAssertEqual([deleteResultSetArray count], 2);
    
    
    //[(MMSQLiteStore *)[TSTNote store] db]executeQuery:@"SELECT * FROM note WHERE"
    
    
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

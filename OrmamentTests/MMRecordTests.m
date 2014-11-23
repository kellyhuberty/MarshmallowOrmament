//
//  MMRecordTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/8/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTNote.h"
#import "MMSQLiteStore.h"
#import "MMOrmamentManager.h"
@interface MMRecordTests : XCTestCase

@end

@implementation MMRecordTests

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


- (void)archiveDatabaseFileForTest:(NSString *)suffix
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * filepath = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"noteit__0_1_0__%@_dump.db", suffix ]];
    NSString * filepathsrc = [libraryPath stringByAppendingPathComponent:@"noteit__0_1_0.db"];

    
    
//    NSArray * pathsToDelete = @[
//                                [libraryPath stringByAppendingPathComponent:@"noteit__1_0_0.db"],
//                                [libraryPath stringByAppendingPathComponent:@"noteit__0_1_0.db"],
//                                [libraryPath stringByAppendingPathComponent:@"noteit__0_2_0.db"],
//                                [libraryPath stringByAppendingPathComponent:@"noteit__0_3_0.db"]
//                                ];
    
    
        NSError *error;
        NSError *error2;

        BOOL successrm = [fileManager removeItemAtPath:filepath error:&error];
        BOOL successmv = [fileManager copyItemAtPath:filepathsrc toPath:filepath error:&error2];
    
    if(!successrm){
        NSLog(@"archiveError %@", [error localizedDescription]);
    }
    if(!successmv){
        NSLog(@"archiveError %@", [error2 localizedDescription]);

    }
    
}



- (void)testSettingBasicObjectValue
{
    
    MMSetArcEnabled();

    
    [MMOrmamentManager startWithSchemas:@[     @{
                                               @"name":@"noteit",@"version":@"0.1.0"
                                               }]];
    
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
   // note.date = [NSDate date];
    
    XCTAssertTrue([note.text isEqualToString:@"blah"], @"is true");
    
    NSLog(@"record value %@", note.text);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testCreateAndFill
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    TSTNote * note = [TSTNote create:@{@"text":@"blah"}];
    
    //note.text = @"blah";
    // note.date = [NSDate date];
    
    XCTAssertTrue([note.text isEqualToString:@"blah"], @"is true");
    
    //NSLog(@"record value %@", note.text);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testSavingBasicObjectValue
{
    
    MMSetArcEnabled();

    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error;
    
    [note save:&error];
    //exit(1);
    //XCTAssertTrue([note save:&error], @"Saving");

    
    

    
    
    
    TSTNote * note2 = [TSTNote create];
    
    note2.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error2;
    
    [note2 save:&error2];
    
    
    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];

    
    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note`"];
    
    [set next];
    //[set intForColumnIndex:0];
    NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    XCTAssertTrue(([set intForColumn:@"cnt"] == 2), @"Saving");

    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


//- (void)testSettingBasicObjectValue
//{
//    
//    MMSetArcEnabled();
//    
//    
//    [MMOrmamentBootstrap startWithSchemas:@[     @{
//                                                     @"name":@"noteit",@"version":@"0.1.0"
//                                                     }]];
//    
//    
//    TSTNote * note = [TSTNote create];
//    
//    note.text = @"blah";
//    // note.date = [NSDate date];
//    
//    XCTAssertTrue([note.text isEqualToString:@"blah"], @"is true");
//    
//    NSLog(@"record value %@", note.text);
//    
//    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}
//




- (void)testUpdate
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    //[note logValues];
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    [note logValues];

    
    NSError * error = nil;
    
    [note save:&error];
    //exit(1);
    //XCTAssertTrue([note save:&error], @"Saving");
    
    [note logValues];

    
    TSTNote * note2 = [TSTNote create];
    
    note2.text = @"blah";
    // note.date = [NSDate date];
    
    [note logValues];

    
    NSError * error2 = nil;
    
    NSError * error3 = nil;
    [note logValues];

    
    [note2 save:&error2];
    
    [note logValues];

    
    note.text = @"meh";
    
    [note save:&error3];
    
    [note logValues];

    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];
    
    
    [note logValues];

    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note` WHERE `text` LIKE \"meh\""];
    
    [set next];
    //[set intForColumnIndex:0];
    NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    XCTAssertTrue(([set intForColumn:@"cnt"] == 1), @"Saving");
    
    [self archiveDatabaseFileForTest:@"testUpdate"];
    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testUpdatePrimativeValue
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    //[note logValues];
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    [note logValues];
    
    
    NSError * error = nil;
    
    [note save:&error];
    //exit(1);
    //XCTAssertTrue([note save:&error], @"Saving");
    
    [note logValues];
    
    
    TSTNote * note2 = [TSTNote create];
    
    note2.text = @"blah";
    // note.date = [NSDate date];
    
    [note logValues];
    
    
    NSError * error2 = nil;
    
    NSError * error3 = nil;
    [note logValues];
    
    
    [note2 save:&error2];
    
    [note logValues];
    
    
    note.text = @"meh";
    
    [note save:&error3];
    
    note.latitude = 132.5;
    note.longitude = 74.75;
    
    
    [note logValues];
    
    XCTAssertTrue((note.latitude == 132.5), @"Same primative value returned");
    XCTAssertTrue((note.longitude == 74.75), @"Same primative value returned");

    
    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];
    
    
    [note logValues];
    
    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note` WHERE `text` LIKE \"meh\""];
    
    [set next];
    //[set intForColumnIndex:0];
    NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    XCTAssertTrue(([set intForColumn:@"cnt"] == 1), @"Saving");
    
    [self archiveDatabaseFileForTest:@"testUpdate"];
    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testUpdateCount
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error;
    
    [note save:&error];
    //exit(1);
    //XCTAssertTrue([note save:&error], @"Saving");
    
    
    
    TSTNote * note2 = [TSTNote create];
    
    note2.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error2;
    
    [note2 save:&error2];
    
    NSError * error3;

    
    note.text = @"meh";
    
    [note save:&error3];
    
    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];
    
    
    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note` WHERE `text` LIKE \"meh\""];
    
    [set next];
    //[set intForColumnIndex:0];
    NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    XCTAssertTrue(([set intForColumn:@"cnt"] == 1), @"Saving");
    
    [self archiveDatabaseFileForTest:@"testUpdateCount"];

    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}




- (void)testUpdatePercision
{
    
    MMSetArcEnabled();
    
    
    [MMOrmamentManager startWithSchemas:@[     @{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error;
    
    [note save:&error];
    //exit(1);
    //XCTAssertTrue([note save:&error], @"Saving");
    
    
    
    TSTNote * note2 = [TSTNote create];
    
    note2.text = @"blah";
    // note.date = [NSDate date];
    
    
    
    NSError * error2;
    
    [note2 save:&error2];
    
    
    
    note.text = @"meh";
    
    [note save:&error];
    
    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];
    
    
    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note` WHERE `text` LIKE \"meh\""];
    
    [set next];
    //[set intForColumnIndex:0];
    //NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    
    
    
    XCTAssertTrue( ([set intForColumn:@"cnt"] == 1) , @"Saving");
    
    [set close];
    
    [self archiveDatabaseFileForTest:@"testUpdatePercision"];

    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    
}








- (void)testDelete
{
    
    MMSetArcEnabled();
    
    [MMOrmamentManager startWithSchemas:@[@{
                                                     @"name":@"noteit",@"version":@"0.1.0"
                                                     }]];
    
    TSTNote * note = [TSTNote create];
    
    note.text = @"blah";
    // note.date = [NSDate date];
    
    NSError * error;
    
    [note save:&error];
    
    NSError * error2;
    
    if (![note destroy:&error2]) {
        NSLog(@" testDelete error %@ ", error2);
    };
    

    
    
    FMDatabase * db = [((MMSQLiteStore *)[[note class] store]) db];
    
    
    FMResultSet * set = [db executeQuery:@"SELECT COUNT(*) as cnt FROM `note`"];
    
    [set next];
    //[set intForColumnIndex:0];
    NSLog(@"SELECT text FROM note %i", [set intForColumn:@"cnt"] );
    
    XCTAssertTrue(([set intForColumn:@"cnt"] == 0), @"Saving");
    
    [set close];

    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}



- (void)testBasicRead
{
    
    MMSetArcEnabled();
    
    [MMOrmamentManager startWithSchemas:@[@{
                                                @"name":@"noteit",@"version":@"0.1.0"
                                                }]];
    
    NSMutableArray * notes = [NSMutableArray array];
    
    NSError * error;
    
    notes[0] = [TSTNote create];
    ((TSTNote *)notes[0]).text = @"hey dude";
    [(TSTNote *)notes[0] save:&error];
    notes[1] = [TSTNote create];
    ((TSTNote *)notes[1]).text = @"hello dude";
    [(TSTNote *)notes[1] save:&error];
    notes[2] = [TSTNote create];
    ((TSTNote *)notes[2]).text = @"meh dupe";
    [(TSTNote *)notes[2] save:&error];

    [self archiveDatabaseFileForTest:@"testBasicRead"];

    MMSQLiteStore * str = [MMService storeWithSchemaName:@"noteit" version:nil];
    
    if (!str) {
        XCTFail(@"No Store availible...");
    }
    
    
    NSArray * array = [str loadRecordOfType:@"TSTNote" withResultsOfQuery:@"SELECT * FROM note WHERE text LIKE \"%dude\"" withParameterDictionary:nil];
    
    NSLog(@"testBasicRead %@" ,array);
    
    
    XCTAssertTrue(([array count] == 2), @"Saving");

    [self archiveDatabaseFileForTest:@"testBasicRead"];


    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}



- (void)testActiveRecordRead
{
    
    MMSetArcEnabled();
    
    [MMOrmamentManager startWithSchemas:@[@{
                                              @"name":@"noteit",@"version":@"0.1.0"
                                              }]];
    
    NSMutableArray * notes = [NSMutableArray array];
    
    NSError * error;
    
    notes[0] = [TSTNote create];
    ((TSTNote *)notes[0]).text = @"hey dude";
    [(TSTNote *)notes[0] save:&error];
    notes[1] = [TSTNote create];
    ((TSTNote *)notes[1]).text = @"hello dude";
    [(TSTNote *)notes[1] save:&error];
    notes[2] = [TSTNote create];
    ((TSTNote *)notes[2]).text = @"meh dupe";
    [(TSTNote *)notes[2] save:&error];
    
    [self archiveDatabaseFileForTest:@"testBasicRead"];
    
    MMSQLiteStore * str = [MMService storeWithSchemaName:@"noteit" version:nil];
    
    if (!str) {
        XCTFail(@"No Store availible...");
    }
    
    
    NSArray * array1 = [str loadRecordOfType:@"TSTNote" withResultsOfQuery:@"SELECT * FROM note WHERE text LIKE \"hey dude\"" withParameterDictionary:nil];
    
    //NSLog(@"testBasicRead %@" ,array);
    
    
    NSArray * array2 = [str loadRecordOfType:@"TSTNote" withResultsOfQuery:@"SELECT * FROM note WHERE text LIKE \"hey dude\"" withParameterDictionary:nil];

    NSLog(@" obj1:%i, obj2:%i",array1[0],array2[0]);
    XCTAssertEqual(array1[0], array2[0]);
    
    
    //XCTAssertTrue(([array count] == 2), @"Saving");
    
    //[self archiveDatabaseFileForTest:@"testBasicRead"];
    
    
    //exit(1);
    
    // NSLog(@"record value %@", note.text);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}















@end

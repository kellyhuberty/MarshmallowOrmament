//
//  MMSchemaTests.m
//  
//
//  Created by Kelly Huberty on 4/5/14.
//
//

#import <XCTest/XCTest.h>
#import "MMSchema.h"
#import "MMSQLiteSchema.h"
#import "MMSQLiteStore.h"

//#import <FMDB/FMDB.h>



@interface MMSchemaTests : XCTestCase{
    
    
    MMSchema * _schema;
  //  FMDatabase * _db;
//    MMService * _service;

    
    
}

@end

@implementation MMSchemaTests

- (void)setUp
{
    [self removeFiles];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    //[self removeFiles];
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





- (void)testBuildFileValid
{
    
    
    MMSetArcEnabled();
    
    MMSchema * schema;
    
    //NSArray * path = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"noteit__0_1_0" ofType:@"plist"];
    
    NSLog(@"path %@", path);
    
    NSArray * paths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSLog(@"%@", paths);

    
    schema = [[MMSchema alloc]initWithFilePath:path];
    [MMLogger setEnabled];
    
    
    [schema log];
    
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testBuildFileInvalid
{
    
    MMSetArcEnabled();

    MMSchema * schema;
    
    //NSArray * path = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"randomname_1" ofType:@"plist"];
    
    NSLog(@"path %@", path);
    
    NSArray * paths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSLog(@"%@", paths);
    
    
    XCTAssertThrows(( schema = [[MMSchema alloc]initWithFilePath:path]));
    
    //schema = [[MMSchema alloc]initWithFilePath:path];
    //[MMDebug setEnabled];
    
    
    [schema log];
    
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testBuildSql
{
    MMSetArcEnabled();

    
    MMSQLiteSchema * schema;
    
    //NSArray * path = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"noteit__0_1_0" ofType:@"plist"];
    
    NSLog(@"path %@", path);
    
    NSArray * paths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSLog(@"%@", paths);
    
    
    schema = [[MMSQLiteSchema alloc]initWithFilePath:path];
    [MMLogger setEnabled];
    
    NSLog(@"build sql :%@", [schema buildSql]);
    
    //[schema log];
    
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testBuildStore
{
    MMSetArcEnabled();
    
    
    MMSQLiteSchema * schema;
    
    //NSArray * path = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    NSString * path = [[NSBundle bundleForClass:[self class]] pathForResource:@"noteit__0_1_0" ofType:@"plist"];
    
    NSLog(@"path %@", path);
    
    //NSArray * paths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    //NSLog(@"%@", paths);
    
    
    schema = [[MMSQLiteSchema alloc]initWithFilePath:path];
    
    MMStore * store = [[MMSQLiteStore alloc]initWithSchema:schema ];
    
    NSError * error;
    
    XCTAssertTrue([store build:&error], @"sql buildt");
    
    [MMLogger setEnabled];
    
    NSLog(@"build sql :%@", [error localizedDescription]);
    
    //[schema log];
    
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}




//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end

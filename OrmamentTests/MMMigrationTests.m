//
//  MMMigrationTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 10/9/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMSqliteSchemaMigration.h"
#import "MMOrmamentManager.h"
#import "MMLogger.h"
@interface MMMigrationTests : XCTestCase

@end

@implementation MMMigrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


- (void)testSchemaMigration {
    // This is an example of a functional test case.
    
    
    //[MMOrmamentBootstrap schemaDictionaryWithName:@"noteit" version:new];

    MMDebug(@"helloasdaf");
    
    MMVersionString * old = [MMVersionString stringWithString:@"0.1.0"];
    MMVersionString * new = [MMVersionString stringWithString:@"0.2.0"];

    
    MMService * oldStore = [MMService storeWithSchemaName:@"noteit" version:[MMVersionString stringWithString:@"0.1.0"]];
    MMService * newStore = [MMService storeWithSchemaName:@"noteit" version:[MMVersionString stringWithString:@"0.2.0"]];

    
    //[MMStore storeWithSchemaName:@"noteit" version:[MMVersionString stringWithString:@"0.0.1"]];
    
    
    NSDictionary * dict =[MMOrmamentManager schemaDictionaryWithName:@"noteit" version:new];

    
    MMSqliteSchemaMigration * migration = [MMSqliteSchemaMigration migrationWithDictionary:dict[@"migrations"]];
    
    //migration
    
    NSError * error = nil;
    
    [migration upgradeStore:oldStore toStore:newStore error:&error];
    
    XCTAssertNil((error), @"Pass");

    //XCTAssertTrue((error == nil));

    
    
}

- (void)testSingleEntityMigration {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  MMManualMigrationTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/18/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMSchema.h"
#import "MMOrmManager.h"

@interface MMManualMigrationTests : XCTestCase{
    
    MMSchema* _schema;
}

@end

@implementation MMManualMigrationTests

- (void)setUp {
    [super setUp];

    _schema = [[MMSchema alloc]initWithFilename:@"noteit_manual"];

    [MMOrmManager startWithSchemas:@[_schema]];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
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

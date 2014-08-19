//
//  MarshmallowOrmamentTests.m
//  MarshmallowOrmamentTests
//
//  Created by Kelly Huberty on 7/2/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMSQLiteRecord.h"
@interface MarshmallowOrmamentTests : XCTestCase{
    
    MMSQLiteRecord * _record;
    
    
    
}

@end

@implementation MarshmallowOrmamentTests

- (void)setUp
{
    [super setUp];
    
    _record  = [[MMSQLiteRecord alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    NSLog(@"%@", [_record buildInsertQuery]);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testExample2
{
    
    NSLog(@"%@", [_record buildUpdateQuery]);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end

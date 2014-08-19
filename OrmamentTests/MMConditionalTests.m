//
//  MMConditionalTests.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/29/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MMConditional.h"
@interface MMConditionalTests : XCTestCase

@end

@implementation MMConditionalTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testPregSplit
{
 
    [MMConditional processConditionalFormatString:@"asdfasdfasdf" withArguements:nil];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


@end

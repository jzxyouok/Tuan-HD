//
//  __HD_KKTests.m
//  团购HD-KKTests
//
//  Created by Kenny.li on 16/4/9.
//  Copyright (c) 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HMCity.h"
#import "HMMetaDataTool.h"

@interface __HD_KKTests : XCTestCase

@end

@implementation __HD_KKTests

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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDeme {
   
    XCTAssert([HMMetaDataTool sharedMetaDataTool].sorts > 0, @"Pass");
    
}




@end

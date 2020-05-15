//
//  MyClassTests.swift
//  MyTestTarget
//
//  Created by Rossi Riccardo on 07/05/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import XCTest
@testable import ModelsFramework

class MyClassTests: XCTestCase {

    override func setUp() {
        // Put setup code here.
        // This method is called before the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let card = Card(number: "123456789", issuer: .americanExpress)
        XCTAssertEqual(card.number, "123456789")
    }

    override func tearDown() {
        // Put teardown code here.
        // This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

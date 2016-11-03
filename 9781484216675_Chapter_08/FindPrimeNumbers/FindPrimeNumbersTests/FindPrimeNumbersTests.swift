//
//  FindPrimeNumbersTests.swift
//  FindPrimeNumbersTests
//
//  Created by Radoslava Leseva on 02/07/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

@testable import FindPrimeNumbers
import XCTest

class FindPrimeNumbersTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController =
            storyboard.instantiateInitialViewController() as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsItPrime_0() {
        let result = viewController.isItPrime(number: 0)
        XCTAssertFalse(result)
    }
    
    func testPerformanceFindPrimeNumbersInRange() {
        self.measureBlock {
            self.viewController.findPrimeNumbersInRange(range: 0...1000)
        }
    }
}

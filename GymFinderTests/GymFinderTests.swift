//
//  GymFinderTests.swift
//  GymFinderTests
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import XCTest
@testable import GymFinder

class GymFinderTests: XCTestCase {
    
    var gyms = [Gym]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testFetchingGymsNearBy()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test case to test Complete fetching and parsing json
    func testFetchingGymsNearBy() {
        // given
        var request = URLRequest(url: URL(string: APPURL.base_url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = "{\n  \"latitude\": -95390850,\n  \"longitude\": 51974566\n}".data(using: .utf8)
        
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    if let data = data {
                        let json = try! JSONSerialization.jsonObject(with: data, options: [])
                        let dictionary = json as! [[String:Any]]
                        self.gyms = dictionary.flatMap { dictionary in return Gym(dictionary : dictionary) }
                        
                        promise.fulfill()
                    }
                    else {
                        XCTFail("Status code: \(statusCode)")
                    }
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        
        dataTask.resume()
        
        // 3
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    //These 2 tests will fail as requested if I understood correctly.
    func testGymFailCase() {
        let gym: Gym = gymFailUseCase()
        XCTAssertGreaterThan(gym.name.count, 0)
        XCTAssertGreaterThan(gym.address.count, 0)
    }
    
    //These 2 tests will pass and validate the first gym record
    func testGymPassCase() {
        let gym: Gym = gymPassUseCase()
        
        XCTAssertGreaterThan(gym.name.count, 0)
        XCTAssertGreaterThan(gym.address.count, 0)
        
        XCTAssertEqual(gym.name, "Fitness First Bond St Platinum, The Rocks")
        XCTAssertEqual(gym.address, "20 Bond Street, The Rocks")
    }
    
    //Override the first gym record
    func gymFailUseCase () -> Gym {
        let gym: Gym = self.gyms.first!
        gym.name = ""
        gym.address = ""
        return gym
    }
    
    //return the first record
    func gymPassUseCase () -> Gym {
        return self.gyms.first!
    }
}

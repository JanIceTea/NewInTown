//
//  FirstSceneWorkerTest.swift
//  NewInTownTests
//
//  Created by Jan Trutzschler on 10/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import Foundation
import XCTest
@testable import NewInTown

class FirstSceneWorkerTest: XCTestCase {
    
    let worker = FirstSceneWorker()
    
    func testGetDialog() {
        let id = "B3045_1"
        let dialog = worker.getDialog(forStoryLineId: "B3045_1", atIndex: 0)
        XCTAssertNotNil(dialog, "could not get dialog with id \(id)")
    }
}

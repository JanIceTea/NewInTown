//
//  FirstSceneInteractorTest.swift
//  NewInTownTests
//
//  Created by Jan Trutzschler on 11/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import Foundation
import XCTest
@testable import NewInTown

class FirstScenePresenterMock: FirstScenePresentationLogic {
    
    var response: FirstScene.FetchFirstScene.Response?
    
    func updateFirstScene(response: FirstScene.FetchFirstScene.Response) {
        self.response = response
    }
}

class FirstSceneInteractorTest: XCTestCase {
    
    func testValidation() {
        var interactor = FirstSceneInteractor()
        let presenter = FirstScenePresenterMock()
        interactor.presenter = presenter
        
        interactor.fetchStoryLine(withId: "B3045_1")
        interactor.validate(answer: "fu2wu4yuan2")
        guard let response = presenter.response else {
            XCTAssert(false)
            return
        }
        
        XCTAssert(interactor.currentStoryLineId == "B3045_2")
        XCTAssert(interactor.nextWaitTime == 240)
        XCTAssert(response.score == 10)
        XCTAssert(response.nextIndex == 0)
        XCTAssert(response.hasCorrectAnswer)
        XCTAssert(response.isBlockedForNext)
        XCTAssert(response.timeToWaitString == "240.0")
        
        interactor = FirstSceneInteractor()
        interactor.presenter = presenter
        interactor.restoreFromGameState()
        XCTAssert(response.score == 10)
        XCTAssert(response.nextIndex == 0)
        XCTAssert(response.hasCorrectAnswer)
        XCTAssert(response.isBlockedForNext)
        XCTAssert(response.timeToWaitString == "240.0")

        let storedDate = StateKeeper.shared.gameState.date
        let interval: TimeInterval = 120
        let date = Date(timeInterval: interval, since: storedDate)
        let remaining = StateKeeper.shared.timeToWaitForNextSoryLine(for: date)
        XCTAssert(remaining == 120)

    }
    
}

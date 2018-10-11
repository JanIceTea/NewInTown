//
//  FirstSceneInteractor.swift
//  NewInTown
//
//  Created by Jan T on 09/10/2018.
//  Copyright (c) 2018 teatracks. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FirstSceneBusinessLogic {
    func validate(answer: String)
    func fetchStoryLine(withId id: String)
    func restoreFromGameState()
}

protocol FirstSceneDataStore {
    var currentScore: Int {get set}
}

class FirstSceneInteractor: FirstSceneBusinessLogic, FirstSceneDataStore {
    
    var presenter: FirstScenePresentationLogic?
    var currentScore: Int = 0
    var currentStoryLineId: String = "B3045_1"
    var currentDialogIndex: Int = 0
    var nextWaitTime: TimeInterval = 0.0
    
    let worker = FirstSceneWorker()
    
    func fetchStoryLine(withId id: String) {
        var response = FirstScene.FetchFirstScene.Response()
        currentStoryLineId = id
        response.storyLineId = currentStoryLineId
        response.score = currentScore
        response.nextIndex = currentDialogIndex
        presenter?.updateFirstScene(response: response)
    }
    
    // MARK: Perform operation on FirstScene

    func validate(answer: String) {
        var response = FirstScene.FetchFirstScene.Response()
        guard let dialog = worker.getDialog(forStoryLineId: currentStoryLineId, atIndex: currentDialogIndex) else {
            return
        }
        response.hasCorrectAnswer = (answer == dialog.answer.pinyin) || (answer == dialog.answer.chinese)
        if response.hasCorrectAnswer {
            currentScore = currentScore + dialog.points
            currentDialogIndex = currentDialogIndex + 1
        } else {
            currentScore = currentScore - 5
        }
        
        let nextStoryLineId = worker.getNextStoryLineId(forStoryLineId: currentStoryLineId, atIndex: currentDialogIndex)
        nextWaitTime = 0
        if nextStoryLineId != currentStoryLineId {
            if let storyLine = worker.getStoryLine(forId: nextStoryLineId) {
                nextWaitTime = TimeInterval(storyLine.time)
                response.timeToWaitString = String(nextWaitTime)
                response.isBlockedForNext = nextWaitTime > 0
            }
            currentDialogIndex = 0
        }
        currentStoryLineId = nextStoryLineId
        
        response.score = currentScore
        response.nextIndex = currentDialogIndex
        response.storyLineId = currentStoryLineId
        
        presenter?.updateFirstScene(response: response)
        updateGameData()
        
        if(response.isBlockedForNext) {
            runCountdownQueue()
        }
    }
    
    private func updateGameData() {
        StateKeeper.shared.setGameState(points: currentScore, storyLineId: currentStoryLineId, dialogIndex: currentDialogIndex, timeToWait: nextWaitTime )
    }
    
    func restoreFromGameState() {
        currentStoryLineId = StateKeeper.shared.gameState.currentStoryLineId
        currentScore = StateKeeper.shared.gameState.points
        currentDialogIndex = StateKeeper.shared.gameState.currentDialogIndex
        nextWaitTime = StateKeeper.shared.timeToWaitForNextSoryLine
        
        var response = FirstScene.FetchFirstScene.Response()
        response.storyLineId = currentStoryLineId
        response.score = currentScore
        response.nextIndex = currentDialogIndex
        response.timeToWaitString = String(nextWaitTime)
        response.isBlockedForNext = nextWaitTime > 0
        
        presenter?.updateFirstScene(response: response)
        
        if(response.isBlockedForNext) {
            runCountdownQueue()
        }
    }

    private let countDownQueue: DispatchQueue = DispatchQueue(label: "com.teatracks.newInTown.CountDown")
    
    func countDownTime() {
        if StateKeeper.shared.timeToWaitForNextSoryLine > 0 {
            countDownQueue.asyncAfter(deadline: .now() + 1) {[weak self] in
                DispatchQueue.main.async {
                    self?.presenter?.updateWaitingTime(withString: String(Int(StateKeeper.shared.timeToWaitForNextSoryLine.rounded())))
                }
                self?.countDownTime()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.restoreFromGameState()
            }
        }
    }
    
    func runCountdownQueue() {
        countDownTime()
    }

}

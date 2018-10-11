//
//  StateKeeper.swift
//  NewInTown
//
//  Created by Jan Trutzschler on 10/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import Foundation

struct GameState: Codable {
    var points: Int = 0
    var currentStoryLineId: String = ""
    var currentDialogIndex: Int = 0
    var timeToWait: TimeInterval = 0
    var date: Date
}

class StateKeeper {
    
    static let shared: StateKeeper = StateKeeper()
    
    private(set) var gameState = GameState(points: 0, currentStoryLineId: "B3045_1", currentDialogIndex:0, timeToWait: 0, date: Date())
    private let documentName: String = "gamestate.json"
    
    var timeToWaitForNextSoryLine: TimeInterval
    {
        let waitTime = Date().timeIntervalSince(gameState.date)
        if gameState.timeToWait == 0 {
            return gameState.timeToWait
        }
        return waitTime - gameState.timeToWait
    }
    
    func canStartStoryLine(storyLineId: String) -> Bool {
        print("timeToWaitForNextSoryLine: \(timeToWaitForNextSoryLine)")
        return timeToWaitForNextSoryLine <= 0
    }
    
    func setGameState(points: Int, storyLineId: String, dialogIndex: Int, timeToWait: TimeInterval) {
        gameState.points = points
        gameState.currentStoryLineId = storyLineId
        gameState.currentDialogIndex = dialogIndex
        gameState.date = Date()
    }
    
    func writeSettings() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(documentName) else {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gameState)
            try data.write(to: url)
    
        } catch {
            print("could not write settings")
        }
        
    }
    
    func readSettings() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(documentName), !FileManager.default.fileExists(atPath: url.absoluteString) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            gameState = try decoder.decode(GameState.self, from: data)
            
        } catch {
            print("could not write settings")
        }
    }
    
}

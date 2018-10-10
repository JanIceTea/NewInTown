//
//  FirstSceneModels.swift
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

enum FirstScene {
    
    // MARK: Use cases
    
    enum FetchFirstScene {
        
        struct Request {
            var answerString: String = "0"
        }
        
        struct Response {
            var hasCorrectAnswer: Bool = false
            var score: Int = 0
            var nextIndex: Int = 0
            var storyLineId: String = ""
        }
        
        struct ViewModel {
            var scoreString: String = "0"
            var nextQuestion: String = ""
        }
    }
}

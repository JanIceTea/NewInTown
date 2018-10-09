//
//  FirstScenePresenter.swift
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

protocol FirstScenePresentationLogic {
    func updateFirstScene(response: FirstScene.FetchFirstScene.Response)
}

class FirstScenePresenter: FirstScenePresentationLogic {
    
    weak var viewController: FirstSceneDisplayLogic?
    let worker = FirstSceneWorker()
    
    // MARK: Present FirstScene
    
    func updateFirstScene(response: FirstScene.FetchFirstScene.Response) {
    
        var viewModel = FirstScene.FetchFirstScene.ViewModel()
        viewModel.scoreString = String(response.score)
        viewModel.nextQuestion = worker.getQuestion(forId: response.nextId)
        viewController?.displayFirstScene(viewModel: viewModel)
    }
}

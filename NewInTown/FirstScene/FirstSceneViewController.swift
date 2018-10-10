//
//  FirstSceneViewController.swift
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

protocol FirstSceneDisplayLogic: class {
    func displayFirstScene(viewModel: FirstScene.FetchFirstScene.ViewModel)
}

class FirstSceneViewController: UIViewController, FirstSceneDisplayLogic, UITextFieldDelegate {
    
    var interactor: FirstSceneBusinessLogic?
    var router: (NSObjectProtocol & FirstSceneRoutingLogic & FirstSceneDataPassing)?
    
    // MARK: Views
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField! {
        didSet {
            answerTextField.delegate = self
        }
    }
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupVIPCycle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupVIPCycle()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAccessibilityIdentifers()
        performStoryLineRequest()
    }
    
    // MARK: Setup
    
    private func setupVIPCycle() {
        let viewController = self
        let interactor = FirstSceneInteractor()
        let presenter = FirstScenePresenter()
        let router = FirstSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        
    }
    
    private func setupAccessibilityIdentifers() {
    
    }
    
    // MARK: Perform an initial request
    
    func performStoryLineRequest() {
        let storylineId = "B3045_1"
        interactor?.fetchStoryLine(withId: storylineId)
    }
    
    func performRequest() {
        guard let text = answerTextField.text else {
            return
        }
        interactor?.validate(answer: text)
    }
    
    func displayFirstScene(viewModel: FirstScene.FetchFirstScene.ViewModel) {
        scoreCountLabel.text = viewModel.scoreString
        messageLabel.text = viewModel.nextQuestion
        answerTextField.text = ""
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performRequest()
        return false
    }
}

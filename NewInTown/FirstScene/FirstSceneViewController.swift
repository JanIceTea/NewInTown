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
    func displayFailure(withMessage message: String)
    func displaySuccess(withMessage message: String)
    func displayWaiting(withTimeString timeString: String)
    func displayScore(withString scoreString: String)

}

class FirstSceneViewController: UIViewController, FirstSceneDisplayLogic, UITextFieldDelegate {
    
    var interactor: FirstSceneBusinessLogic?
    var router: (NSObjectProtocol & FirstSceneRoutingLogic & FirstSceneDataPassing)?
    
    // MARK: Views
    @IBOutlet weak var dialogContentView: UIView!
    @IBOutlet weak var waitInfoContentView: UIView!
    
    @IBOutlet weak var countdownCounterLabel: UILabel!
    @IBOutlet weak var infoToastContentView: UIView!
    @IBOutlet weak var infoToastLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField! {
        didSet {
            answerTextField.delegate = self
        }
    }
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
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
        addCloseButton()
    }
    
    private func setupAccessibilityIdentifers() {
    
    }
    
    // MARK: Perform an initial request
    
    func performStoryLineRequest() {
        interactor?.restoreFromGameState()
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
        dialogContentView.isHidden = false
        timeLeftLabel.isHidden = true
        infoToastContentView.isHidden = true
        waitInfoContentView.isHidden = true
    }
    
    private func displayInfoToast(withMessage message:String, completion: ((Bool) -> Swift.Void)? = nil) {
        infoToastLabel.text = message
        infoToastContentView.isHidden = false
        waitInfoContentView.isHidden = true

        UIView.animateKeyframes(withDuration: 2, delay: 0, options: .beginFromCurrentState, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.infoToastContentView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                self.infoToastContentView.alpha = 0
            }
            
        }) { (flag) in
            self.infoToastContentView.isHidden = true
        }

    }
    
    func displayFailure(withMessage message:String) {
        displayInfoToast(withMessage: message) { (flag) in
            self.answerTextField.becomeFirstResponder()
        }
    }
    
    func displaySuccess(withMessage message:String) {
        displayInfoToast(withMessage: message)
    }
    
    func displayWaiting(withTimeString timeString: String) {
        timeLeftLabel.text = timeString
        timeLeftLabel.isHidden = false
        dialogContentView.isHidden = true
        waitInfoContentView.isHidden = false
        countdownCounterLabel.text = timeString
    }
    
    func displayScore(withString scoreString: String) {
        scoreCountLabel.text = scoreString
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performRequest()
        return false
    }
    
    // MARK: - Close button
    //todo refactor
    
    private func addCloseButton() {
        let button = UIButton(type: .custom)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.bounds = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @IBAction private func didPressCloseButton() {
        presentingViewController?.dismiss(animated: true)
    }
}


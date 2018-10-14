//
//  StoryPlaybackViewController.swift
//  NewInTown
//
//  Created by Jan Trutzschler on 11/10/2018.
//  Copyright (c) 2018 teatracks. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class SpeechBubbleView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
}

protocol StoryPlaybackDisplayLogic: class {
    func displayStoryPlayback(viewModel: StoryPlayback.FetchStoryPlayback.ViewModel)
}

class StoryPlaybackViewController: UIViewController, StoryPlaybackDisplayLogic {
    
    @IBOutlet weak var chineseDialogLabel: UILabel!
    @IBOutlet weak var nextDialogPieceButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var speechBubbleView: SpeechBubbleView!
    var interactor: StoryPlaybackBusinessLogic?
    var router: (NSObjectProtocol & StoryPlaybackRoutingLogic & StoryPlaybackDataPassing)?
    
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
        
        performRequest()
    }
    
    // MARK: Setup
    
    private func setupVIPCycle() {
        let viewController = self
        let interactor = StoryPlaybackInteractor()
        let presenter = StoryPlaybackPresenter()
        let router = StoryPlaybackRouter()
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
    
    @IBAction func didPressToggleLanguageButton(_ sender: Any) {
        interactor?.togglePinyin()
    }
    
    @IBAction func didPressNextButton(_ sender: Any) {
        navigateToFirstScene()
    }
    // MARK: Perform an initial request
    
    @IBAction func didPressNextPartButton(_ sender: Any) {
        interactor?.playStoryAtCurrentIndex()
    }
    
    // MARK: - Audio
    
    func playAudio() {
        interactor?.playAudio()
    }

    // MARK: - languange

    
    
    // MARK: - navigation
    
    func navigateToFirstScene() {
        router?.routeToNext()
    }
    
    func performRequest() {
        let request = StoryPlayback.FetchStoryPlayback.Request()
        interactor?.fetchStoryPlayback(request: request)
    }
    
    func displayStoryPlayback(viewModel: StoryPlayback.FetchStoryPlayback.ViewModel) {
        speechBubbleView.isHidden = viewModel.dialogText?.count == 0
        chineseDialogLabel.text = viewModel.dialogText
        guard let playingState = viewModel.playingState else {
            return
        }
        switch playingState {
        case .finished:
            nextDialogPieceButton.isHidden = viewModel.shouldShowNextButton
        case .stopped:
            nextDialogPieceButton.isHidden = false

        default:
            nextDialogPieceButton.isHidden = true
        }
        
        nextButton.isHidden = !viewModel.shouldShowNextButton
        controlView.isHidden = viewModel.shouldShowNextButton
        
        if let imageName = viewModel.imageName {
            imageview.image = UIImage(named: imageName)
        }
        
    }
}

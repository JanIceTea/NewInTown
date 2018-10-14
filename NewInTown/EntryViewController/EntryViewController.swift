//
//  ViewController.swift
//  NewInTown
//
//  Created by Jan Trutzschler on 06/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import UIKit

class TextBackgroundView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.borderWidth = 0
    }
}

class EntryViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textContentView: TextBackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startButton.alpha = 0
        textContentView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.7, delay: 1, options: .curveEaseIn, animations: {
            self.startButton.alpha = 1
            self.textContentView.alpha = 1
        })
    }
    
    @IBAction func didPressStartButton(_ sender: Any) {
        
        var viewController: UIViewController?
        if StateKeeper.shared.gameState.didSeeDialog {
            viewController = VocabOverviewViewController(nibName: nil, bundle: nil)

        } else {
            viewController = StoryPlaybackViewController(nibName: nil, bundle: nil)
        }
        let button = UIButton(type: .custom)
        button.setTitle("close", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.bounds = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)
        let navigationController = UINavigationController(rootViewController: viewController!)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        viewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func didPressCloseButton() {
        dismiss(animated: true)
    }

    @IBAction func didPressResetButton(_ sender: Any) {
        StateKeeper.shared.reset()
    }
}


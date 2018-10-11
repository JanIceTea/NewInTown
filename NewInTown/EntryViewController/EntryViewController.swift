//
//  ViewController.swift
//  NewInTown
//
//  Created by Jan Trutzschler on 06/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressStartButton(_ sender: Any) {
//        let firstScene = FirstSceneViewController(nibName: nil, bundle: nil)
        var viewController: UIViewController?
        if StateKeeper.shared.gameState.didSeeDialog {
            viewController = FirstSceneViewController(nibName: nil, bundle: nil)
        } else {
            viewController = StoryPlaybackViewController(nibName: nil, bundle: nil)
        }
        
        let navigationController = UINavigationController(rootViewController: viewController!)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func didPressResetButton(_ sender: Any) {
        StateKeeper.shared.reset()
    }
}


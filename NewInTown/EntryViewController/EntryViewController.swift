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
        var viewController: UIViewController?
        if StateKeeper.shared.gameState.didSeeDialog {
//            viewController = FirstSceneViewController(nibName: nil, bundle: nil)
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


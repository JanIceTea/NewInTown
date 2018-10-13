//
//  StoryPlaybackRouter.swift
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

@objc protocol StoryPlaybackRoutingLogic {
    func routeToNext()
}

protocol StoryPlaybackDataPassing {
    var dataStore: StoryPlaybackDataStore? { get }
}

class StoryPlaybackRouter: NSObject, StoryPlaybackRoutingLogic, StoryPlaybackDataPassing {
    
    weak var viewController: StoryPlaybackViewController?
    var dataStore: StoryPlaybackDataStore?
    
    // MARK: Routing
    
    func routeToNext() {
        let destinationVC = VocabOverviewViewController(nibName: nil, bundle: nil)
        StateKeeper.shared.setDidSeeDialog()
        navigateToVocabOverview(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToVocabOverview(source: StoryPlaybackViewController, destination: VocabOverviewViewController) {
        source.show(destination, sender: nil)
    }

}

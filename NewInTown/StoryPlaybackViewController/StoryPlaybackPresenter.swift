//
//  StoryPlaybackPresenter.swift
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

protocol StoryPlaybackPresentationLogic {
    func presentStoryPlayback(response: StoryPlayback.FetchStoryPlayback.Response)
}

class StoryPlaybackPresenter: StoryPlaybackPresentationLogic {
    
    weak var viewController: StoryPlaybackDisplayLogic?
    
    // MARK: Present StoryPlayback
    
    func textForLanguage(_ text: StoryContentText, langSelection: LanguageSelection) -> String {
        switch langSelection {
        case .pinyin:
            return text.pinyin
        default:
            return text.chinese
        }
    }
    
    func presentStoryPlayback(response: StoryPlayback.FetchStoryPlayback.Response) {
        let isDialogFinished = response.isDialogFinished ?? false
        var text  = ""
        if let textObj = response.text, let langSelection = response.languageSelection {
            text = textForLanguage(textObj, langSelection: langSelection)
        }
        let viewModel = StoryPlayback.FetchStoryPlayback.ViewModel(playingState: response.playingState, dialogText: text, shouldShowNextButton: isDialogFinished, imageName: response.imageName)
        viewController?.displayStoryPlayback(viewModel: viewModel)
    }
}

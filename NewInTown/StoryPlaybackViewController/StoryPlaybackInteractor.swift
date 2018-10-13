//
//  StoryPlaybackInteractor.swift
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

protocol StoryPlaybackBusinessLogic {
    func fetchStoryPlayback(request: StoryPlayback.FetchStoryPlayback.Request)
    func playAudio()
    func playStoryAtCurrentIndex()
    func togglePinyin()
}

protocol StoryPlaybackDataStore {
    //var name: String { get set }
}

class StoryPlaybackInteractor: StoryPlaybackBusinessLogic, StoryPlaybackDataStore, PlayWorkerDelegate {
    
    var soundfilePlayerWorker: PlayWorker = PlayWorker()
    let worker = FirstSceneWorker()
    var presenter: StoryPlaybackPresentationLogic?
    var currentIndex: Int = 0
    var isFinished: Bool = false
    var languageSelection: LanguageSelection = .simplified
    var currentContent: StoryContent?
    
    // MARK: Perform operation on StoryPlayback
    
    func fetchStoryPlayback(request: StoryPlayback.FetchStoryPlayback.Request) {
        var response = StoryPlayback.FetchStoryPlayback.Response()
        response.playingState = .stopped
        presenter?.presentStoryPlayback(response: response)
    }
    
    func playStoryAtCurrentIndex() {
        guard let content = StoryContentWorker.storyContentRoot?.storyContent else {
            return
        }
        if currentIndex >= content.count {
            return
        }
        let currentContent = content[currentIndex]
        guard let url = Bundle.main.url(forResource: currentContent.audioFileName, withExtension: currentContent.audioFileExtension) else {
            return
        }
        if currentIndex >= content.count {
            return
        }
        
        soundfilePlayerWorker.delegate = self
        soundfilePlayerWorker.playSoundFile(atURL: url, numberOfLoops: 0, waitTime: 0)
        
        self.currentContent = currentContent
        
        presentCurrentStoryContent()
        
        currentIndex = currentIndex + 1
        isFinished = currentIndex >= content.count
    }
    
    func presentCurrentStoryContent() {
        guard let currentContent = currentContent else {
            return
        }
        var response = StoryPlayback.FetchStoryPlayback.Response()
        response.text = currentContent.text
        response.playingState = soundfilePlayerWorker.isPlaying ? .playing : .finished
        response.languageSelection = languageSelection
        response.isDialogFinished = isFinished
        presenter?.presentStoryPlayback(response: response)
    }
    
    func playAudio() {
        guard let storyCollection = FirstSceneWorker.storyCollection else {
            return
        }
        let story = storyCollection.stories[0]
        guard let url = Bundle.main.url(forResource: story.audioFileName, withExtension: story.audioFileExtension) else {
            return
        }
        soundfilePlayerWorker.delegate = self
        soundfilePlayerWorker.playSoundFile(atURL: url, numberOfLoops: 0, waitTime: 0)
    }

    func togglePinyin() {
        switch languageSelection {
        case .simplified:
            languageSelection = .pinyin
        case .pinyin:
            languageSelection = .simplified
        default:
           return
        }
        
        presentCurrentStoryContent()
    }
    
    // MARK: - PlayWorkerDelegate
    
    func didFinishPlaying(worker: PlayWorker) {
        presentCurrentStoryContent()
    }
    
    func didStartPlaying(worker: PlayWorker) {
        
    }

}

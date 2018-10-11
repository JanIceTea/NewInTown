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
        let currentContent = content[currentIndex]
        guard let url = Bundle.main.url(forResource: currentContent.audioFileName, withExtension: currentContent.audioFileExtension) else {
            return
        }
        if currentIndex >= content.count {
            return
        }
        
        soundfilePlayerWorker.delegate = self
        soundfilePlayerWorker.playSoundFile(atURL: url, numberOfLoops: 0, waitTime: 0)
        
        var response = StoryPlayback.FetchStoryPlayback.Response()
        response.text = currentContent.text
        response.playingState = .playing
        presenter?.presentStoryPlayback(response: response)

        currentIndex = currentIndex + 1
        
        isFinished = currentIndex >= content.count
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

    // MARK: -PlayWorkerDelegate
    func didFinishPlaying(worker: PlayWorker) {
        var response  = StoryPlayback.FetchStoryPlayback.Response()
        response.playingState = .finished
        response.isDialogFinished = isFinished
        presenter?.presentStoryPlayback(response: response)
    }
    
    func didStartPlaying(worker: PlayWorker) {
        
    }

}
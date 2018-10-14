//
//  AudioManager.swift
//  AudioFlash
//
//  Created by Jan Trutzschler on 02/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioManagerProtocol {
    
}

class AudioManager: AudioManagerProtocol {
    
    static let sharedInstance = AudioManager()
    
    func start() {
        setupAudioSession()
    }
    
    func stop() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            print("Error: could not activate AudioSession")
        }
    }
    
    private func stopAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print("Error: could not activate AudioSession")
        }
        
    }
}

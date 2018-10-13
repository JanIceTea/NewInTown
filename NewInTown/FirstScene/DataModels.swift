//
//  DataModels.swift
//  NewInTown
//
//  Created by Jan Trutzschler on 10/10/2018.
//  Copyright © 2018 teatracks. All rights reserved.
//

import Foundation

struct Answer: Codable {
    var pinyin: String
    var chinese: String
}

struct Question: Codable {
    var pinyin: String
    var chinese: String
    var english: String
}

struct Dialog: Codable {
    var question: Question
    var answer: Answer
    var points: Int
    var id: String
}

struct StoryLine: Codable {
    var time: Int
    var dialogs: [Dialog]
    var id: String
}

struct Story: Codable {
    var name: String
    var id: String
    var level: String
    var storylines: [StoryLine]
    var audioFileName: String
    var audioFileExtension: String
    var vocabulary: [StoryContentText]
}

struct StoryCollection: Codable {
    var stories: [Story]
}

///

struct StoryContentText: Codable {
    var chinese: String
    var english: String
    var pinyin: String
}

struct StoryContent: Codable {
    var text: StoryContentText
    var audioFileName: String
    var audioFileExtension: String
    var source: String
}

struct StoryContentRoot: Codable {
    var storyContent: [StoryContent]
}

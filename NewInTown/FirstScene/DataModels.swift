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

struct Dialog: Codable {
    var question: String
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
}

struct StoryCollection: Codable {
    var stories: [Story]
}

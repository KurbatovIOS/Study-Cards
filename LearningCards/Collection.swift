//
//  CollectionModel.swift
//  LearningCards
//
//  Created by Kurbatov Artem on 04.08.2022.
//

import Foundation

struct Collection: Identifiable, Codable {
    
    var id: UUID
    var title: String
    var cards = [Card]()
}

struct Card: Identifiable, Codable{
    
    var id: UUID
    var front: String
    var back: String
}


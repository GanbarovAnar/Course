//
//  Card.swift
//  Concetration
//
//  Created by Кирилл Смирнов on 25/02/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    
    var isFaceUp = false
    var isMatched = false
    private(set) var identifier: Int
    
    private static var identifierFactory = 0
    
    var hashValue: Int {
        return self.identifier
    }
    
    
    private static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
}

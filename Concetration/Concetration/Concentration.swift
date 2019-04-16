//
//  Concentration.swift
//  Concetration
//
//  Created by Кирилл Смирнов on 25/02/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import Foundation

extension Collection {
    
    var oneAndOnly: Element? {
        return self.count == 1 ? self.first : nil
    }
}

struct Concentration {
    public var score = Int()
    private var cardRepeat: [Int: Int] = [:]
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        
        get {
            return self.cards.indices.filter { self.cards[$0].isFaceUp }.oneAndOnly
        }
        
        set {
            for index in self.cards.indices {
                self.cards[index].isFaceUp = (index == newValue)
            }
        }
        
    }
    
    mutating func chooseCard(at index: Int) {
        
        if self.cardRepeat[index] != nil{
            self.cardRepeat[index]! += 1
        }else{
            self.cardRepeat[index] = 1
        }
        
        assert(self.cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): выбранный индекс не совпадает с картами")
        
        if !self.cards[index].isMatched {
                if let matchIndex = self.indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                    
                    if self.cards[matchIndex] == self.cards[index] {
                        self.cards[matchIndex].isMatched = true
                        self.cards[index].isMatched = true
                        score += 2
                        
                    }else{
                        if (self.cardRepeat[index]! != 1){
                            if(score > -1){
                                score -= 1
                            }
                        }
                        if(self.cardRepeat[matchIndex]! != 1){
                            if(score > -1){
                                score -= 1
                            }
                        }
                    }
                    
                    self.cards[index].isFaceUp = true
                    
                } else {
                    self.indexOfOneAndOnlyFaceUpCard = index
                }
            
        }else{  }
        
    }
    
    init(numberOfPairsCard: Int) {
        
        assert(numberOfPairsCard > 0, "Количество пар карт, должно быть больше 0")
        
        for _ in 0..<numberOfPairsCard {
            let card = Card()
            self.cards += [card, card]
        }
        
        self.cards.shuffle() 
    }
    
}

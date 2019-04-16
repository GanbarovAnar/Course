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
    private var cardRepeat: [Int: Int] = [:]  // [Identifier: CountClick]
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        
        get {
            // возвращает индекс перевернутой одной карты
            // если перевернуто несколько карт, то возвращает nil
            
            return self.cards.indices.filter { self.cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in self.cards.indices {
//                if self.cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else  {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        
        set {
            // переворачивает лицом вверх карту с заданным индексом.
            // остальные переворачивает лицом вниз.
            for index in self.cards.indices {
                self.cards[index].isFaceUp = (index == newValue)
            }
        }
        
    }
    
    // choose Card - выбранная карта
    mutating func chooseCard(at index: Int) {
        
        if self.cardRepeat[index] != nil{
            self.cardRepeat[index]! += 1
        }else{
            self.cardRepeat[index] = 1
        }
        
        assert(self.cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): выбранный индекс не совпадает с картами")
        
        //for i in cards{ print(i.identifier, terminator: " ") }
        
        //print("from \(self.score)")
        if !self.cards[index].isMatched {
                //print("----> \(index)")
            
                //Если есть предыдущи индекс и он не равен новому
                // matchIndex - предыдущий нажатый индекс, index - новый выбранный индекс
                if let matchIndex = self.indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                    
                    //print("2) matchIndex = \(matchIndex)  - self.indexOfOneAndOnlyFaceUpCard = \(self.indexOfOneAndOnlyFaceUpCard!)  - index = \(index)")
                    
                    //Если индексы(которые .shuffle) перевернутой и текущей совпадают, матчим их
                    //print("matchIndex = \(matchIndex) , index = \(index)")
                    if self.cards[matchIndex] == self.cards[index] {
                        //print("???self.cards[matchIndex] = \(self.cards[matchIndex]) self.cards[index] = \(self.cards[index])")
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
                    
                    // Текущую переварачиваем
                    self.cards[index].isFaceUp = true
                    
                } else {
                    self.indexOfOneAndOnlyFaceUpCard = index
                    //print("Sself.indexOfOneAndOnlyFaceUpCard = \(self.indexOfOneAndOnlyFaceUpCard!)")
                }
            
        }else{
            //print("=====")
        }
        //print("to \(self.score)")
    }
    
    init(numberOfPairsCard: Int) {
        
        // Если количество карт <= 0, то утверждение numberOfPairsCard > 0
        // вычислится как false, завершив за собой приложение.
        assert(numberOfPairsCard > 0, "Количество пар карт, должно быть больше 0")
        
        for _ in 0..<numberOfPairsCard {
            let card = Card()
            self.cards += [card, card]
        }
        
        self.cards.shuffle() // меняем у карт identifier
    }
    
}

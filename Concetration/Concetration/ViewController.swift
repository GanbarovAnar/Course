//
//  ViewController.swift
//  Concetration
//
//  Created by Кирилл Смирнов on 12/02/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import UIKit

private var arrayEmoji: [String: [String]] = [
                            "number":  ["1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣"],
                            "car": ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑"],
                            "smile": ["😀","😭","😱","😇","😛","😍","😎","🤓"],
                            "flag": ["🇺🇸","🇯🇵","🇦🇺","🇦🇿","🇰🇿","🇨🇳","🇹🇷","🇨🇦"],
                            "ball": ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"],
                            "fruit": ["🍏","🍓","🍐","🍊","🍋","🍍","🍇","🍌"]
                        ]





class ViewController: UIViewController {
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var score: UILabel!
    @IBOutlet weak var buttonNewGame: UIButton!
    
    private(set) var count = 0 {
        didSet {
            self.countLabel.text = "👆 : \(self.count)"
        }
    }
    
    private(set) var scoreInt = 0 {
        didSet {
            self.score.text = "⭐️ : \(self.scoreInt)"
        }
    }
    
    @IBAction func actionNewGame(_ sender: UIButton) {
        newGame()
    }
    
    
    var numberOfPairsCard: Int {
        return (self.cardButtons.count + 1) / 2
    }
    
    private lazy var game = Concentration(numberOfPairsCard: self.numberOfPairsCard)
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private lazy var emojiArray: [String] = randomEmoji() // ( allCases - convert enum to array )
    
    private var emoji: [Card: String] = [:]  // пустой словарь с картами и смайликами
    
    
    @IBAction private func emojiButtonAction(_ sender: UIButton) {
        if let index = self.cardButtons.firstIndex(of: sender) {
            
            self.game.chooseCard(at: index)
            scoreInt = self.game.score
            self.updateViewModel()
            count += 1
            
            
            
        } else {
            print("Unhandled Error!!!")
        }
        
    }
    
    private func updateViewModel() {
        var isNotFaceUpAndNotMatched: Int = 0
        for index in self.cardButtons.indices {
            
            let button = self.cardButtons[index]
            let card = self.game.cards[index]
            
            
            if card.isFaceUp {
                button.setTitle(self.emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                if(card.isMatched){
                  button.backgroundColor = #colorLiteral(red: 1, green: 0.6910475492, blue: 0, alpha: 0)
                }else{
                    isNotFaceUpAndNotMatched += 1
                    button.backgroundColor = #colorLiteral(red: 1, green: 0.6910475492, blue: 0, alpha: 1)
                }
                
            }
        }
        
        if(isNotFaceUpAndNotMatched == 0){
            alertTheEnd()
        }
        
    }
    
    
    private func emoji(for card: Card) -> String {
        if self.emoji[card] == nil, self.emojiArray.count > 0 {
            self.emoji[card] = self.emojiArray.remove(at: self.emojiArray.count.arc4random)
        }
        
        return self.emoji[card] ?? "?"
    }
    
    
    public func randomEmoji() -> [String] {
        var randomNumber: Int = arrayEmoji.count.arc4random // генерируем рандомный индекс
        
        for value in arrayEmoji.values {
            if(randomNumber == 0){
                return value
            }
            randomNumber -= 1
        }
        
        return arrayEmoji["car"]! // это не выполняется =)
    }
    
    func alertTheEnd() {
        
        let alert = UIAlertController(title: "The end", message: "Ваш счет: \(scoreInt)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertAction.Style.default, handler: { action in
            self.newGame()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func newGame(){
        game = Concentration(numberOfPairsCard: self.numberOfPairsCard)
        count = 0
        scoreInt = 0
        emojiArray = randomEmoji()
        emoji = [:]
        updateViewModel()
    }
    
}

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
        //print("numberOfPairsCard = ",self.cardButtons.count,"( ",((self.cardButtons.count+1)/2)," )")
        return (self.cardButtons.count + 1) / 2  // ??? почему +1 /2 ??? когда можно /2 ?
    }
    
    // Создается массив карт с различными индентификаторами GAME.cards = [Card]
    
    private lazy var game = Concentration(numberOfPairsCard: self.numberOfPairsCard)
    
    // Создается массив с кнопками
    @IBOutlet private var cardButtons: [UIButton]!
    // тут исправили кнопки на макете, потому что они были добавлены не по порядку в массив
    
    private lazy var emojiArray: [String] = randomEmoji() // ( allCases - convert enum to array )
    //Список смайликов, которые даются в начале игры без повторений,
    // со временем по мере нажатия на смайлики, они удаляются из этого массива и перемещаются во второй массив emoji
 
    
    private var emoji: [Card: String] = [:]  // пустой словарь с картами и смайликами
    
    //хранит в себе нажатые карточки без повторения
    
    
    @IBAction private func emojiButtonAction(_ sender: UIButton) {
        // ищем индекс нажатой кнопки
        if let index = self.cardButtons.firstIndex(of: sender) {
            
            self.game.chooseCard(at: index)
            scoreInt = self.game.score
            self.updateViewModel()
            count += 1
            
            
            
        } else {
            print("Unhandled Error!!!")
        }
        //print("->",emoji,"<-")
        
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
    
    
    // добавляет в emoji элменты, которых не было, повторяющие смайлики не добавляются.
    // удаляет из emojiArray смайлики, которые уже были когда-то нажаты (или нажаты их копии)
    // в начале в emojiArray 8 смайликов
    private func emoji(for card: Card) -> String {
        if self.emoji[card] == nil, self.emojiArray.count > 0 {
            self.emoji[card] = self.emojiArray.remove(at: self.emojiArray.count.arc4random)
            //print("self.emoji[card] = \(self.emoji[card]!)")
            // self.emojiArray.count.arc4random - возвращает случайное число в диапазоне от 0 до N - 1
        }
        
        return self.emoji[card] ?? "?"
    }
    
    
    public func randomEmoji() -> [String] {
        ///fgdgf
        var randomNumber: Int = arrayEmoji.count.arc4random // генерируем рандомный индекс
        
        // так как из словаря нельзя брать с помощью индекса,
        // то проходим по нему циклом со счетчиком
        for value in arrayEmoji.values {
            if(randomNumber == 0){
                return value
            }
            randomNumber -= 1
        }
        
        return arrayEmoji["car"]! // это не выполняется =)
    }
    
    func alertTheEnd() {
        
        // create the alert
        let alert = UIAlertController(title: "The end", message: "Ваш счет: \(scoreInt)", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertAction.Style.default, handler: { action in
            self.newGame()
        }))
        
        // show the alert
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

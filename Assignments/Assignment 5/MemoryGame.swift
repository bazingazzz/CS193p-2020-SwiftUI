//
//  MemoryGame.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/7/9.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    //itearable things should be identifiable
    //struct is value type = is‘s passed as a parameter to a function(copied)
    struct Card: Identifiable{
        //预设值
        var isFaceUp:Bool = false
        {
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }
                else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched:Bool = false
        {
            didSet{
                stopUsingBonusTime()
            }
        }
        var isEverSeen:Bool = false
        var content:CardContent
        var id: Int
        
        //MARK: - Bonues Time
        
        //this could give matching bonus points
        //if the user matches the card
        //before a certain amount of time passed during which the card is face up
        
        //can be zero which means no bonus available for this card
        var bonuesTimeLimit: TimeInterval = 10
        
        //how long this card has ever been face up
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }
            else{
                return pastFaceUpTime
            }
        }
        
        //the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        //the accumulated time this card has been face up in the past
        //(i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        //how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval{
            max(0, bonuesTimeLimit - faceUpTime)
        }
        
        // precentage of the bonus time reamaning
        var bonusRemaining: Double{
            (bonuesTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonuesTimeLimit : 0
        }
        
        //whether the card was matched during the bonus time period
        var hasEarnedBounes: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        
        //wheter we are currently face up, unmatched and have not yet uesd up the bonus window
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        //called when the card transitions to face up state
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        //called when the card goes back face down(or gets matched)
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
    
    //结构内变量
    private(set) var cards: Array<Card>
        
    private(set) var score: Int = 0
    
    private(set) var LastTimeChosen: Date = Date.init()
    
    var countDown: TimeInterval {
        return 10.0 - Date.init().timeIntervalSince(self.LastTimeChosen) > 1 ? 10.0 - Date.init().timeIntervalSince(self.LastTimeChosen) : 1
    }
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{
//            var faceUpCardIndices = Array<Int>()
//            for index in cards.indices{
//                if cards[index].isFaceUp{
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1{
//                return faceUpCardIndices.first
//            }
//            else{
//                return nil
//            }
            
            //another codeing style
//            var faceUpCardIndics = cards.indices.filter { (index) -> Bool in
//                return cards[index].isFaceUp
//            }
            
            //minimal codeing style
            cards.indices.filter { cards[$0].isFaceUp}.only
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    private var isAllCardsMatch: Bool{
        get{
            cards.indices.filter{!cards[$0].isMatched}.allMatch
        }
    }
    
    //结构内函数
    //mutating = all function that change itself
   mutating func choose(_ card: Card) {
        print("card chosen:\(card)")
        if let chosenIndex:Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                cards[chosenIndex].isFaceUp = true
                if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    //score += 2 * Int.init(self.countDown)
                    score += Int(cards[chosenIndex].bonusTimeRemaining + cards[potentialMatchIndex].bonusTimeRemaining)
                    if isAllCardsMatch{
                        cards[chosenIndex].isFaceUp = false
                        cards[potentialMatchIndex].isFaceUp = false
                    }
                }
                else{
                    if cards[chosenIndex].isEverSeen && !cards[chosenIndex].isMatched{
                        //score -= 1 * Int.init(self.countDown)
                        score -= Int(cards[chosenIndex].bonusTimeRemaining)
                    }
                    if cards[potentialMatchIndex].isEverSeen && !cards[potentialMatchIndex].isMatched{
                        //score -= 1 * Int.init(self.countDown)
                        score -= Int(cards[chosenIndex].bonusTimeRemaining)
                    }
                    cards[chosenIndex].isEverSeen = true
                    cards[potentialMatchIndex].isEverSeen = true
                }
            }
            else{
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                //self.LastTimeChosen = Date.init()
            }
        }
    }
    
    private func index(of card: Card) -> Int{
        for index in 0..<self.cards.count{
            if self.cards[index].id == card.id{
                return index
            }
        }
        return 0 // TODO: Done!
    }
    
    //结构初始化函数
    //all init are mutating
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
}

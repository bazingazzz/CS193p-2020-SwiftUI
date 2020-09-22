//
//  SetGameModel.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation

struct SetGameModel {
    // MARK: - User Accessible Variables
    // 卡牌集合 playing cards
     private(set) var cards: [Card] = Array<Card>()
    // 下一张卡牌
    private(set) var nextPlayingCardIndex: Int = 0
    // 游戏是否结束
    private(set) var gameFinished: Bool = false
    
    
    // MARK: - Private Variables
    //已经配对的卡牌数量
    private var matchedCardCount: Int = 0
    //已经选择的卡牌集合
    private var chosenCards: [Card] = Array<Card>()
    //已经错误set的卡牌集合
    private var wrongSetCards: [Card] = Array<Card>()
    //已经提示过的卡牌集合
    private var hintedCards: [Card] = Array<Card>()
    //目前提示的卡牌
    private var hintingIndex: Int?
    //潜在卡牌集合
    private var potentialSets: [[Card]] = Array<Array<Card>>()
    
    
    // MARK: - Computed Variables
    // 剩余卡牌数量
    var remainingCardCount: Int {
        get { 81 - nextPlayingCardIndex - matchedCardCount }
    }
    // 剩余提示数量
    var availableHints: Int {
        get { potentialSets.count }
    }
    
    // MARK: - New Game 新游戏
    init() {
        for number in CardFeature.allCases {
            for color in CardFeature.allCases {
                for shape in CardFeature.allCases {
                    for fill in CardFeature.allCases {
                        cards.append(Card(number: number, color: color, shape: shape, fill: fill))
                    }
                }
            }
        }
        cards.shuffle()
        deal(12)
    }
    
    // MARK: Intent 1 - Choose a Card 选择一张卡牌
    mutating func choose(card: Card) {
        // 重置错误卡牌集合 reset wrong sets upon any interaction
         resetWrongSet()
        
        // 选择一张卡把属性ischosen设为相反
        let chosenCardIndex = cards.firstIndex(matching: card)!
        cards[chosenCardIndex].isChosen.toggle()
        
        // 如果是选择了卡片 if the card is now chosen
        if (cards[chosenCardIndex].isChosen) {
            // 添加入选择卡牌集合 matching card state
            chosenCards.append(cards[chosenCardIndex])
            
            // 如果集合数量等于3 See if it is a match
            if (chosenCards.count == 3) {
                // reset the hint upon 3 chosen cards regardless of match
                 resetHintedSet()
                
                //判断已经在卡牌集合的卡牌是否符合要求
                if (isMatch(cardA: chosenCards[0], cardB: chosenCards[1], cardC: chosenCards[2])) {
                    // 匹配成功 is a match
                    for card in chosenCards {
                        // 状态ismatched改为已经matched
                        cards[cards.firstIndex(matching: card)!].state = .matched
                        // 从卡牌集合里移除当前牌
                        cards.remove(at: cards.firstIndex(matching: card)!)
                    }
                    //计数
                    matchedCardCount += 3
                    nextPlayingCardIndex -= 3
                    //清空已选择集合
                    chosenCards.removeAll()
                    
                    // 找到新的潜在组合 find potential matches in new set
                    //potentialSets = findAllSetIndices()
                    
                    // 重新发3张牌 deal 3 more cards if there is less than 12 playing cards
                    if (nextPlayingCardIndex < 12) { deal() }
                }
                //如果不符合要求
                else {
                    // 匹配失败 not a match
                    for card in chosenCards {
                        //状态ischosen已选择取消
                        cards[cards.firstIndex(matching: card)!].isChosen = false
                        //状态iswrongset是否曾经选错过改为true
                        cards[cards.firstIndex(matching: card)!].isWrongSet = true
                    }
                    //添加错误选择卡牌集合
                    wrongSetCards = chosenCards
                    //清空已选择集合
                    chosenCards.removeAll()
                }
            }
        }
        //如果是取消选择卡，无需判断是否set
        else {
            // matching card state
            chosenCards.remove(at: chosenCards.firstIndex(matching: cards[chosenCardIndex])!)
        }
    }
    
    // MARK: Intent 2 - Deal (3) Cards 发牌
    mutating func deal(_ n: Int = 3) {
        // 重置错误卡牌集合 reset all playing card warnings
        resetWrongSet()
        
        // 发n张牌 deal n cards
        for _ in (0..<n) {
            //如果牌不够了 if all cards are dealt
            if nextPlayingCardIndex >= cards.count {
                break
            }
            //改变状态
            cards[nextPlayingCardIndex].isFlip = true
            cards[nextPlayingCardIndex].state = .playing
            nextPlayingCardIndex += 1
        }

        // 找到所有潜在可能 find all potential matches in current playing
        potentialSets = findAllSetIndices()
        
        //游戏结束的情况1.没有组合了、2.卡牌数量不够了
        //if playing cards have no match and no more cards to deal, game is finished
        if (potentialSets.count == 0 && nextPlayingCardIndex >= cards.count) {
            gameFinished = true
            print("Game: finished.")
        }
    }
    
    // MARK: Intent 3 - Show hint (loop) 提示三张牌为一个组合
    mutating func hint() {
        // reset all playing card warnings
        resetWrongSet()
        resetHintedSet()
        resetChosen()
        
        // 如果游戏没有卡牌可以配对了 break if no sets
        guard (potentialSets.count > 0) else { hintingIndex = nil; return }
        
        
        switch hintingIndex {
        // if has hinting
        case .some(let data):
            hintingIndex = data + 1
            if (hintingIndex! >= potentialSets.count) {
                hintingIndex = 0
            }
        case .none:
            hintingIndex = 0
        }
        
        // hint the 3 cards
        for card in potentialSets[hintingIndex!] {
            cards[cards.firstIndex(matching: card)!].isHinted = true
            hintedCards.append(card)
        }
    }
    
    
    // MARK: - Supporting Funcs - Matching Set
    // 三张卡牌返回是否是一对set Return true if given three cards are a set
    private func isMatch(cardA: Card, cardB: Card, cardC: Card) -> Bool {
        if !isSet([cardA.number, cardB.number, cardC.number]) { return false }
        if !isSet([cardA.color, cardB.color, cardC.color]) { return false }
        if !isSet([cardA.shape, cardB.shape, cardC.shape]) { return false }
        if !isSet([cardA.fill, cardB.fill, cardC.fill]) { return false }
        return true
    }
    // Return true if given three features are a set
    private func isSet(_ features: Array<CardFeature>) -> Bool {
        var a = 0, b = 0, c = 0
        for feature in features {
            switch feature {
            case .featureA: a += 1
            case .featureB: b += 1
            case .featureC: c += 1
            }
        }
        //三个为同一种花色或者不同花色
        return !(a == 2 || b == 2 || c == 2)
    }
    
    
    // MARK: - Supporting Funcs - Hints
    
    // 找到所有潜在组合 Find all potential sets in view
    // 时间复杂度 Complexity O(n^3), max 1,080/511,920
    private mutating func findAllSetIndices() -> [[Card]] {
        //重置hintedCards卡牌集合
        resetHintedSet()
        hintingIndex = nil
        
        var matchSets = Array<Array<Card>>()
        guard nextPlayingCardIndex >= 3 else { return matchSets }
        for a in (0..<(nextPlayingCardIndex - 2)) {
            for b in ((a + 1)..<(nextPlayingCardIndex - 1)) {
                for c in ((b + 1)..<nextPlayingCardIndex) {
                    if (isMatch(cardA: cards[a], cardB: cards[b], cardC: cards[c])) {
                        matchSets.append([cards[a], cards[b], cards[c]])
                    }
                }
            }
        }
        return matchSets
    }
    
    
    // MARK: - Supporting Funcs - Reset Card States
    private mutating func resetChosen() {
        for card in chosenCards {
            cards[cards.firstIndex(matching: card)!].isChosen = false
        }
        chosenCards.removeAll()
    }
    
    private mutating func resetWrongSet() {
        for card in wrongSetCards {
            cards[cards.firstIndex(matching: card)!].isWrongSet = false
        }
        wrongSetCards.removeAll()
    }

    private mutating func resetHintedSet() {
        for card in hintedCards {
            cards[cards.firstIndex(matching: card)!].isHinted = false
        }
        hintedCards.removeAll()
    }
    
    
    // MARK: - Struct and Enum
}

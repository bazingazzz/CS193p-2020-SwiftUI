//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    
    
    //MARK: - ViewModel
    
    //published变量：game代表每一场游戏
    @Published private var game = createGame()
    
    //creategame函数
    private static func createGame() -> SetGameModel {
        return SetGameModel()
    }
    
    
    // MARK: - Access to model
    
    //卡牌集合
    var cards: Array<Card> {
        return game.cards
    }
    //剩余配对数
    var matchesInView: Int {
        return game.availableHints
    }
    //目前卡的数量
    var playingCardCount: Int {
        return game.nextPlayingCardIndex
    }
    //剩余卡的数量
    var remainingCards: Int {
        return game.remainingCardCount
    }
    //能否发牌
    var dealDisabled: Bool {
        if (game.remainingCardCount == 0) { return true }
        else { return false }
    }
    //能否提示
    var hintDisabled: Bool {
        if (game.availableHints == 0) { return true }
        else { return false }
    }
    
    
    // MARK: - Intent(s)
    //新游戏
    func new() {
        game = SetGameViewModel.createGame()
    }
    //发牌
    func deal() {
        game.deal()
    }
    //选择牌
    func choose(card: Card) {
        game.choose(card: card)
    }
    //提示
    func hint() {
        game.hint()
    }

}


//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Roland Schmitz on 23.07.20.
//

import Foundation
import SwiftUI


class SetGameViewModel : ObservableObject {
    typealias Game = SetGame<CardContentView>
    typealias Card = Game.Card
    typealias SetState = Game.SetState

    @Published private(set) var theme: Theme
    @Published private(set) var playerCount: Int = 1
    @Published private var game: Game

    class func createGame(for theme: Theme) -> Game {
        SetGame<CardContentView>(
            countRange: theme.counts,
            colorIndices: theme.colors.indices,
            shapeIndices: theme.shapes.indices,
            shadingIndices: theme.shadings.indices,
            contentFactory: { count, colorIndex, shapeIndex, shadingIndex in
                CardContentView(
                    count: count,
                    color: theme.colors[colorIndex],
                    shape: theme.shapes[shapeIndex],
                    shading: theme.shadings[shadingIndex]
                )
            }
        )
    }
    
    init() {
        let theme = themes.first!
        self.theme = theme
        self.game = Self.createGame(for: theme)
        
    }

    var cards: [Card] {
        game.cards
    }
    
    var openCards: [Card] {
        game.openCards
    }
    
    var topDeckCard: Card? {
        game.cards.first { $0.position == .inDeck }
    }
    
    var hasDeckCards: Bool {
        topDeckCard != nil
    }
    
    func choose(card: Card) {
        game.choose(card: card)
    }
    
    func shuffle() {
        game.shuffle()
    }
    
    func deal() {
        game.deal()
    }

    func showMore() {
        game.showMore()
    }
    
    func showHint() {
        game.showHint()
    }
    
    func hideHint() {
        game.hideHint()
    }
    
    func newGame() {
        self.game = Self.createGame(for: theme)
    }
}

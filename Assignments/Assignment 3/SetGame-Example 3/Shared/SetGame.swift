//
//  SetGame.swift
//  SetGame
//
//  Created by Roland Schmitz on 23.07.20.
//

import Foundation

struct SetGame<CardContent> {
    private(set) var cards: [Card] = []

    init(countRange: ClosedRange<Int>, colorIndices: Range<Int>, shapeIndices: Range<Int>, shadingIndices: Range<Int>, contentFactory: (_ symbolCount: Int, _ symbolColorIndex: Int, _ symbolShapeIndex: Int, _ symbolShadingIndex: Int) -> CardContent) {
        var cardId: Int = 0
        for count in countRange {
            for colorIndex in colorIndices {
                for shapeIndex in shapeIndices {
                    for shadingIndex in shadingIndices {
                        cards.append(Card(id: cardId , symbolCount: count, symbolColorIndex: colorIndex, symbolShapeIndex: shapeIndex, symbolShadingIndex: shadingIndex, content: contentFactory(count, colorIndex, shapeIndex, shadingIndex), position: .inDeck))
                        cardId += 1
                    }
                }
            }
        }
    }
    
    var openCards: [Card] {
        cards.filter { card in card.position == .onTable}
    }
    
    var selectedCards: [Card] {
        cards.filter { card in card.isSelected }
    }
    
    var topDeckCardIndex: Int? {
        cards.firstIndex { $0.position == .inDeck }
    }
    
    mutating func showTopDeckCard() {
        if let topDeckCardIndex = topDeckCardIndex {
            cards[topDeckCardIndex].position = .onTable
        }
    }
    
    mutating func replaceSelectedMatchingCards(force: Bool = false) {
        cards
            .indices
            .filter { cards[$0].isSelected && cards[$0].setState == .matching }
            .forEach { matchedIndex in
                cards[matchedIndex].isSelected = false
                cards[matchedIndex].position = .removed
                if let topDeckCardIndex = topDeckCardIndex, openCards.count < 12 || force {
                    cards[topDeckCardIndex].position = .onTable
                    cards.swapAt(matchedIndex, topDeckCardIndex)
                }
            }
    }
    
    mutating func unselectNonMatchingCards() {
        cards
            .indices
            .filter { cards[$0].isSelected && cards[$0].setState == .nonMatching }
            .forEach { nonMatchedIndex in
                cards[nonMatchedIndex].isSelected = false
                cards[nonMatchedIndex].setState = .incomplete
            }
    }
    
    mutating func choose(card: Card) {
        replaceSelectedMatchingCards()
        unselectNonMatchingCards()
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           cards[chosenIndex].position == .onTable {
            cards[chosenIndex].isSelected.toggle()
        }
        
        let setState = calculateSetState(for: selectedCards)
        if setState != .incomplete {
            cards.indices
                .filter { cards[$0].isSelected }
                .forEach { cardIndex in
                    cards[cardIndex].setState = setState
                }
        }
    }

    func calculateSetState(for possibleSet: [Card]) -> SetState {
        if possibleSet.count != 3 {
            return .incomplete
        } else {
            return (
                Set(possibleSet.map { $0.symbolCount }).count != 2 &&
                    Set(possibleSet.map { $0.symbolColorIndex }).count != 2 &&
                    Set(possibleSet.map { $0.symbolShapeIndex }).count != 2 &&
                    Set(possibleSet.map { $0.symbolShadingIndex }).count != 2
            ) ? .matching : .nonMatching
        }
    }
    
    mutating func reset() {
        cards.indices.forEach { cardIndex in
            cards[cardIndex].reset()
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func deal() {
        reset()
        shuffle()
        12.times { showTopDeckCard() }
    }
    
    mutating func showMore() {
        if selectedCards.filter({ $0.setState == .matching }).count > 0 {
            replaceSelectedMatchingCards(force: true)
        } else {
            3.times { showTopDeckCard() }
        }
    }

    mutating func showHint() {
        // todo find hint cards matching current selection or hint a non matchable card in selection
        cards[0].hint = .matching
        cards[1].hint = .nonMatching
    }
    
    mutating func hideHint() {
        cards.indices.forEach { cards[$0].hint = .incomplete }
    }

    enum CardPosition {
        case inDeck, onTable, removed
    }
    
    enum SetState {
        case incomplete, matching, nonMatching
    }

    struct Card : Identifiable {
        let id: Int
        let symbolCount: Int
        let symbolColorIndex: Int
        let symbolShapeIndex: Int
        let symbolShadingIndex: Int
        let content: CardContent
        var position: CardPosition
        var isSelected: Bool = false
        var setState: SetState = .incomplete
        var hint: SetState = .incomplete
        
        mutating func reset() {
            position = .inDeck
            isSelected = false
            setState = .incomplete
        }
    }

}



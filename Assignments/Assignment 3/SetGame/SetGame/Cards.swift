//
//  Cards.swift
//  Set Game
//
//  Created by 郑嘉浚 on 2020/7/30.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation

// MARK: - Struct and Enum

struct Card: Identifiable {
    //id
    var id = UUID()
    
    //数字
    var number: CardFeature
    //颜色
    var color: CardFeature
    //形状
    var shape: CardFeature
    //图案
    var fill: CardFeature
    
    //生命周期 Source of truth
    var state: CardState = .fresh
    
    //目前状态 In the view highlights
    var isWrongSet: Bool = false
    var isChosen: Bool = false
    var isHinted: Bool = false
    var isFlip: Bool = false
}

// Card lifecycle fresh -> playing -> matched
enum CardState: Equatable {
    case fresh, playing, matched
}

// Three card features for each category: number, color, shape, or fill style
enum CardFeature: CaseIterable {
    case featureA, featureB, featureC
}


//enum Numbers: CaseIterable{
//    case one
//    case two
//    case three
//}
//
//enum Patterns: CaseIterable{
//    case rhombus
//    case oval
//    case wavy
//}
//
//enum Textures: CaseIterable{
//    case solid
//    case hollow
//    case stripe
//}
//
//enum Colors: CaseIterable{
//    case red
//    case green
//    case purple
//}
//
//struct Cards {
//    struct card: Identifiable{
//        var id: ObjectIdentifier
//        let number: Numbers
//        let pattern: Patterns
//        let texture: Textures
//        let color: Colors
//        var isShowed: Bool = false
//        var isSeted: Bool = false
//    }
//
//    private(set) var cards: Array<card>
//
//    init() {
//        self.cards = Array<card>()
//        self.newPairOfCards()
//    }
//
//    mutating func newPairOfCards() -> Void {
//        for number in Numbers.allCases{
//            for pattern in Patterns.allCases{
//                for texture in Textures.allCases{
//                    for color in Colors.allCases{
//                        self.cards.append(card(id: ObjectIdentifier.init(AnyObject.self), number: number, pattern: pattern, texture: texture, color: color))
//                    }
//                }
//            }
//        }
//    }
//
//    func choose(){
//
//    }
//
//    mutating func shuffle(){
//        self.cards.shuffle()
//    }
//
//    func deal(){
//
//    }
//}




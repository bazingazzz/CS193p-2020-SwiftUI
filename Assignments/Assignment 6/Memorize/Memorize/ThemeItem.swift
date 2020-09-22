//
//  Theme.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/9/21.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

// Assignment 5 Task 1 - Change Int? to Int
// Assignment 5 Task 2 - Change to Codable to enable JSON

struct ThemeItem:Hashable, Identifiable, Codable {
    
//    //id
//    var id: UUID
//
//    static func == (lhs: ThemeItem, rhs: ThemeItem) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
    // The ID
    var id : Int = newID()
    
    // Init functions
    static var nextID = 5000 // imported IDs will start from 1000
    
    static func newID () -> Int {
        ThemeItem.nextID = ThemeItem.nextID + 1
        return ThemeItem.nextID
    }
    
//    init() {
//        self.id = ThemeItem.newID()
//        self.name = "hollowood"
//        self.colorRGB = UIColor.orange.rgb
//        self.colors = "orange"
//        self.emojis = ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"]
//        self.noOfPairs = 8
//    }
    
//    init(id: Int? = nil) {
//        self.id = ThemeItem.newID()
//        self.name = "hollowood"
//        self.colorRGB = UIColor.orange.rgb
//        self.colors = "orange"
//        self.emojis = ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"]
//        self.noOfPairs = 8
//    }
    
//    init(id: UUID? = nil) {
//        self.id = id ?? UUID()
//        self.name = "Hollowood"
//        self.colorRGB = UIColor.orange.rgb
//        self.colors = "orange"
//        self.emojis = ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"]
//        self.noOfPairs = 8
//    }
    
    
    //主题名
    var name: String
    
    //主题颜色
    var colorRGB: UIColor.RGB
    
    var color: Color {
        Color(colorRGB)
    }
    var colors: String
    
    //emojis
    var emojis: [String]
    
    //deleted emojis
    var DeletedEmojis: [String]
    
    //卡牌数
    var noOfPairs: Int
    
    //从json加载
//    init?(json: Data?) {
//        if json != nil, let newTheme = try? JSONDecoder().decode(ThemeItem.self, from: json!){
//            self = newTheme
//        } else{
//            return nil
//        }
//    }
    
    //Json
//    var json: Data? {
//        return try? JSONEncoder().encode(self)
//    }
    
    var themeColor : UIColor.RGB{
        return self.colorRGB
    }
    
    var themeUIColor: UIColor {
        get {
            UIColor(self.themeColor)
        }
        set{
            self.colorRGB = newValue.rgb
        }
    }
    
    //... the ones shown on the home screen
    var lastScore : Int = 0
    var bestScore : Int = 0
    
    //... the ones that are used to make the game easier or harder
    var noOfPairsOfCards : Int = 1
    var bonusTimeLimit : Int = maxBonusTimeLimit / 2

    static let maxBonusTimeLimit =  14
    static let maxNoOfPairsOfCards = 16
    
    static let defaultThemeItem = ThemeItem(name: "Default", colorRGB: UIColor.clear.rgb, colors: "orange", emojis: ["👻"],DeletedEmojis: [], noOfPairs: 1)
}

//let themes: [Theme] = [
//    Theme(
//        name: "Halloween",
//        colorRGB:  UIColor.orange.rgb,
//        colors: "orange",
//        emojis: ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"],
//        noOfPairs: 8),
//    Theme(
//        name: "Flags",
//        colorRGB: UIColor.red.rgb,
//        colors: "red",
//        emojis: ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇨🇦","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"],
//        noOfPairs: 10),
//    Theme(
//        name: "Animals",
//        colorRGB:  UIColor.green.rgb,
//        colors: "green",
//        emojis: ["🦑","🦧","🦃","🦚","🐫","🦉","🦕","🦥","🐸","🐼","🐺","🦈"],
//        noOfPairs: 6),
//    Theme(
//        name: "Places",
//        colorRGB:  UIColor.purple.rgb,
//        colors: "purple",
//        emojis: ["🗽","🗿","🗼","🎢","🌋","🏝","🏜","⛩","🕍","🕋","🏯","🏟"],
//        noOfPairs: 8),
//    Theme(
//        name: "Sports",
//        colorRGB:  UIColor.blue.rgb,
//        colors: "blue",
//        emojis: ["🤺","🏑","⛷","⚽️","🏀","🪂","🥏","⛳️","🛹","🎣","🏉","🏓"],
//        noOfPairs: 8),
//    Theme(
//        name: "Foods",
//        colorRGB:  UIColor.yellow.rgb,
//        colors: "yellow",
//        emojis: ["🌮","🍕","🍝","🍱","🍪","🍩","🥨","🥖","🍟","🍙","🍢","🍿"],
//        noOfPairs: 10)
//]

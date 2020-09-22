//
//  Themes.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/18.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

// Assignment 5 Task 1 - Change Int? to Int
// Assignment 5 Task 2 - Change to Codable to enable JSON

struct Theme: Codable {
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
    //卡牌数
    var noOfPairs: Int
    //Json
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
}

let themes: [Theme] = [
    Theme(
        name: "Halloween",
        colorRGB:  UIColor.orange.rgb,
        colors: "orange",
        emojis: ["👻","🎃","🕷","🧟‍♂️","🧛🏼‍♀️","☠️","👽","🦹‍♀️","🦇","🌘","⚰️","🔮"],
        noOfPairs: 8),
    Theme(
        name: "Flags",
        colorRGB: UIColor.red.rgb,
        colors: "red",
        emojis: ["🇸🇬","🇯🇵","🏴‍☠️","🏳️‍🌈","🇬🇧","🇹🇼","🇺🇸","🇦🇶","🇰🇵","🇭🇰","🇲🇨","🇼🇸"],
        noOfPairs: 10),
    Theme(
        name: "Animals",
        colorRGB:  UIColor.green.rgb,
        colors: "green",
        emojis: ["🦑","🦧","🦃","🦚","🐫","🦉","🦕","🦥","🐸","🐼","🐺","🦈"],
        noOfPairs: 6),
    Theme(
        name: "Places",
        colorRGB:  UIColor.purple.rgb,
        colors: "purple",
        emojis: ["🗽","🗿","🗼","🎢","🌋","🏝","🏜","⛩","🕍","🕋","🏯","🏟"],
        noOfPairs: 8),
    Theme(
        name: "Sports",
        colorRGB:  UIColor.blue.rgb,
        colors: "blue",
        emojis: ["🤺","🏑","⛷","⚽️","🏀","🪂","🥏","⛳️","🛹","🎣","🏉","🏓"],
        noOfPairs: 8),
    Theme(
        name: "Foods",
        colorRGB:  UIColor.yellow.rgb,
        colors: "yellow",
        emojis: ["🌮","🍕","🍝","🍱","🍪","🍩","🥨","🥖","🍟","🍙","🍢","🍿"],
        noOfPairs: 10)
]

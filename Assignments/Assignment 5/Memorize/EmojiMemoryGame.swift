//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/7/9.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

//why use class instead of struct
//1.easy to share
//2.privacy

//a viewmodel:it's a portal between the views and models
//类:ObservabableObkect only for class
class EmojiMemoryGame: ObservableObject{
    //类变量 = MemoryGame
    @Published private var model: MemoryGame<String>
    //this propert change to send Objectwillchange.send()
    
    //主题变量 = theme
    private var theme = themes.randomElement()!
    
    init(){
        model =  EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    //MARK: - static func to create 构造函数
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        //let theme: Array<Array<String>> = [["Hollywood🎃","orange"],["Emoji😺","yellow"],["Animal🐵","pink"],["Sport🏀","blue"],["Food🍔","red"],["Flag🏳️","purple"]]
        //var emojis: Array<Array<String>> = [["👻","🎃","🧙🏻‍♂️","👾","🤖","🤡"],["😺","😸","😹","😻","🙀","😽"],["🐱","🐶","🐹","🐷","🐔","🐵"],["🤺","🪂","⛹️","⛷","🏄‍♂️","🏊‍♂️"],["🥞","🌮","🍣","🍦","🍩","🥐"],["🇨🇳","🇨🇦","🇳🇱","🇬🇧","🇫🇮","🇺🇸"]]
        //let pairs:Int = 6
        //let themes = Int.random(in: 0...4)
        let emojis: Array<String> = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.noOfPairs, cardContentFactory: { index in
            //let number = emojis[themes].count
            //let index = Int.random(in: 0..<number)
            //let emojiInIndex: String = emojis[themes][index]
            //emojis[themes].remove(at: index)
            return emojis[index]
        })
    }
    
    //MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var numberOfPairs: Int {
        self.theme.noOfPairs
    }
    
    var score: Int{
        model.score
    }
    
    var themename: String{
        self.theme.name
    }
    
    var themeColor: String{
        self.theme.colors
    }
    
    var countDown: Int{
        Int.init(model.countDown)
    }

    //MARK: - Intents(s)
    
    func choose(card: MemoryGame<String>.Card){
        objectWillChange.send()
        model.choose(card)
    }
    
    func restart(){
        theme = themes.randomElement()!
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
        print("New Game:\(theme)")
    }
}

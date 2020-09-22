//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import Foundation

//EmojiArt结构
struct EmojiArt: Codable{
    //imageURL
    var backgroundURL: URL?
    //emojis
    var emojis = [Emoji]()
    
    //Emoji结构
    struct Emoji: Identifiable, Codable, Hashable{
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int
        
        //private in this file
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!){
            self = newEmojiArt
        } else{
            return nil
        }
        
    }
    
    init() {}
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    //有多少个Emoji
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}

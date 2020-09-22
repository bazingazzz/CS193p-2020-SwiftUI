//
//  Themes.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/18.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme {
    
    // The Theme table
    var themeList : [ThemeItem]
    
    var themeCount : Int {
        themeList.count
    }
    
    mutating func addTheme() {
         // a new empty entry
        self.themeList.append(ThemeItem(name: "Default", colorRGB: UIColor.orange.rgb, colors: "orange", emojis: ["👻"], DeletedEmojis: [], noOfPairs: 1))
    }
    
    // delete entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
    mutating func deleteThemes(offsets: IndexSet) {
        self.themeList.remove(atOffsets: offsets)
    }
    
    // move entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
   mutating func moveThemes(from: IndexSet, to: Int) {
       self.themeList.move(fromOffsets: from, toOffset: to)
   }
    
    // store score values in User Defaults
   mutating func storeScore(theme : ThemeItem, scoreCount : Int){
        if let themeNo = self.themeList.firstIndex(matching: theme) {
            self.themeList[themeNo].lastScore = scoreCount
            self.themeList[themeNo].bestScore = max(scoreCount, self.themeList[themeNo].bestScore)
        }
    }
    
    // store themeItem object in User Defaults
    mutating func storeThemeItem(theme : ThemeItem){
        if let themeNo = self.themeList.firstIndex(matching: theme) {
            //print("StoreThemeItem:\(theme)")
            //print("StoreThemeItemTochange:\(self.themeList[themeNo])")
            self.themeList[themeNo].name = theme.name
            self.themeList[themeNo].emojis = theme.emojis
            self.themeList[themeNo].DeletedEmojis = theme.DeletedEmojis
            self.themeList[themeNo].noOfPairs = theme.noOfPairs
            self.themeList[themeNo].colorRGB = theme.colorRGB
            self.themeList[themeNo].colors = theme.colors
        }
    }
    
    let defaultGameDataFname = "MemorizeThemes.json"
    
    //Decodes json file into themeList array
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        // the bundle object that contains the current executable
        // Returns the file URL for the resource file identified by the specified name and extension and residing in the bundle directory.
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: fileUrl)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    //Encodes themeList array into json format, and returns it
    func json<T: Encodable>( themeList : T) ->Data  {
        var json : Data
        // encode the theme List into json
        do {
            let encoder = JSONEncoder()
            json = try encoder.encode(themeList)
        } catch {
            fatalError("Couldn't encode themeList as \(T.self):\n\(error)")
        }
        return json
    }
    
    // init with loading from data file, if failable initializer didi not work
    init () {
        self.themeList = Theme.load(defaultGameDataFname)
    }
    
    //create by reading from JSON input data, failable initializer
    init?(json: Data?) {
        if json != nil, let newThemeList = try? JSONDecoder().decode([ThemeItem].self, from: json!) {
            // replace self from JSON input
            self.themeList = newThemeList
        } else {
            return nil
        }
    }
    
//    // store score values in User Defaults
//   mutating func storeScore(theme : Theme.ThemeItem, scoreCount : Int){
//        if let themeNo = self.themeList.firstIndex(matching: theme) {
//            self.themeList[themeNo].lastScore = scoreCount
//            self.themeList[themeNo].bestScore = max(scoreCount, self.themeList[themeNo].bestScore)
//        }
//    }
//    // store themeItem object in User Defaults
//    mutating func storeThemeItem(theme : Theme.ThemeItem){
//        if let themeNo = self.themeList.firstIndex(matching: theme) {
//            self.themeList[themeNo].themeName = theme.themeName
//            self.themeList[themeNo].themeEmojis = theme.themeEmojis
//            self.themeList[themeNo].themeColor = theme.themeColor
//            self.themeList[themeNo].noOfPairsOfCards = theme.noOfPairsOfCards
//            self.themeList[themeNo].bonusTimeLimit = theme.bonusTimeLimit
//        }
//    }
}

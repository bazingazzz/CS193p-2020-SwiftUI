//
//  ThemesStore.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/26.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class ThemesStore: ObservableObject {
    
    private var ThemesStoreName: String
    
    //@Published var choosetheme: ThemeItem = .defaultThemeItem
    
    //@Published var choosetheme: Theme
    
    //private var autosavechoosetheme: AnyCancellable?
    
    private var autosavetheme: AnyCancellable?
    
    //let MemorizeLastSessionData = "Memorize.State"
    let MemorizeLastSessionData = "MemoryGameThemes.State"
    
    @Published var themes: Theme
    
//    {
//        themesNames.keys.sorted { themesNames[$0]! < themesNames[$1]! }
//    }
    
    //private var autosave: AnyCancellable?
    
    //@Published private var themesNames = [Theme:String]()
    
    init(named name: String = "Themes") {
        ThemesStoreName = name
        //let defaultsKey = "MemoryGameThemes.\(name)"
        //let defaultsKeyForThemesNames = "MemoryGameThemes.\(name).themesnames"
        //let defaultsKeyForChooseTheme = "MemoryGameThemes.\(name).choosetheme"
        
        // get themes from data store (last session), if any, else read from input file
        themes = Theme(json: UserDefaults.standard.data(forKey: MemorizeLastSessionData)) ?? Theme()
        // on end of application, store the last session and print to screen
        autosavetheme = $themes.sink{ theme in
            let json : Data = theme.json(themeList : theme.themeList)
            UserDefaults.standard.set(json, forKey : self.MemorizeLastSessionData)
            //print(String(data: json, encoding: .utf8)!)
        }
        
        //themes = [Theme(json: UserDefaults.standard.data(forKey: defaultsKey))] as? [Theme] ?? [Theme]()
        //themes = UserDefaults.standard.object(forKey: defaultsKey) as? [Theme] ?? [Theme()]
        //autosavetheme = $themes.sink{ Theme in
        //    UserDefaults.standard.set(Theme, forKey: defaultsKey)
        //}
        
        //choosetheme = Theme(json: UserDefaults.standard.data(forKey: defaultsKeyForChooseTheme)) ?? Theme()
        //autosavechoosetheme = $choosetheme.sink{ choosetheme in
        //    UserDefaults.standard.set(choosetheme.json, forKey: defaultsKeyForChooseTheme)
        //}
        
        //themesNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKeyForThemesNames))
        //autosave = $themesNames.sink { names in
        //    UserDefaults.standard.set(names.asPropertyList, forKey: defaultsKeyForThemesNames)
        //}
    
        print("Games:\(self.themes)")
    }
    
    var themeList : [ThemeItem] {
        themes.themeList
    }
    
    // a new theme is added to the theme list
    func addTheme() {
        // a new empty entry
        self.themes.addTheme()
    }
    // delete entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
    func deleteThemes(offsets: IndexSet) {
        self.themes.deleteThemes(offsets: offsets)
    }
     // move entries in Theme List. The right objects are picked, because ThemeItem conforms to Identifiable
    func moveThemes(from: IndexSet, to: Int) {
        self.themes.moveThemes(from: from, to: to)
    }
    
//    // store score values in User Defaults
//    func storeScore(theme : ThemeItem){
//        self.themes.storeScore(theme : theme, scoreCount: gameModel?.scoreCount ?? 0)
//    }
    // store themeItem object in User Defaults
    func storeThemeItem(theme : ThemeItem){
        self.themes.storeThemeItem(theme : theme)
    }
    
//    func name(for theme: Theme) -> String {
//        if let index = self.themes.firstIndex(matching: theme){
//            return self.themes[index].returnname()
//        }
//        else{
//            return "Emoji"
//        }
////        if themesNames[theme] == nil {
////            themesNames[theme] = "Emoji"
////        }
////        return themesNames[theme]!
//    }
//
//     func setName(_ name: String, for theme: Theme) {
//        if let index = self.themes.firstIndex(matching: theme){
//            self.themes[index].setname(Newname: name)
//        }
//        //themesNames[theme] = name
//    }
//
//    func addTheme(named name: String = "Emoji") {
//        //添加
//        self.themes.append(Theme())
//        //themesNames[Theme()] = name
//    }
//
//    func removeTheme(_ theme: Theme) {
//        //删除
//        let index = self.themes.firstIndex(matching: theme)
//        self.themes.remove(at: index!)
//        //themesNames[theme] = nil
//    }
}

//extension Dictionary where Key == Theme, Value == String {
//    var asPropertyList: [String:String] {
//        var uuidToName = [String:String]()
//        for (key, value) in self {
//            uuidToName[key.id.uuidString] = value
//        }
//        return uuidToName
//    }
//
//    init(fromPropertyList plist: Any?) {
//        self.init()
//        let uuidToName = plist as? [String:String] ?? [:]
//        for uuid in uuidToName.keys {
//            self[Theme(id: UUID(uuidString: uuid))] = uuidToName[uuid]
//        }
//    }
//}

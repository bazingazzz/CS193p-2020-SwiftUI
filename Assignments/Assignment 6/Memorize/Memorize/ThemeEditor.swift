//
//  ThemeEditor.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/27.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    
    @EnvironmentObject var store: ThemesStore
    
    @Binding var isShowing: Bool
    
    //@Binding var themeItem: ThemeItem
    @State var themeItem : ThemeItem
    
    @State private var themeName: String = ""
    @State private var emojiToAdd: String = ""
    @State private var emojisToAdd: [String] = []
    @State private var uiColor : UIColor = UIColor.clear
    @State private var maxNoOfPairsOfCards = ThemeItem.maxNoOfPairsOfCards
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0){
            HStack{
                Button(action: {
                    self.isShowing = false
                }, label: {Text("Cancel").padding()})
                .padding(.horizontal)
                
                Spacer()
                
                Text("ThemeEditor")
                    .font(.headline)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button(action: {
                    //print(self.themeItem)
                    self.isShowing = false
                    self.themeItem.themeUIColor = self.uiColor
                    self.store.storeThemeItem(theme : self.themeItem)
                }, label: {Text("Done").padding()})
                .padding(.horizontal)
            }
            Divider()
            Form{
                //Theme Name
                Section(header: Text("Theme Name")){
//                    TextField("Themenname", text: $themeItem.name)
                    TextField("ThemeName", text: self.$themeItem.name, onEditingChanged: {
                        began in
                        //not began = ended
                            if !began{
                                //print(self.themeItem.name)
                            }
                        })
//                    EditableText(Theme.name, isEditing: self.editMode.isEditing){ name in
//                        self.store.setName(name, for: Theme)
//                    }
                                                
                }
                
                //Add Emoji
                Section(header: Text("Add Emoji")){
                    HStack{
                        TextField("Emojis", text : $emojiToAdd, onEditingChanged : { began in
                            if !began {
                                addEmojis()
                                }
                            }
                        )
                        Button(action: {
                            if self.emojiToAdd.count != 0{
                                addEmojis()
                            }
                            self.isShowing = true
                        }, label: {
                            Text("Add")
                        })
                    }
                }
                
                //Remove Emoji
                Section(header: emojiheader){
                    VStack{
                        GridView(themeItem.emojis.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size : 40))
                                .onTapGesture{
                                    // remove Emojis, tapped on ...
                                    if self.themeItem.emojis.count > 1 {
                                        if let index = self.themeItem.emojis.firstIndex(of: emoji){
                                            self.themeItem.emojis.remove(at: index)
                                            self.themeItem.DeletedEmojis.append(emoji)
                                            //number of pairs
                                            self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.emojis.count)
                                            if(self.themeItem.noOfPairs > self.maxNoOfPairsOfCards){
                                                self.themeItem.noOfPairs = self.maxNoOfPairsOfCards
                                            }
                                            if(self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards){
                                                self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                                            }
                                        }
                                    }
                                    
//                                    // remove Emojis, tapped on ...
//                                    self.themeItem.themeEmojis = self.themeItem.themeEmojis.replacingOccurrences(of: emoji, with: "")
//                                    if self.themeItem.themeEmojis.count == 0 {
//                                        //... however, must not empty emoji list
//                                        self.themeItem.themeEmojis = Theme.ThemeItem.noEmojis
//                                    }
//                                    // reduce the number of cards to be played to a maximumum of the ones remaiining
//                                    self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.themeEmojis.count)
//                                    if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards{
//                                        self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
//                                    }
                                }
                        }
                        .frame(width : 300, height : 200 )
                    }
                }
                
                Section(header: emojiAddheader){
                    VStack{
//                        GridView(themeItem.DeletedEmojis.map { String($0) }, id: \.self) { emoji in
//                            Text(emoji)
//                                .font(Font.system(size : 40))
//                        }
//                        .frame(width : 300, height : 50 )
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(self.themeItem.DeletedEmojis.map { String($0) }, id: \.self) { emoji in
                                    Text(emoji)
                                        .font(Font.system(size : 40))
                                        .onTapGesture{
                                            if let index = self.themeItem.DeletedEmojis.firstIndex(of: emoji){
                                                self.themeItem.DeletedEmojis.remove(at: index)
                                                self.themeItem.emojis.append(emoji)
                                                
                                                //number of pairs
                                                self.maxNoOfPairsOfCards = self.maxNoOfPairsOfCards + 1
                                                if(self.themeItem.noOfPairs > self.maxNoOfPairsOfCards){
                                                    self.themeItem.noOfPairs = self.maxNoOfPairsOfCards
                                                }
                                                if(self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards){
                                                    self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        .frame(width : 300, height : 50 )
                    }
                }
                
                
                //Card Count
                Section(header: Text("Card Count")){
                    HStack{
                        Stepper("\(themeItem.noOfPairs)", value: $themeItem.noOfPairs, in: 1...self.maxNoOfPairsOfCards)
//                        Stepper(onIncrement: {
//
//                        }, onDecrement: {
//
//                        }, label: {EmptyView()})
                    }
                }
                
                //Color Select
                Section(header: Text("Color")){
                    HStack {
                            Spacer()
                            ThemeColorView(uiColor: $uiColor)
                            Spacer()
                        }
                }
            }
            .onAppear{
                //初始化
                self.maxNoOfPairsOfCards = min(self.maxNoOfPairsOfCards, self.themeItem.emojis.count)
                if self.themeItem.noOfPairsOfCards > self.maxNoOfPairsOfCards{
                    self.themeItem.noOfPairsOfCards = self.maxNoOfPairsOfCards
                }
                if self.themeItem.noOfPairs > self.maxNoOfPairsOfCards{
                    self.themeItem.noOfPairs = self.maxNoOfPairsOfCards
                }
                self.uiColor = self.themeItem.themeUIColor
            }
        }
    }

    let fontSize: CGFloat = 40
    
    private var emojiheader: some View {
        HStack{
            Text("Emojis")
            Spacer()
            Text("Tap emoji to exclude")
        }
    }
    
    private var emojiAddheader: some View {
        HStack{
            Text("Deleted Emojis")
            Spacer()
            Text("Tap emoji to include")
        }
    }
    
    func addEmojis(){
        // here we have a couple of new emojis ...
        self.emojisToAdd = self.emojiToAdd.compactMap{"\($0)"}
        for emoji in self.emojisToAdd{
            self.themeItem.emojis.append(emoji)
        }
        print(self.themeItem.emojis)
        // ...and we want to make sure we increase the ones to be played accordingly
        self.maxNoOfPairsOfCards = self.maxNoOfPairsOfCards + self.emojisToAdd.count
        //self.themeItem.noOfPairsOfCards = self.themeItem.noOfPairsOfCards + self.emojisToAdd.count
        //self.themeItem.noOfPairs = self.themeItem.noOfPairs + self.emojisToAdd.count
        self.emojiToAdd = ""
        self.emojisToAdd.removeAll()
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(isShowing: Binding.constant(true), themeItem:.defaultThemeItem)
            .environmentObject(ThemesStore())
    }
}

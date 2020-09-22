//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/26.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct ThemeChooserView: View {
    
    @EnvironmentObject var store: ThemesStore
    
    @State var chosenThemeItem : ThemeItem = .defaultThemeItem
        
    @State private var editMode: EditMode = .inactive
    
    @State private var showThemeEditor = false
    
    var body: some View {
        NavigationView{
            
            List{
                ForEach(store.themeList, id: \.self){ themeItem in
                    NavigationLink(destination: EmojiMemoryGameView(Game: EmojiMemoryGame(theme: themeItem))){
                        NavigationRow ( themeProfileIsRequested  : self.$showThemeEditor,
                                        chosenThemeItem : self.$chosenThemeItem,
                                        editMode : self.$editMode,
                                        themeItem : themeItem
                                        )
                    }
//                        .navigationBarTitle(themeItem.name)){
//                                Text("\(themeItem.name)")
//                            EditableText(Theme.name, isEditing: self.editMode.isEditing){ name in
//                                self.store.setName(name, for: Theme)
//                            }
//                        }
                        .onAppear(){
                            self.chosenThemeItem = themeItem
                        }
                        .foregroundColor(Color(themeItem.themeColor))
                }
                
//                .onDelete{ indexSet in
//                    indexSet.map { self.store.themes[$0] }.forEach{ theme in
//                        self.store.removeTheme(theme)
//                    }
//                }
                .onDelete(perform: deleteLines)
                .onMove(perform: moveLines)
            }
            //List
            .navigationBarTitle(barTitle, displayMode: .inline)
            .navigationBarItems(leading: addButton, trailing: EditButton())
            .environment(\.editMode, self.$editMode)
            .sheet(isPresented: $showThemeEditor) {
                ThemeEditor(isShowing: self.$showThemeEditor, themeItem: self.chosenThemeItem)
                    .environmentObject(self.store)
            }
        }
        //NavigationView
    }
    
    // have titles depend on mode
    private var barTitle: Text{
        switch editMode {
            case .inactive:
                return Text("Memorize")
            default:
                return Text("Themes")
        }
    }
    
    private var addButton: some View {
        return AnyView(Button(
            action: {
                self.onAdd()
            },
            label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }))
    }
    
    // Edit Mode functions on Theme List.
    func onAdd() {
        self.store.addTheme()
    }
    // ...The right objects are picked, because ThemeItem conforms to Identifiable
    func deleteLines(offsets: IndexSet) {
        withAnimation {
            self.store.deleteThemes(offsets: offsets)
        }
    }
    func moveLines(from: IndexSet, to: Int) {
        withAnimation {
            self.store.moveThemes(from: from, to: to)
        }
    }
    
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        return ThemeChooserView().environmentObject(ThemesStore())
    }
}

// lazy navigation link, will only activate the view, when the link is actually clicked
// this is done by storing the view closure with @escaping parameter
struct NavigationLazyView<Content: View>: View {
    let follow: () -> Content
    init(_ follow:  @autoclosure @escaping () -> Content) {
        self.follow = follow
    }
    var body: Content {
        follow()
    }
}

// One content line in the navigation list. Update chosenThemeItem if selected by user
struct NavigationRow : View{
    
    @Binding var themeProfileIsRequested : Bool
    @Binding var chosenThemeItem : ThemeItem
    @Binding var editMode : EditMode
    
    var themeItem : ThemeItem
    
    let frameWidth : CGFloat = 100
    
    var numberOfEmoji: Int{
        if self.themeItem.emojis.count > 3 {
            return 3
        }
        else{
            return self.themeItem.emojis.count
        }
    }
    
    var someemoji: ArraySlice<String>{
        self.themeItem.emojis.prefix(numberOfEmoji)
    }
    
    @ViewBuilder
    private func numberOfParis() -> some View {
        if (self.themeItem.noOfPairs == self.themeItem.emojis.count) {
            Text("All of")
        }
        else {
            Text("\(self.themeItem.noOfPairs)")
                .bold()
            Text("pairs from")
                .padding(-5)
        }
    }

    private func someEmojiToShow() -> some View {
        //let emojicount = self.store.choosetheme.emojis.count
        //let pairscount = self.store.choosetheme.noOfPairs
        return ForEach(self.someemoji.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 15, weight: .light, design: .serif))
                        .padding(-3)
        }
    }
    
    var body: some View {
        HStack{
            if editMode != .inactive {
                ThemeButton
                    .padding()
            }
            VStack{
                HStack{
                    Text("\(self.themeItem.name)")
                        .font(.title)
                        .foregroundColor(self.themeItem.color)
                    Spacer()
                }
                HStack{
                    numberOfParis()
                        .font(.system(size: 15, weight: .light, design: .serif))
                        .layoutPriority(2.0)
                    someEmojiToShow()
                    Spacer()
                }
            }
        }
    }
    
    var ThemeButton: some View{
        ZStack{
            Circle()
                .padding(-5)
                .layoutPriority(1.0)
                .foregroundColor(self.themeItem.color)
            Image(systemName: "pencil")
                .foregroundColor(Color.white)
                .layoutPriority(2.0)
                .imageScale(.small)
                .onTapGesture {
                    self.themeProfileIsRequested = true
                    self.chosenThemeItem = self.themeItem
                }
//                .sheet(isPresented: self.$showThemeEditor, content: {
//                    ThemeEditor(theme: self.$store.choosetheme, isShowing: self.$showThemeEditor)
//                })
        }
        .padding(0)
    }
}


//struct ThemeShow: View {
//    @Binding var theme: Theme
//
//    @ViewBuilder
//    private func numberOfParis() -> some View {
//        if (self.theme.noOfPairs == self.theme.emojis.count) {
//            Text("All of")
//        }
//        else {
//            Text("\(self.theme.noOfPairs) Pairs from")
//        }
//    }
//
//    private func someEmojiToShow() -> some View {
//        //let emojicount = self.store.choosetheme.emojis.count
//        //let pairscount = self.store.choosetheme.noOfPairs
//        return ForEach(self.theme.emojis.map { String($0) }, id: \.self) { emoji in
//                    Text(emoji)
//                        .font(.system(size: 15, weight: .light, design: .serif))
//                        .padding(-5)
//        }
//    }
//
//    var body: some View {
//        VStack{
//            HStack{
//                Text("\(self.theme.name)")
//                    .font(.title)
//                    .foregroundColor(self.theme.color)
//                Spacer()
//            }
//            HStack{
//                numberOfParis()
//                    .font(.system(size: 15, weight: .light, design: .serif))
//                    .layoutPriority(2.0)
//                someEmojiToShow()
//            }
//        }
//    }
//}

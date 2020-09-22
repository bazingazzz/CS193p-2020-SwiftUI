//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by 郑嘉浚 on 2020/8/22.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    //change to binding
    //binding dont need to be initialized
    //bindin can't be private
    @Binding var chosenPalette: String
    
    @State private var showPaletteEditor = false
    //the way of initilizing the state value
//    init(document: EmojiArtDocument) {
//        self.document = document
//        _chosenPalette = State(wrappedValue: self.document.defaultPalette)
//    }
    
    var body: some View {
        HStack{
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: {EmptyView()})
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
                }
                //sheet or popover
                .popover(isPresented: $showPaletteEditor, content: {
                    //$ to a binding is essentially to return self or the binding itself
                    PaletteEditor(chosenPaletter: self.$chosenPalette, isShowing: self.$showPaletteEditor)
                        .environmentObject(self.document)
                        .frame(minWidth: 300, minHeight: 500)
                    })
        }
        .fixedSize(horizontal: true, vertical: false)
//        .onAppear{
//            self.chosenPalette = self.document.defaultPalette
//        }
    }
}

struct PaletteEditor: View {
    
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPaletter: String
    @Binding var isShowing: Bool
    
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View{
        VStack(spacing: 0) {
            ZStack{
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                HStack{
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: {Text("Done").padding()})
                }
            }
            Divider()
            Form{
                Section(header: Text("Palette Name")){
                    TextField("Palette Name", text: $paletteName, onEditingChanged: {
                        began in
                        //not began = ended
                        if !began{
                            self.document.renamePalette(self.chosenPaletter, to: self.paletteName)
                        }   
                        })
                    
                    TextField("Add emoji", text: $emojisToAdd, onEditingChanged: {
                        began in
                        //not began = ended
                        if !began{
                            self.chosenPaletter = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPaletter)
                            self.emojisToAdd = ""
                        }
                        })
                }
                
                Section(header: Text("Remove Emoji")){
                    Grid(items: chosenPaletter.map{ String($0) }, id: \.self){
                            emoji in
                        Text(emoji)
                            .font(Font.system(size: self.fontSize))
                                .onTapGesture {
                                    self.chosenPaletter = self.document.removeEmoji(emoji, fromPalette: self.chosenPaletter)
                            }
                        }
                    .frame(height: self.height)
                }
        }
        .onAppear{
            self.paletteName = self.document.paletteNames[self.chosenPaletter] ?? ""
            }
        }
    }
    var height:CGFloat{
        CGFloat((chosenPaletter.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
}
    

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}

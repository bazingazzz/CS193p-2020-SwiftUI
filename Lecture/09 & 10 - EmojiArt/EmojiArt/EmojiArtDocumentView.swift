//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State private var chosenPalette: String = ""
    
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: self.document.defaultPalette)
    }
    
    var body: some View {
        VStack {
            
            HStack{
                PaletteChooser(document: document, chosenPalette: $chosenPalette)
                    ScrollView(.horizontal) {
                        HStack {
                            //./ means key path
                            ForEach(self.chosenPalette.map { String($0) }, id: \.self) { emoji in
                                Text(emoji)
                                    .font(Font.system(size: self.defaultEmojiSize))
                                    .onDrag { NSItemProvider(object: emoji as NSString) }
                                }
                            }
                        }
//                .onAppear{
//                    self.chosenPalette = self.document.defaultPalette
//                }
                    .layoutPriority(1.0)
            }
//            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                        .gesture(self.TapToDisselecteOrZoom(in: geometry.size))
                    
                    if self.isLoading{
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    }
                    else{
                        ForEach(self.document.emojis) { emoji in
                                Text(emoji.text)
                                    .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                    .border(self.document.SelectedEmoji.contains(emoji) ? Color.black : Color.clear , width:1)
                                    .position(self.position(for: emoji, in: geometry.size))
                                    //select emoji
                                    .gesture(self.tapToSelectGesture(emoji))
                                    //pan emoji
                                    .gesture(self.panEmojiGesture(emoji))
                                    //delete emoji
                                    .gesture(self.longPressToDeleteEmoji(emoji))
                        }
                    }
                }
                //pan picture
                .gesture(self.panGesture())
                //zoom picture or selected emoji
                .gesture(self.zoomGesture())
                //.gesture(self.document.SelectedEmoji.isEmpty ? self.panGesture() : self.panEmojiGesture())
                //.gesture(self.document.SelectedEmoji.isEmpty ? self.zoomGesture() : self.zoomEmojiGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                        self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                    // SwiftUI bug (as of 13.4)? the location is supposed to be in our coordinate system
                    // however, the y coordinate appears to be in the global coordinate system
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
                .navigationBarItems(trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.confirmBackgroundPaste = true
                    }
                    else{
                        self.explainBackgroundPaste = true
                    }
                }, label: {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: self.$explainBackgroundPaste ) {
                            return Alert(title: Text("Paste Background"),
                                         message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document."),
                                         dismissButton: .default(Text("OK")))
                        }
                }))
                    .clipped()
            }
            .zIndex(-1.0)
//            HStack{
//                PaletteChooser(document: document, chosenPalette: $chosenPalette)
//                ScrollView(.horizontal) {
//                    HStack {
//                        //./ means key path
//                        ForEach(self.chosenPalette.map { String($0) }, id: \.self) { emoji in
//                            Text(emoji)
//                                .font(Font.system(size: self.defaultEmojiSize))
//                                .onDrag { NSItemProvider(object: emoji as NSString) }
//                        }
//                    }
//                }
////                .onAppear{
////                    self.chosenPalette = self.document.defaultPalette
////                }
//                .layoutPriority(1.0)
//            }
////            .padding(.horizontal)
        }
        .alert(isPresented: self.$confirmBackgroundPaste) {
            return Alert(title: Text("Paste Background"),
                         message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                         primaryButton: .default(Text("OK")){
                            self.document.backgroundURL = UIPasteboard.general.url
                         },
                         secondaryButton: Alert.Button.cancel())
        }
    }
    
    @State private var explainBackgroundPaste = false
    @State private var confirmBackgroundPaste = false
    
    var isLoading: Bool{
        self.document.backgroundImage == nil && self.document.backgroundURL != nil
    }
    
    private func tapToSelectGesture(_ emoji: EmojiArt.Emoji) -> some Gesture{
        TapGesture(count: 1)
            .onEnded(){
                self.document.SelectOrDisSelectEmoji(emoji)
        }
    }
    
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    
    private func longPressToDeleteEmoji(_ emoji: EmojiArt.Emoji) -> some Gesture{
        LongPressGesture(minimumDuration: 1.0)
            .updating($isDetectingLongPress) { currentstate, gestureState,
                    transaction in
                withAnimation(.linear(duration: 1.0)){
                    gestureState = currentstate
                    transaction.animation = Animation.easeIn(duration: 1.0)
                }
                
            }
            
            .onEnded { finished in
                self.completedLongPress = finished
                self.document.removeEmoji(emoji)
            }
    
    }
    
    
    //@State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale:CGFloat{
        return self.document.steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale){ latestGestureScale, gestureZoomScale, transition in
                if self.document.SelectedEmoji.isEmpty{
                    //zoom picture
                    gestureZoomScale = latestGestureScale
                }
            }
            .onEnded { finalGestureScale in
                if self.document.SelectedEmoji.isEmpty{
                    //zoom picture
                    self.document.steadyStateZoomScale *= finalGestureScale
                }
                else{
                    //zoom selected emoji
                    self.document.SelectedEmoji.forEach { (emoji) in
                        self.document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                }
            }
    }
    
    private func TapToDisselecteOrZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
           .onEnded(){
               withAnimation(.linear(duration: 2.0)){
                   self.zoomToFit(self.document.backgroundImage, in: size)
               }
            }
            .exclusively(before:
                TapGesture(count: 1)
                    .onEnded(){
                        self.document.removeAllSelectedEmoji()
                    }
            )
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0{
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStatePanOffset = CGSize.zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    //@State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        return (self.document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    @State private var EmojisteadyStatePanOffset: CGSize = .zero
    @GestureState private var EmojigesturePanOffset: CGSize = .zero

    private func panEmojiGesture(_ emojis: EmojiArt.Emoji) -> some Gesture {
        let isEmojiPartOfSelection = self.document.SelectedEmoji.contains(emojis)
        
        return DragGesture()
            .updating($EmojigesturePanOffset) { latestDragGestureValue, EmojigesturePanOffset, transaction in
                EmojigesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded { finalDragGestureValue in
            self.EmojisteadyStatePanOffset = (finalDragGestureValue.translation) / self.zoomScale
            if isEmojiPartOfSelection {
                for emoji in self.document.SelectedEmoji {
                    self.document.moveEmoji(emoji, by: self.EmojisteadyStatePanOffset)
                    self.document.SelectOrDisSelectEmoji(emoji)
                }
            }
            else{
                self.document.moveEmoji(emojis, by: self.EmojisteadyStatePanOffset)
            }
        }
    }

    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y:location.y + size.height/2)
        location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

//
//  TopActionBar.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct TopActionBar: View {
    
    @ObservedObject var game: SetGameViewModel
    
    @State private var showingAlert = false
    
    var body: some View {
        HStack {
            Text("Set Game").font(.title2).bold().padding()
            Spacer()
            Button(action: {
                withAnimation (.easeInOut) { showingAlert = true }
            }, label: {
                HStack {
                    Image(systemName: "plus.square.on.square")
                    Text("New Game")
                }.padding()
            }).alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Start a new game?"),
                    primaryButton: .default(Text("New Game")) {
                        withAnimation (.easeInOut) { game.new() }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

//struct TopActionBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TopActionBar()
//    }
//}

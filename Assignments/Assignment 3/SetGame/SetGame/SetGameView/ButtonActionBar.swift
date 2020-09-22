//
//  ButtonActionBar.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct BottomActionBar: View {
    
    @ObservedObject var game: SetGameViewModel
    
    var geometry: GeometryProxy
    
    private let smallerScreenSize: CGFloat = 375.0
    
    @ViewBuilder
    private func getHintText() -> some View {
        if (geometry.size.width >= smallerScreenSize) {
            if (game.matchesInView == 0) { Text("Hint") }
            else { Text("Hint (\(game.matchesInView))") }
        } else { EmptyView() }
    }
    
    @ViewBuilder
    private func getDealText() -> some View {
        if (geometry.size.width >= smallerScreenSize) {
            if (game.remainingCards == 0) { Text("Deal Cards") }
            else { Text("Deal Cards (\(game.remainingCards))") }
        } else { Text("Deal Cards") }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation (.easeInOut) { self.game.hint() }
                }) {
                    HStack {
                        Image(systemName: "questionmark.square.fill")
                        getHintText()
                    }
                    .frame(minHeight: 21)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10.0)
                }.disabled(game.hintDisabled)
                Button(action: {
                    withAnimation (.easeInOut) { self.game.deal() }
                }) {
                    HStack{
                        Image(systemName: "square.stack.3d.up.fill")
                        getDealText()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(buttonRadius)
                }.disabled(game.dealDisabled)
            }
            .padding()
        }
    }
    
    // MARK: - Drawing Constants
    private let buttonRadius: CGFloat = 10.0
}

//struct ButtonActionBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonActionBar()
//    }
//}

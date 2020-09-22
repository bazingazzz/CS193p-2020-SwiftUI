//
//  SetGameHome.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct SetGameHome: View {
    
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        ZStack {
            Color
                .accentColor
                .opacity(backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    TopActionBar(game: self.game)
                    CardGirdHelper(self.game.cards, itemsCount: self.game.playingCardCount, itemRatio: self.cardRatio) { card in
                        GeometryReader { cardGeometry in
                                    Button(action: {
                                        withAnimation (.easeInOut) { self.game.choose(card: card) }
                                    }){
                                        CardView(card)
                                            .transition(AnyTransition.offset(
                                                x: ((geometry.size.width / 2) - (cardGeometry.size.width / 2) - cardGeometry.frame(in: CoordinateSpace.global).origin.x),
                                                y: self.insertAnimationYOffest - geometry.size.height
                                            )
                                            .combined(with: .opacity))
                                            .animation(.easeInOut)
                                    }
                                }
                        .aspectRatio(self.cardRatio, contentMode: .fit)
                        .transition(AnyTransition.asymmetric(insertion: .offset(x: 0, y: -geometry.size.height), removal: .offset(x: 0, y: geometry.size.height)).combined(with: .opacity))
                        .animation(.easeInOut)
                    }
                        .padding([.leading, .trailing])
                BottomActionBar(game: self.game, geometry: geometry)
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let backgroundOpacity: Double = 0.05
    private let cardRatio: CGFloat = 1.5
    private let insertAnimationYOffest: CGFloat = -100
    private let animationDuration: Double = 0.5
    
}

struct SetGameHome_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SetGameHome(game: SetGameViewModel()).previewDevice("iPhone 11")
        }
    }
}

//
//  SetGameView.swift
//  SetGame
//
//  Created by Roland Schmitz on 24.07.20.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject private(set) var game: SetGameViewModel
    var body: some View {
        VStack {
            HStack {
                Text(game.playerCount == 1 ? "Solo" : "\(game.playerCount) Player").font(.headline)
                Spacer()
                Text(game.theme.name).font(.headline)
                Spacer()
                Text("Score: ....").font(.headline)
            }.padding(5)
            Divider()
            Grid(game.openCards) { card in
                CardView(card: card)
                    .padding(5)
                    .transition(AnyTransition.move(edge: Edge.allCases.randomElement()!))
                    .onTapGesture {
                        withAnimation(Animation.easeInOut) {
                            game.choose(card: card)
                        }
                    }
            }.onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0)) {
                    game.deal()
                }
            }

            Divider()
            HStack {

                Button {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        game.newGame()
                        game.deal()
                    }
                } label: {
                    Text("New Game").blueButton()
                }

//                Button {
//                    withAnimation(Animation.easeInOut(duration: 1)) {
//                        game.deal()
//                    }
//                } label: {
//                    Text("Deal").blueButton()
//                }
//
//                Button {
//                    withAnimation(Animation.easeInOut(duration: 1)) {
//                        game.shuffle()
//                    }
//                } label: {
//                    Text("Shuffle").blueButton()
//                }

                Button {
                    withAnimation(Animation.interpolatingSpring(stiffness: 10, damping: 10, initialVelocity: 5)) {
                        game.showHint()
                    }
                    withAnimation(Animation.interpolatingSpring(stiffness: 10, damping: 10, initialVelocity: -5)) {
                        game.hideHint()
                    }
                } label: {
                    Text("Show Hint").blueButton()
                }

                Button {
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        game.showMore()
                    }
                } label: {
                    Text("3 More Cards").blueButton()
                }.disabled(!game.hasDeckCards)
            }.padding(5)
        }
    }
}

struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}

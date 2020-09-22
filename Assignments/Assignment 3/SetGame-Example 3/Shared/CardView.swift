//
//  CardView.swift
//  SetGame
//
//  Created by Roland Schmitz on 24.07.20.
//

import SwiftUI

struct CardView : View {
    let card: SetGameViewModel.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size).position(x: geometry.size.width/2, y: geometry.size.height / 2)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: cardPadding(for: size)).fill(Color(.secondarySystemFill))
            card.content.padding(cardPadding(for: size))
            thumbsImage(for: card.setState)
                .opacity(0.8)
                .font(.system(size: thumbsFontSize(for: size)))

            VStack {
                thumbsImage(for: card.hint)
                    .opacity(0.4)
                    .font(.system(size: thumbsFontSize(for: size) * 1.5 ))
            }
        }
        .aspectRatio(cardAspectRatio, contentMode: .fit)
        .rotationEffect(.degrees(card.isSelected ? 10 : 0))
        .scaleEffect(card.isSelected ? 0.9 : 1)
        //todo: Why is this repeatForever animation behaving bad, when you turn your device while animation is active
        //.animation(card.isSelected ? Animation.easeInOut.repeatForever(autoreverses: true) : .default)
    }

    @ViewBuilder
    func thumbsImage(for setState: SetGameViewModel.SetState) -> some View {
        if setState != .incomplete {
            Image(systemName: setState == .matching ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                .transition(.scale)

        }
    }
    
    func minimumCardEdgeSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height * cardAspectRatio )
    }
    
    func thumbsFontSize(for size: CGSize) -> CGFloat {
        minimumCardEdgeSize(for: size) / 2
    }
    
    func cardPadding(for size: CGSize) -> CGFloat {
        minimumCardEdgeSize(for: size) / 10
    }
    
    let cardAspectRatio: CGFloat = 2/3
}
    
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}

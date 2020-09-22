//
//  CardContent.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct CardContent: View {
    
    //单张卡
    var card: Card
    //卡的高度
    var cardHeight: CGFloat
    
    //初始化函数
    init(of card: Card, cardHeight: CGFloat) {
        self.card = card
        self.cardHeight = cardHeight
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<getNumber(card.number), id: \.self) { _ in
                self.renderShape().aspectRatio(self.symbolAspectRatio, contentMode: .fit)
            }
            .padding([.leading, .trailing], size(of: paddingH))
            .padding([.top, .bottom], size(of: paddingV))
        }
        .foregroundColor(getColor(card.color))
    }
    
    //卡的颜色
    private func getColor(_ cardColor: CardFeature) -> Color {
        switch cardColor {
        case .featureA: return .green
        case .featureB: return .red
        case .featureC: return .purple
        }
    }
    
    //卡的数字
    private func getNumber(_ cardNumber: CardFeature) -> Int {
        switch cardNumber {
        case .featureA: return 1
        case .featureB: return 2
        case .featureC: return 3
        }
    }
    
    //卡的形状
    private func renderShape() -> some View {
        Group {
            switch card.shape {
                case .featureA: renderFilling(){ Dimond() }
                case .featureB: renderFilling(){ Squiggle() }
                case .featureC: renderFilling(){ Capsule() }
            }
        }
    }
    
    //卡的边界
    private func renderFilling<ContentView: Shape>(@ViewBuilder for content: @escaping () -> ContentView) -> some View {
        ZStack {
            switch card.fill {
                case .featureA: EmptyView() // open
                case .featureB: HStripe(stripeSize: size(of: stripeSize)).clipShape(content()) // striped
                case .featureC: content() // solid
            }
            content().stroke(lineWidth: size(of: outline)) // outline for everyone
        }
    }
    
    // MARK: - Drawing Constants
    private func size(of constant: CGFloat) -> CGFloat {
        return constant * cardHeight
    }
    private let symbolAspectRatio: CGFloat = 0.5
    private let paddingH: CGFloat = 0.056
    private let paddingV: CGFloat = 0.17
    private let stripeSize: CGFloat = 0.01
    private let outline: CGFloat = 0.02
}


//struct CardContent_Previews: PreviewProvider {
//    static var previews: some View {
//        CardContent()
//    }
//}

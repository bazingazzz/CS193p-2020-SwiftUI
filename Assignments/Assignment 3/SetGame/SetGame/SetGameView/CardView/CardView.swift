//
//  CardView.swift
//  SetGame
//
//  Created by 郑嘉浚 on 2020/9/17.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    private var card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    // converting constant to CGFloat with relative card height
    private func size(of item: CGFloat, geo: GeometryProxy) -> CGFloat {
        return geo.size.height * item
    }
    
    var body: some View {
        Group {
            if (card.state == .playing) {
                GeometryReader { geo in
                    ZStack {
                        // 默认卡片背景 default card background
                        RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                            .foregroundColor(Color(UIColor.tertiarySystemBackground))
                        RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                            .stroke(lineWidth: self.size(of: self.cardStrokeSizeDefault, geo: geo))
                            .padding(self.size(of: (self.cardStrokeSizeDefault / 2), geo: geo))
                            .foregroundColor(Color(UIColor.separator))
                        
                        // 已经提示的卡的边界 hinted card border
                        if self.card.isHinted {
                            RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                                .stroke(lineWidth: self.size(of: self.cardStrokeSizeChosen, geo: geo))
                                .padding(self.size(of: (self.cardStrokeSizeChosen / 2), geo: geo))
                                .foregroundColor(.blue)
                        }

                        // 已经选择的卡的边界 chosen card border
                        if self.card.isChosen {
                            RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                                .stroke(lineWidth: self.size(of: self.cardStrokeSizeChosen, geo: geo))
                                .padding(self.size(of: (self.cardStrokeSizeChosen / 2), geo: geo))
                                .foregroundColor(.orange)
                        }
                        
                        // 选择了错误的set的卡的边界和背景 chosen a wrong set border and a background
                        if self.card.isWrongSet {
                            Group {
                                RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                                    .opacity(self.cardOpacity)
                                RoundedRectangle(cornerRadius: self.size(of: self.cardCornerRadius, geo: geo))
                                    .stroke(lineWidth: self.size(of: self.cardStrokeSizeChosen, geo: geo))
                                    .padding(self.size(of: (self.cardStrokeSizeChosen / 2), geo: geo))
                            }
                            .foregroundColor(.red)
                        }
                        
                        // 卡的内容card content
                        if self.card.isFlip {
                            CardContent(of: self.card, cardHeight: geo.size.height)
                                .padding(self.size(of: self.cardContentPadding, geo: geo))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let cardCornerRadius: CGFloat = 0.05
    private let cardStrokeSizeDefault: CGFloat = 0.01
    private let cardStrokeSizeChosen: CGFloat = 0.02
    private let cardPadding: CGFloat = 0.005
    private let cardContentPadding: CGFloat = 0.025
    private let cardOpacity: Double = 0.05
}

struct SetGameCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(Card(number: .featureC, color: .featureA, shape: .featureA, fill: .featureA)).preferredColorScheme(.dark).previewLayout(.fixed(width: 300, height: 200))
            CardView(Card(number: .featureC, color: .featureB, shape: .featureB, fill: .featureA)).preferredColorScheme(.dark).previewLayout(.fixed(width: 300, height: 200))
            CardView(Card(number: .featureC, color: .featureC, shape: .featureC, fill: .featureA)).previewLayout(.fixed(width: 300, height: 200))
            CardView(Card(number: .featureA, color: .featureA, shape: .featureA, fill: .featureB)).previewLayout(.fixed(width: 300, height: 200))
            CardView(Card(number: .featureB, color: .featureB, shape: .featureB, fill: .featureB)).previewLayout(.fixed(width: 300, height: 200))
            CardView(Card(number: .featureC, color: .featureC, shape: .featureC, fill: .featureB)).previewLayout(.fixed(width: 300, height: 200))
        }
    }
}

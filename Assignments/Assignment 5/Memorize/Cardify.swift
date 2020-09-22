//
//  Cardify.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/7/23.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    var isFaceUp: Bool{
        rotation < 90
    }
    
    var animatableData: Double{
        get { return rotation }
        set { rotation = newValue }
    }
    
    
    func body(content: Content) -> some View{
        ZStack{
                    //RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient.init(gradient: Gradient.init(colors: [Color.black, self.color]), startPoint: UnitPoint.init(x: 0.0, y: 0.0), endPoint: UnitPoint.init(x: 2.5, y: 0.5)))
                    //RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth).fill(LinearGradient.init(gradient: Gradient.init(colors: [self.color, self.color]), startPoint: UnitPoint.init(x: 0.0, y: 0.0), endPoint: UnitPoint.init(x: 10.0, y: 10.0)))
            Group{
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius)
                .opacity(isFaceUp ? 0 : 1)
            }
            //Card Flipping
            .rotation3DEffect(Angle.degrees(animatableData), axis: (0,1,0))
    }
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View{
    func cardify(isFaceUp: Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

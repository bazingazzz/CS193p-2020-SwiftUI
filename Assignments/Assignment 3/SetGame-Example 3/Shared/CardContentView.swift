//
//  CardContentView.swift
//  SetGame
//
//  Created by Roland Schmitz on 23.07.20.
//

import SwiftUI

struct CardContentView: View {
    let count: Int
    let color: Color
    let shape: AnyShape
    let shading: Double

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size).position(x: geometry.size.width/2, y: geometry.size.height / 2)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        // Text("\(count) \(color.description) \(shading)")
        VStack(spacing: size.height / 9) {
            ForEach(0..<count) { _ in
                ZStack {
                    shape.fill(color).aspectRatio(2.5, contentMode: .fit).opacity(shading)
                    shape.stroke(color, lineWidth: size.width / 20).aspectRatio(2.5, contentMode: .fit)
                }
            }
        }
    }
}

struct CardContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardContentView(count: 1, color: .orange, shape: AnyShape(Capsule()), shading: 0.5)
    }
}

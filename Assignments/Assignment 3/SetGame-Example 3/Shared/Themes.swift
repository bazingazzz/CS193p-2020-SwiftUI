//
//  Themes.swift
//  SetGame
//
//  Created by Roland Schmitz on 24.07.20.
//

import SwiftUI

struct Theme {
    let name: String
    let counts: ClosedRange<Int>
    let colors: [Color]
    let shapes: [AnyShape]
    let shadings: [Double]
}

let standardSetTheme = Theme(
    name: "Standard",
    counts: 1...3,
    colors: [.red, .green, .blue],
    shapes: [AnyShape(Diamond()), AnyShape(Rectangle()), AnyShape(Capsule())],
    shadings: [0, 0.5, 1.0]
)

let beginnerSetTheme = Theme(
    name: "Beginner",
    counts: 1...3,
    colors: [.blue],
    shapes: [AnyShape(Circle()), AnyShape(Rectangle()), AnyShape(Capsule())],
    shadings: [0, 0.5, 1.0]
)

let themes = [standardSetTheme, beginnerSetTheme]

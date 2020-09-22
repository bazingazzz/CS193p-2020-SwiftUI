//
//  AnyShape.swift
//  SetGame
//
//  Created by Roland Schmitz on 23.07.20.
//
import SwiftUI

public struct AnyShape: Shape {
    let pathFactory: (CGRect) -> Path
    
    public init<SomeShape: Shape>(_ shape: SomeShape) {
        self.pathFactory = shape.path(in:)
    }
    
    public func path(in rect: CGRect) -> Path {
        pathFactory(rect)
    }
}


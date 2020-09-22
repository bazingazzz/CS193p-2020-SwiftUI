//
//  Int+times.swift
//  SetGame
//
//  Created by Roland Schmitz on 26.07.20.
//

import Foundation

extension Int {
    func times(repeated code: () -> ()) {
        (0..<self).forEach { _ in code() }
    }
}

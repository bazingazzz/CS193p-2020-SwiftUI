//
//  SetGameApp.swift
//  Shared
//
//  Created by Roland Schmitz on 22.07.20.
//

import SwiftUI

@main
struct SetGameApp: App {
    @StateObject private var viewModel = SetGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetGameView(game: viewModel)
        }
    }
    
    
}

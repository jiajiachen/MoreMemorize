//
//  MoreMemorizeApp.swift
//  MoreMemorize
//
//  Created by Jia Chen on 2024/11/2.
//

import SwiftUI

@main
struct MoreMemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}

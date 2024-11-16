//
//  EmojiMemoryGame.swift
//  MoreMemorize
//
//  Created by Jia Chen on 2024/11/10.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {

  //  private var model = createMemoryGame()
    
    
    typealias Card = MemorizeGame<String>.Card
    
    private static let emojis = ["👻", "🎃","🕷️","😈", "💀", "🕸️","🧙‍♀️","🙀","👹","😱","☠️","🍭"]
    
    private static let themeList = [
        Theme(name: "Vehicles",
              emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜",
              pairNumber: 30,
              color: .green),
        Theme(name: "Sports",
              emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳",
              pairNumber: nil,
              color: .orange),
        Theme(name: "Music",
              emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻",
              pairNumber: 10,
              color: .red),
        Theme(name: "Animals",
              emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔",
              pairNumber: nil,
              color: .cyan,
              colorForGradient:  [Color.red, Color.blue]
            ),
        Theme(name: "Animal Faces",
              emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲",
              pairNumber: 12,
              color: .brown),
        Theme(name: "Flora",
              emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻",
              pairNumber: 10,
              color: .pink),
        Theme(name: "Weather",
              emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪",
              pairNumber: 10,
              color: .purple),
        Theme(name: "Faces",
              emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠",
              pairNumber: nil,
              color: .yellow)
    ]
    
//    private static func createMemoryGame1() -> MemorizeGame<String> {
//        return MemorizeGame(numberOfPairsOfCards: 11) { pairIndex in
//            if emojis.indices.contains(pairIndex) {
//                return  emojis[pairIndex]
//            } else {
//                return "⁉️"
//            }
//            
//                
//        }
//    }
    
    private static func createMemoryGame() -> MemorizeGame<String> {
        let currentTheme = themeList.randomElement()!
        let themeEmojis = Array(currentTheme.emojis).map { String($0) }.shuffled()
        let pairNumber = currentTheme.pairNumber ?? Int.random(in: 4...themeEmojis.count)
        return MemorizeGame(numberOfPairsOfCards: pairNumber, fillColor: currentTheme.color, themeName: currentTheme.name, colorForGradient: currentTheme.colorForGradient) { pairIndex in
            if themeEmojis.indices.contains(pairIndex) {
                return  themeEmojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
        

    }
    
    @Published private var model = createMemoryGame()
    

    
    var cards: Array<Card> {
        return model.cards
    }
    
    var themeName: String {
        return model.themeName
    }
    
    var score: Int {
        return model.score
    }
    
    func resumeScore() {
        model.resumeScore()
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        resumeScore()
        model = EmojiMemoryGame.createMemoryGame()
    }
}

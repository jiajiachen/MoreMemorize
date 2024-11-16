//
//  MemorizeGame.swift
//  MoreMemorize
//
//  Created by Jia Chen on 2024/11/10.
//

import Foundation
import SwiftUI

struct MemorizeGame<CardContent>  where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private(set) var themeName: String
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, fillColor: Color, themeName: String, colorForGradient: [Color]?,cardContentFactory: (Int) -> CardContent) {
        cards = []
        self.themeName = themeName
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a", fillColor: fillColor, colorForGradient: colorForGradient))
            cards.append(Card(content: content, id: "\(pairIndex+1)b", fillColor: fillColor, colorForGradient: colorForGradient))
        }
        shuffle()
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        set {
             cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) }
        }
    }
    // 可以在全局维护选中index数组。
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id} ) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                        cards[chosenIndex].hasBeenSeen = true
                        cards[potentialMatchIndex].hasBeenSeen = true
                    }
                    //indexOfTheOneAndOnlyFaceUpCard = nil
                    
                } else {
//                    for index in cards.indices {
//                       cards[index].isFaceUp = false
//                    }
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                   
                }
              
                cards[chosenIndex].isFaceUp = true
            }
            
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func resumeScore() {
        score = 0
    }
    
    
    struct Card: Identifiable, Equatable{
        
//        static func == (lhs: Card, rhs: Card) -> Bool {
//            return lhs.isFaceUp == rhs.isFaceUp &&
//            lhs.isMatched == rhs.isMatched &&
//            lhs.content == rhs.content
//        
//        }
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: String
        var fillColor: Color = .orange
        var hasBeenSeen: Bool = false
        var colorForGradient: [Color]?
        
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

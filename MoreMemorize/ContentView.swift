//
//  ContentView.swift
//  Assignment1
//
//  Created by Jia Chen on 2024/10/14.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    let travelEmojis = ["🚗", "🚕","✈️","🛺", "🎡", "🚲","🚆","🛩️"]
    let naturalEmojis = ["🐶","🐱","🐸","🐼", "🐵", "🦆", "🦄", "🐝", "🐢", "🦉"]
    let fruitEmojis = ["🍏","🍎","🍐","🍋","🍆","🌽","🍌", "🥝", "🍑"]
   
    @State var emojis: Array<String> = []
    @State var emojiType: String = ""
   
    @State var themeColor: Color?
    @State var themeName = "Theme"
    @State var score = 0
    

    
    var body: some View {
        VStack {
            Text(viewModel.themeName)
                .font(.largeTitle)
            Text("Score:\(String(score))")
                .font(.title)
            
//            ScrollView {
//                if (emojiType != "") {
//                    cards
//                }
//            }
          
            cards
                .animation(.default, value: viewModel.cards)
            
            Spacer()
          //  cardChooser
            Button {
                startNewGame()
            } label: {
                Text("New Game")
            }

            
        }
        
        .padding()
    }
    
    var cards: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: emojis.count,
                size: geometry.size,
                atAspectRatio: 2/3)
            
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
//                ForEach(items) { item in
//                    content(item)
//                        .aspectRatio(aspectRatio, contentMode: .fit)
//                }
//            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card)
                        .padding(4)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                
                }
            }
        }
   
    }
    
    var cardChooser: some View {
        HStack(alignment: .lastTextBaseline) {
            btnChooser(choose: "Map", symbol: emojiType == "Map" ? "map.fill" : "map")
            Spacer()
            btnChooser(choose: "Leaf", symbol: emojiType == "Leaf" ? "leaf.fill" : "leaf")
            Spacer()
            btnChooser(choose: "Carrot", symbol: emojiType == "Carrot" ? "carrot.fill" : "carrot")
               
        }
        .frame(width: 260)
        .imageScale(.large)
        .font(.title2)
    }
    
    func startNewGame() {
        viewModel.startNewGame()
    }
    
    func btnChooser(choose type: String, symbol: String) -> some View {
        Button(action: {
            emojis = []
            if type == "Map" {
                emojiType = "Map"
                let emojiCount = Int.random(in: 4...travelEmojis.count)
                let travelEmojisShuffled = travelEmojis.shuffled()
                var emojiArray: Array<String> = []
                for index in 0..<emojiCount {
                    emojiArray.append(travelEmojisShuffled[index])
                    emojiArray.append(travelEmojisShuffled[index])
                }
                emojis = emojiArray.shuffled()
                themeColor = .purple
            } else if type == "Leaf" {
                emojiType = "Leaf"
                let emojiCount = Int.random(in: 4...naturalEmojis.count)
                let naturalEmojisShuffled = naturalEmojis.shuffled()
                var emojiArray: Array<String> = []
                for index in 0..<emojiCount {
                    emojiArray.append(naturalEmojisShuffled[index])
                    emojiArray.append(naturalEmojisShuffled[index])
                }
                emojis = emojiArray.shuffled()
                themeColor = .green
            } else if type == "Carrot" {
                emojiType = "Carrot"
                let emojiCount = Int.random(in: 4...fruitEmojis.count)
                let fruitEmojisShuffled = fruitEmojis.shuffled()
                var emojiArray: Array<String> = []
                for index in 0..<emojiCount {
                    emojiArray.append(fruitEmojisShuffled[index])
                    emojiArray.append(fruitEmojisShuffled[index])
                }
                emojis = emojiArray.shuffled()
                themeColor = .orange
            }
            print(1)
            
        }, label: {
            VStack {
                Image(systemName: symbol)
                Text(type)
            }
            
        })
    }
    
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        // print(count)
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
        
    }
    
}

struct CardView: View {
//    let content: String
//    @State var isFaceUp: Bool = false
//    let fillColor: Color?
    
    let card: MemorizeGame<String>.Card
    
    init(_ card: MemorizeGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.foregroundStyle(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content).font(.largeTitle)
            }
                .opacity(card.isFaceUp ? 1 : 0)
            base.fill()
                .opacity(card.isFaceUp ? 0 : 1)
        }
            .foregroundStyle(card.fillColor)
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
//        .onTapGesture {
//           isFaceUp.toggle()
//        }
//   
    }
}

#Preview {
    ContentView(viewModel: EmojiMemoryGame())
}


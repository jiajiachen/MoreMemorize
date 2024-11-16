//
//  ContentView.swift
//  Assignment1
//
//  Created by Jia Chen on 2024/10/14.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    

//    @State var emojis: Array<String> = []
//    @State var emojiType: String = ""
//   
//    @State var themeColor: Color?
//    @State var themeName = "Theme"

    

    
    var body: some View {
        VStack {
            Text(viewModel.themeName)
                .font(.largeTitle)
            Text("Score:\(String(viewModel.score))")
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
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: 2/3)
            
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
//                ForEach(items) { item in
//                    content(item)
//                        .aspectRatio(aspectRatio, contentMode: .fit)
//                }
//            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
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
    
    
    func startNewGame() {
        viewModel.startNewGame()
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


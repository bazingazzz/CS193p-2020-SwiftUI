//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/7/8.
//  Copyright © 2020 bazinga. All rights reserved.
//

//swift is a very strongly-typed language = every variable has a specific type
import SwiftUI

//  behavie like a view（is not objective-oriention programming， is funtional programming).
struct EmojiMemoryGameView: View {
    //redraw when Objectwillchange.send()
    @ObservedObject var viewModel: EmojiMemoryGame
    
//    init(Game: EmojiMemoryGame? = nil) {
//        self.viewModel = Game ?? EmojiMemoryGame(theme: themes.randomElement()!)
//    }
    
    init(Game: EmojiMemoryGame) {
        self.viewModel = Game
    }
    
    //property: type
    var body: some View {
        //return text:some view
        //return Text("Hello, World!")
        VStack{
//            Text("Theme:\(self.viewModel.themename)")
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.black)
//                    .padding(2)
                Grid(items: viewModel.cards){ card in
                    //last argument to the funtion can be dismiss 尾随闭包
                    //itearable things should be identifieable 迭代格式必须可识别
                    CardView(card: card, numberOfPairs: self.viewModel.numberOfPairs, color: self.color)
                        .onTapGesture {
                            withAnimation(.linear(duration:0.3)){
                                self.viewModel.choose(card: card)
                                //Reference to property 'viewModel' in closure requires explicit 'self.' to make capture semantics explicit
                            }
                        }
                .padding(5)
                }
                
        //        HStack {
        //            ForEach(viewModel.cards, content: { card in
        //                CardView(card: card)
        //                    .onTapGesture {
        //                        self.viewModel.choose(card: card)
        //                    }
        //            })
        //        }
                    .padding(5)
                    .foregroundColor(self.color)
                    .background(Color.white)
           
            HStack{
                Button(action: {
                    //Card Rearrangement
                    withAnimation(.easeInOut(duration:0.5)){
                        self.viewModel.restart()
                    }
                }) {
                    HStack {
                        Text("New Game")
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    .frame(minHeight: 10)
                    .padding(8)
                    .foregroundColor(Color.white)
                    .background(self.color)
                    .cornerRadius(10.0)
                }
                Text("Score:\(self.viewModel.score)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .padding(2)
//                Text("Time:\(self.viewModel.countDown)")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.black)
//                    .background(Color.white)
//                    .padding(2)
            }
            .padding(5)
        }
    }
    private var color: Color {
        switch viewModel.themeColor {
        case "orange":
            return Color.orange
        case "black":
            return Color.black
        case "blue":
            return Color.blue
        case "gray":
            return Color.gray
        case "pink":
            return Color.pink
        case "purple":
            return Color.purple
        case "red":
            return Color.red
        case "white":
            return Color.white
        case "yellow":
            return Color.yellow
        case "green":
            return Color.green
        default:
            return Color.orange
        }
    }
}

struct CardView: View {
    //all variables have to have an initial value
    var card: MemoryGame<String>.Card
    
    var numberOfPairs: Int
    
    var body: some View{
        GeometryReader(content: { geometry in
            self.body(for : geometry.size)
        })
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration:card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    //zstack or empty view
    @ViewBuilder
    private func body(for size: CGSize) -> some View{
        if card.isFaceUp || !card.isMatched{
            ZStack {
                Group{
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            //Bonus Scoring Pie Animation
                            .onAppear{
                                self.startBonusTimeAnimation()
                                }
                            }
                    else{
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                //Bonus Scoring Pie Animation
                .transition(.identity)
                //funtion(lable:value)
                Text(card.content)
                    .font(Font.system(size: min(size.width, size.height) * fontScaleFactor))
                    //Match Somersault
                    .rotationEffect(Angle.degrees(card.isMatched ? 360:0))
                    .animation(card.isMatched ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false) : .default)
                
            }
            //.modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
            //.aspectRatio(2/3, contentMode: .fit)
            //.font(self.numberOfPairs >= 5 ? Font.title : Font.largeTitle)
            //Card Disappearing on Match
            .transition(AnyTransition.scale)
        }
    }
    //MARK: - Drawing Constants (control panel)
    let color: Color
    private let fontScaleFactor: CGFloat = 0.75
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(theme: ThemesStore.init().themes.themeList.randomElement()!)
        return EmojiMemoryGameView(Game: game)
    }
}

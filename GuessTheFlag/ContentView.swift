//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by OAA on 12/08/2022.
//

import SwiftUI


struct FlagImage: View {

    var name: String
    
    var body: some View {
   
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 20)
    }
}




struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedAnswer = ""
    
    @State private var gameNumber = 0
    
    @State private var gameEnds = false
    
    
    @State private var animationAmounts = [1.0, 1.0, 1.0]
    @State private var rotationAmounts = [0.0, 0.0, 0.0]
    @State private var oppositeRotationAmounts = [0.0, 0.0, 0.0]
    @State private var opacityAmounts = [1.0, 1.0, 1.0]
    @State private var infiniteAnimation = false
    
    var body: some View {
        
        
        
        ZStack {
            
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            
            
            
            VStack {
                
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                
                VStack(spacing: 30) {
                    VStack{
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)

                            withAnimation() {
                                rotationAmounts[number] += 360
                                updateNotChosen(number)
                                }
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        .rotation3DEffect(.degrees(rotationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        .rotation3DEffect(.degrees(oppositeRotationAmounts[number]), axis: (x: 1, y:0.5, z:0.5))
//                        .animation(
//                            .interpolatingSpring(stiffness: 5, damping: 1),
//                            value: animationAmounts[number]
//                        )
                        .opacity( opacityAmounts[number] )
                        .scaleEffect(animationAmounts[number])
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Number of tries: \(gameNumber)")
                
                Spacer()
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong!" {
                Text("That is the flag of \(selectedAnswer).")
            }
            Text("Your score is \(score)")
        }
        .alert("Game has ended!", isPresented: $gameEnds) {
            Button("Reset", action: reset)
        } message: {
            Text("Do you want to play again?")
        }
        
    }
    

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong!"
        }
        gameNumber += 1
        selectedAnswer = countries[number]
        showingScore = true
    }
    
    func askQuestion() {
        
        if gameNumber == 8 {
            gameEnds = true
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        opacityAmounts = [1.0, 1.0, 1.0]
        animationAmounts = [1.0, 1.0, 1.0]
        oppositeRotationAmounts = [0.0, 0.0, 0.0]
        infiniteAnimation.toggle()
    }
    
    
    func reset() {
        gameEnds = false
        score = 0
        gameNumber = 0
        askQuestion()
    }


    func updateNotChosen(_ number: Int) {
        
        let notChosen = [0, 1, 2].filter {$0 != number}
        for i in notChosen {
            opacityAmounts[i] = 0.25
            animationAmounts[i] = 0.75
            oppositeRotationAmounts[i] += 1080
        }
            
    }
    
//    func changeOpacityExcept(_ number: Int) {
//        let lst = [0, 1, 2]
//        let opacityChange = lst.filter { $0 != number}
//        for i in opacityChange { opacityAmounts[opacityChange] = 1}
//    }
    

}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

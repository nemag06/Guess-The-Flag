//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Magomet Bekov on 27.01.2023.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
        .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.white, lineWidth: 4))
        .shadow(color: .red, radius: 15)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia":"Estonia","France":"France","Germany":"Germany","Ireland":"Ireland","Italy":"Italy","Nigeria":"Nigeria","Poland":"Poland","Russia":"Russia","Spain":"Spain","UK":"UK","US":"US"]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
   
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var score = 0
    @State private var opacityAmount = 1.0
    @State private var rotationAmount = 0.0
    @State private var wrongRotationAmount = [0.0, 0.0, 0.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                Spacer()
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.headline)
        
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3, id: \.self) { number in
                    Button(action: {
                        self.opacityAmount = 0.8
                        self.answerTapped(number)
                    }) {
                        FlagImage(image: self.countries[number])
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown Flag"]))
                    }
                    .opacity(number == self.correctAnswer ? 1 : self.opacityAmount)
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0),
                                      axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(self.wrongRotationAmount[number]),
                                      axis: (x: 0, y: 1, z: 0))
                }
                
                Text("SCORE: \(score)")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    
    func answerTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "CORRECT!"
            scoreMessage = "Your score is: \(score)"
            rotationAmount = 0.0
            
            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                self.rotationAmount = 360
            }
        } else {
            score -= 1
            scoreTitle = "WRONG!"
            scoreMessage = "That's the flag of \(countries[number])\nYour score is: \(score)"
            
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 120, damping: 40, initialVelocity: 200)) {
                self.wrongRotationAmount[number] = 1
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation(.easeInOut) {
            self.opacityAmount = 1.0
        }
        self.rotationAmount = 0.0
        wrongRotationAmount = Array(repeating: 0.0, count: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

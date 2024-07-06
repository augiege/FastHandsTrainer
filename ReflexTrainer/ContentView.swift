////
////  ContentView.swift
////  ReflexTrainer
////
////  Created by Augie Ge on 1/14/24.
////
//

import SwiftUI
import AVFoundation

struct KeepScreenOnModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

extension View {
    func keepScreenOn() -> some View {
        self.modifier(KeepScreenOnModifier())
    }
}

struct ContentView: View {
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @State private var isSpeaking = false
    @State private var speakTimer: Timer?
    @State private var autoStopTimer: Timer?
    @State private var autoStopMinutes: Double = 1  // Default value, or you can make it a user input
    @State private var timerInterval: Double = 1.0 // Default timer interval
    @State private var intervalSpeed: Double = 0.0 // Default interval speed
    @State private var showAlert = false

    let intervalWords: [Double: String] = [
        -3.0: "Slowest",
        -2.0: "Slower",
        -1.0: "Slow",
         0.0: "Normal",
         1.0: "Fast",
         2.0: "Faster",
         3.0: "Fastest"
    ]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 40) {
                    
                    Spacer().frame(height: 10)
                    
                    HStack(spacing: 100) {
                        NavigationLink(destination: TestView()) {
                            Image("information_icon")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        
                        Button(action: {
                            showAlert = true
                        }) {
                            Image("thumb_up_icon")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Rate This App"),
                                message: Text("If you enjoy using this app, would you mind taking a moment to rate it?"),
                                primaryButton: .default(Text("Rate App"), action: {
                                    // Replace with your app's actual App Store link
                                    if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                                        UIApplication.shared.open(url)
                                    }
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding(.top, 40)
                    
//                    Spacer()
                    
                    VStack(spacing: 20) {
                        TextField("Minutes", value: $autoStopMinutes, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .padding()

                        Text("Speed: \(intervalWords[intervalSpeed] ?? "Standard")")
                        Slider(value: $intervalSpeed, in: -3.0...3.0, step: 1)
                            .padding()

                        Button("Start") {
                            startSpeaking()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Stop") {
                            stopSpeaking()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(maxWidth: geometry.size.width * 1, maxHeight: geometry.size.height * 0.6)
                    
                    Spacer(minLength: 20)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .edgesIgnoringSafeArea(.all)
            }
            .keepScreenOn()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func startSpeaking() {
        configureAudioSession()

        if (!isSpeaking) {
            isSpeaking = true
            speakTimer = Timer.scheduledTimer(withTimeInterval: timerInterval - intervalSpeed * 0.13, repeats: true) { _ in
                speakRandomNumber()
            }

            autoStopTimer = Timer.scheduledTimer(withTimeInterval: Double(autoStopMinutes * 60), repeats: false) { _ in
                stopSpeaking()
            }
        }
    }

    func stopSpeaking() {
        if (isSpeaking) {
            isSpeaking = false
            speakTimer?.invalidate()
            autoStopTimer?.invalidate()
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    func speakRandomNumber() {
        let number = Int.random(in: 1...5)
        let speechUtterance = AVSpeechUtterance(string: "\(number)")
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

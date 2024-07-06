//
//  TestView.swift
//  ReflexTrainer
//
//  Created by Augie Ge on 5/20/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Text("Fast Hands Trainer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            Text("is an application designed to help improve hand speed and reflexes through a basic interactive exercise. Ideal for athletes in fast-paced sports, it can enhance daily training and warm-up routines.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

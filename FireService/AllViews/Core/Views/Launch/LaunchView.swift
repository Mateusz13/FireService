//
//  LaunchView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 27/08/2023.
//

import SwiftUI

struct LaunchView: View {
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("LaunchScreen")
                .resizable()
                .scaledToFit()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.spring()) {
                    showLaunchView = false
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}

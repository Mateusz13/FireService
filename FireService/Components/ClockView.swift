//
//  ClockView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 08/02/2024.
//

import SwiftUI

struct ClockView: View {
    
    @State private var timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) private var scenePhase
    @State private var currentTime: String = ""
    
    var body: some View {
        Text(currentTime)
            .bold()
            .frame(minWidth: 75)
            .onReceive(timer2) { _ in
                self.currentTime = Date().getFormattedDateToHHmmSS()
            }
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase ==  .active {
                    timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                }
            }
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase ==  .background {
                    timer2.upstream.connect().cancel()
                }
            }
    }
}

#Preview {
    ClockView()
}

//
//  TimersRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2024.
//

import SwiftUI
import Combine


struct TimersRowView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var vm: CoreViewModel
    @StateObject var timersVM: TimersRowViewModel
    @Binding var rota: Rota
    @Binding var endButtonActive: Bool
    @Binding var startOrCalculateButtonActive: [Bool]
    @State private var endConfirmationAlert: Bool = false
    @State private var number: Int = 0
    
    var body: some View {
        HStack() {
            if (0...12600).contains(timersVM.rotaTimers.duration ?? 0) {
                Text(timersVM.rotaTimers.duration?.asString(style: .abbreviated) ?? "0:00")
                    .frame(minWidth: 69)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 3)
                    .background((300...330).contains(timersVM.rotaTimers.duration ?? 0) ? .green : .clear)
            } else {
                Text("0:00")
                    .foregroundColor(.blue)
                //.frame(height: 33)
                    .frame(minWidth: 69)
                    .padding(.horizontal, 3)
            }
            if endButtonActive == false {
                Text("Zakończono: \(vm.rotas[rota.number].exitTime?.getFormattedDateToHHmm() ?? "error")")
                    .font(.subheadline)
                    .frame(minHeight: 33)
                    .foregroundColor(.secondary)
            } else {
                Button {
                    endConfirmationAlert = true
                    number = rota.number
                } label: {
                    Text("Zakończ")
                }
                .font(.subheadline)
                .buttonStyle(.bordered)
                .background(.purple)
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.vertical, 4)
                .disabled(startOrCalculateButtonActive[0])
                .alert("Zakończyć?", isPresented: $endConfirmationAlert) {
                    Button("Tak") { vm.endAction(forRota: number) }
                    Button("Nie", role: .cancel) { }
                } message: {
                    if number == 2 {
                        Text("Czy na pewno zakończyć akcję dla Roty RIT?")
                    } else if number < 2 {
                        Text("Czy na pewno zakończyć akcję dla Roty \(number+1)?")
                    } else {
                        Text("Czy na pewno zakończyć akcję dla Roty \(number)?")
                    }
                }
            }
            Text("\(vm.timeToLeaveTitle(forRota: rota.number))\((-12600...12600).contains(timersVM.rotaTimers.remainingTime ?? 12601) ? timersVM.rotaTimers.remainingTime?.asString(style: .abbreviated) ?? "" : "")")
            //.font(.callout)
                .foregroundColor((-3599...300).contains(timersVM.rotaTimers.remainingTime ?? 301) ? .white : .red)
            //.foregroundColor(rota.number == 2 ? .orange : .red)
                .padding(.horizontal, 1)
                .background((-3599...300).contains(timersVM.rotaTimers.remainingTime ?? 301) ? .red : .clear)
            Spacer()
        }
        .onChange(of: startOrCalculateButtonActive) { _ in
            timersVM.updateDurationAndRemainingTime(forRota: rota.number)
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase ==  .active {
                timersVM.updateDurationAndRemainingTime(forRota: rota.number)
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase ==  .background {
                timersVM.timer.upstream.connect().cancel()
            }
        }
    }
}

#Preview {
    TimersRowView(timersVM: TimersRowViewModel(coreVM: CoreViewModel()), rota: .constant(Rota(number: 0)), endButtonActive: .constant(true), startOrCalculateButtonActive: .constant(Array(repeating: true, count: 11)))
        .environmentObject(CoreViewModel())
}

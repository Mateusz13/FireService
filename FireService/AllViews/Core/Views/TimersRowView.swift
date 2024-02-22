//
//  TimersRowView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2024.
//

import SwiftUI
import Combine


struct TimersRowView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    //    @StateObject private var timersVM = TimersRowViewModel()
    @ObservedObject var timersVM: TimersRowViewModel
    @Binding var rota: Rota
    @State private var endConfirmationAlert: Bool = false
    @State private var number: Int = 0
    
    var body: some View {
        HStack() {
            //            if (0...12600).contains(timerVM.rotas[rota.number].duration ?? 0) {
            Text(timersVM.rotas[rota.number].duration?.asString(style: .abbreviated) ?? "0:00")
                .frame(minWidth: 69)
                .foregroundColor(.blue)
                .padding(.horizontal, 3)
            //.background((300...330).contains(vm.rotas[rota.number].duration ?? 0) ? .green : .clear)
            //            } else {
            //                Text("0:00")
            //                    .foregroundColor(.blue)
            //                //.frame(height: 33)
            //                    .frame(minWidth: 69)
            //                    .padding(.horizontal, 3)
            //            }
            if vm.endButtonActive[rota.number] == false {
                Text("Zakończono: \(vm.rotas[rota.number].time?[0].getFormattedDateToHHmm() ?? "error")")
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
                .disabled(vm.startOrCalculateButtonActive[rota.number][0])
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
            Text("\(vm.timeToLeaveTitle(forRota: rota.number))\((-12600...12600).contains(rota.remainingTime ?? 12601) ? rota.remainingTime?.asString(style: .abbreviated) ?? "" : "")")
            //.font(.callout)
                .foregroundColor((-3599...300).contains(rota.remainingTime ?? 301) ? .white : .red)
            //.foregroundColor(rota.number == 2 ? .orange : .red)
                .padding(.horizontal, 1)
                .background((-3599...300).contains(rota.remainingTime ?? 301) ? .red : .clear)
            Spacer()
        }
    }
}

#Preview {
    TimersRowView(timersVM: TimersRowViewModel(), rota: .constant(Rota(number: 0)))
        .environmentObject(CoreViewModel())
}

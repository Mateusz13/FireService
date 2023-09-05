//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI
import UIKit

struct MainView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var vm: CoreViewModel
    @State private var currentTime = ""
    @State private var endConfirmationAlert: Bool = false
    @State private var cleanConfirmationAlert: Bool = false
    @State private var number: Int = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            endLine
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    hideKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    ClockView()
                    Spacer()
                    Text("POWIETRZE DLA ROT")
                        .bold()
                    Spacer()
                }
            }
        }
        .alert(isPresented: $vm.showAlert) {
            getAlert()
        }
        .onAppear {
            NotificationManager.instance.requestAuthorization()
            // Disabling the idle timer when this view appears (do I need this?)
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            // Enabling the idle timer back when this view disappears (do I need this?)
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(CoreViewModel())
    }
}

extension MainView {
    
    
    private var allRotas: some View {
        
        ForEach(vm.rotas) { rota in
            VStack {
                RotaTableView(rota: $vm.rotas[rota.number], startOrCalculateButtonActive: $vm.startOrCalculateButtonActive[rota.number], numberOfFiremans: $vm.numberOfFiremans[rota.number], endButtonActive: $vm.endButtonActive[rota.number], editData: $vm.editData[rota.number])
                HStack() {
                    if (0...12600).contains(vm.rotas[rota.number].duration ?? 0) {
                        Text(vm.rotas[rota.number].duration?.asString(style: .abbreviated) ?? "0:00")
                            .frame(minWidth: 69)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 3)
//                            .background((300...330).contains(vm.rotas[rota.number].duration ?? 0) ? .green : .clear)
                    } else {
                        Text("0:00")
                            .foregroundColor(.blue)
//                            .frame(height: 33)
                            .frame(minWidth: 69)
                            .padding(.horizontal, 3)
                    }
                    if vm.endButtonActive[rota.number] == false {
                        Text("Zakończono: \(vm.rotas[rota.number].time?[0].getFormattedDateToHHmm() ?? "error")")
                            .font(.subheadline)
                            .frame(height: 33)
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
                    Spacer()
                    Text("\(vm.timeToLeaveTitle(forRota: rota.number))\((-12600...12600).contains(rota.remainingTime ?? 12601) ? rota.remainingTime?.asString(style: .abbreviated) ?? "" : "")")
                        .foregroundColor((-3599...300).contains(rota.remainingTime ?? 301) ? .white : .red)
                    //.foregroundColor(rota.number == 2 ? .orange : .red)
                        .padding(.horizontal, 3)
                        .background((-3599...300).contains(rota.remainingTime ?? 301) ? .red : .clear)
                    Spacer()
                    Spacer()
                }
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase ==  .active {
                        print("didBecomeAtive")
                        vm.updateDurationAndRemiaingTime(forRota: rota.number)
                    }
                }
                //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: {_ in
                //                    print("didBecomeAtive")
                //                    vm.updateDurationAndRemiaingTime(forRota: rota.number)
                //                })
                .padding(.horizontal, 2)
            }
        }
    }
    
    private var endLine: some View {
        
        HStack {
            Button {
                withAnimation(.easeIn) {
                    vm.addRota()
                }
            } label: {
                Label("", systemImage: "plus.app.fill")
                    .font(.largeTitle)
            }
            
            .foregroundColor(.green)
            .padding()
//            Button {
//                withAnimation(.easeOut) {
//                    vm.subtractRota()
//                }
//            } label: {
//                Label("", systemImage: "minus.square.fill")
//                    .font(.largeTitle)
//            }
//            
//            .foregroundColor(.red)
//            .padding()
            Button {
                cleanConfirmationAlert = true
            } label: {
                Text("Wyczyść")
            }
            .font(.body)
            .buttonStyle(.bordered)
            .background(.orange)
            .cornerRadius(10)
            .foregroundColor(.black)
            .alert("Zakończyć wszystkie akcje i wyczyścić dane?", isPresented: $cleanConfirmationAlert) {
                Button("Tak", role: .destructive) { vm.reset() }
                Button("Nie", role: .cancel) { }
            }
            Spacer()
        }
    }
    
    private func getAlert() -> Alert {
        
        //        return Alert(
        //            title: Text(alertTitle),
        //            message: Text(alertMessage),
        //            dismissButton: .default(Text("OK")))
        return Alert(
            title: Text("Błąd"),
            message: Text("Wprowadź prawidłowe dane"),
            dismissButton: .default(Text("OK")))
    }
}

struct ClockView: View {
    @EnvironmentObject private var vm: CoreViewModel
    @State private var currentTime: String = ""
    //@State private var currentTime = Date().getFormattedDateToHHmmSS()

    
    var body: some View {
        Text(currentTime)
            .bold()
            .onReceive(vm.timer2) { _ in
                self.currentTime = Date().getFormattedDateToHHmmSS()
            }
    }
}


































//IOS 16:

//                if endDate ?? Date() > Date() {
//                    Text("Pozostały czas: \(timerInterval: Date()...(endDate ?? Date().addingTimeInterval(1)), countsDown: true)")
//                        .foregroundColor(.red)
//                }
//                Text("Pozostały czas: \(timerInterval: Date()...(rota.exitDate ?? Date()), countsDown: true)")
//                    .foregroundColor(.red)


// .onAppear solution:

//Text("Pozostały czas: \(timeToLeave?.asString(style: .abbreviated) ?? "")")
//    .foregroundColor(.red)
//
//    .onAppear
//    {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            if rota.exitTime != nil {
//                timeToLeave! -= 1
//            }
//        }
//
//    }

//Earlier solutions:

//                if let timeToLeave = rota.timeToLeave {
//                    if (-1...3600).contains(timeToLeave) { // we will get alert anyway (vm solution?)

//                    Text("Pozostały czas: \(rota.remainingTime?.asString(style: .abbreviated) ?? "")")
//                        .foregroundColor(.red)

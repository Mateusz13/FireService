//
//  MainView.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 16/02/2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: CoreViewModel
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            allRotas
            Spacer()
        }
        .navigationTitle("MSZP")
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
        .alert(isPresented: $vm.showAlert) {
            getAlert()
        }
        .onAppear {
            NotificationManager.instance.requestAuthorization()
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
                RotaTableView(rotaNumber: rota.number)
                Text("Pozostały czas: \((-3599...3599).contains(rota.remainingTime ?? 3601) ? rota.remainingTime?.asString(style: .abbreviated) ?? "" : "")")
                    .foregroundColor(.red)
                
                
            }
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

//
//  TimersRowViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2024.
//

import Foundation
import Combine


final class TimersRowViewModel: ObservableObject {
    
    @Published var rotas: [Rota]
    private var coreVM: CoreViewModel
    let measurementsNumber: Int = 16 //15 (shouldn't be 11?)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    var numberOfRotas: Int = 2 {
        didSet {
//            saveNumberOfRotas()
            return
        }
    }
    
    init(coreVM: CoreViewModel) {
        self.coreVM = coreVM
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
    }
    
    func addRota() {
        self.rotas.append(Rota(number: numberOfRotas))
    }
    
    func reset() {
        timer.upstream.connect().cancel()
    }
    
    func updateDurationAndRemainingTime(forRota: Int) {
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                //self.rotas[forRota].duration += 1
                //IMPORTANT:
                //                if vm.endButtonActive[forRota] {
                self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                self.rotas[forRota].remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        //            }
            .store(in: &cancellables)
    }
    
    func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
        self.rotas[forRota].time = Array(repeating: Date(), count: measurementsNumber+2) //why (measurementsNumber+2)?
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                //                if vm.endButtonActive[forRota] {
                self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
//                self.rotas[forRota].remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        //            }
            .store(in: &cancellables)
    }
}

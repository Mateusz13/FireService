//
//  TimersRowViewModel.swift
//  FireService
//
//  Created by Mateusz Szafarczyk on 13/02/2024.
//

import Foundation
import Combine

final class TimersRowViewModel: ObservableObject {
    
    @Published var rotaTimers: RotaTimers
    private var coreVM: CoreViewModel
    let measurementsNumber: Int = 11
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    
    init(coreVM: CoreViewModel) {
        self.coreVM = coreVM
        let timersRotas = RotaTimers()
        self.rotaTimers = timersRotas
        print("timersRotas inited")
        print(timersRotas)
    }
    
    func reset() {
        timer.upstream.connect().cancel()
    }
    
    func updateDurationAndRemainingTime(forRota: Int) {
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                //                self.rotas[forRota].duration += 1 (was commented earlier as well)
                if coreVM.endButtonActive[forRota] {
                    self.rotaTimers.duration = Date().timeIntervalSince1970 - (self.rotaTimers.startTime?.timeIntervalSince1970 ?? 0)
                    self.rotaTimers.remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                }
            }
            .store(in: &cancellables)
    }
    
    //    func handleFirstMeasurement(forRota: Int, forMeasurement: Int)
    func handleFirstMeasurement(forRota: Int) {
//        self.rotaTimers.startTime = Array(repeating: Date(), count: measurementsNumber+2)
        self.rotaTimers.startTime = Date()
        
        print(rotaTimers)
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                if coreVM.endButtonActive[forRota] {
                    self.rotaTimers.duration = Date().timeIntervalSince1970 - (self.rotaTimers.startTime?.timeIntervalSince1970 ?? 0)
                    //                self.rotas[forRota].remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                }
            }
            .store(in: &cancellables)
    }
}

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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    
    init(coreVM: CoreViewModel) {
        self.coreVM = coreVM
        let timersRotas = RotaTimers()
        self.rotaTimers = timersRotas
        print("timersRotas inited")
        print(timersRotas)
    }
    
    func updateDurationAndRemainingTime(forRota: Int) {
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                if coreVM.endButtonActive[forRota] {
                    self.rotaTimers.duration = Date().timeIntervalSince1970 - (coreVM.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                    self.rotaTimers.remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                }
            }
            .store(in: &cancellables)
    }
    
    //    func handleFirstMeasurement(forRota: Int, forMeasurement: Int)
    func handleFirstMeasurement(forRota: Int) {
        print(rotaTimers)
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                if coreVM.endButtonActive[forRota] {
                    self.rotaTimers.duration = Date().timeIntervalSince1970 - (coreVM.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                    //                self.rotas[forRota].remainingTime = (coreVM.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
                }
            }
            .store(in: &cancellables)
    }
    
    //    deinit {
    //        timer.upstream.connect().cancel()
    //    }
}

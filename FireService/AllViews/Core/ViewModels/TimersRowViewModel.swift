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
    
    init() {
        let rotas = [Rota(number: 0), Rota(number: 1), Rota(number: 2)]
        self.rotas = rotas
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    
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
                self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        //            }
            .store(in: &cancellables)
    }
    
    func handleFirstMeasurement(forRota: Int, forMeasurement: Int) {
        self.rotas[forRota].time = Array(repeating: Date(), count: 10)
        timer
            .sink { [weak self] _ in
                guard let self = self else { return }
                //                if vm.endButtonActive[forRota] {
                self.rotas[forRota].duration = Date().timeIntervalSince1970 - (self.rotas[forRota].time?[0].timeIntervalSince1970 ?? 0)
                self.rotas[forRota].remainingTime = (self.rotas[forRota].exitDate?.timeIntervalSince1970 ?? 0) - Date().timeIntervalSince1970
            }
        //            }
            .store(in: &cancellables)
    }
}

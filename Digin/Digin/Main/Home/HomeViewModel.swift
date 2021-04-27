//
//  HomeViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    let repository = HomeCompaniesDataRepository(localDataSource: CompaniesLocalDataSource())
    let objectWillChange = PassthroughSubject<HomeCompany, Error>()
    @Published var data: [Company] = []
    private var cancellables: Set<AnyCancellable> = []
    func fetch() {

        repository.fetchCopanies()?
            //.receive(on: DispatchQueue.main)
            .sink { co in
                print("sd \(co)")
            } receiveValue: { homeCompany in
                self.data = homeCompany.data
            }.store(in: &cancellables)

    }
}

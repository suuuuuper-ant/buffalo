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
    let moveToDetailPage = PassthroughSubject<IndexPath, Error>()
    @Published var data: HomeCompany = HomeCompany()
    private var cancellables: Set<AnyCancellable> = []

    func fetch() {

        repository.fetchCopanies()?
            .sink { _ in
            } receiveValue: { homeCompany in
                self.data = homeCompany
            }.store(in: &cancellables)

    }

    func moveToDetailPage(_ indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        moveToDetailPage.send(indexPath)

    }
}

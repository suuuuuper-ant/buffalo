//
//  HomeViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    let repository = HomeCompaniesDataRepository(localDataSource: CompaniesRemoteDataSource())
    let moveToDetailPage = PassthroughSubject<IndexPath, Error>()
    let moveToRandomPick = PassthroughSubject<Void, Error>()
    @Published var data: HomeCompany = HomeCompany()
    private var cancellables: Set<AnyCancellable> = []

    func fetch() {
        repository.fetchCopanies()?.sink(receiveCompletion: { comlete in
            print(comlete)
        }, receiveValue: { homeCompany in
            self.data = homeCompany
            print(self.data.result?.groups[1].contents)
        }).store(in: &cancellables)

    }

    func moveToDetailPage(_ indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        moveToDetailPage.send(indexPath)

    }
}

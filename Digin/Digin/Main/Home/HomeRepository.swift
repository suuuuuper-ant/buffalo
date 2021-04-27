//
//  HomeRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation
import Combine

protocol HomeCompaniesRepository {
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>?
}

final class HomeCompaniesDataRepository: HomeCompaniesRepository {
    private let localDataSource: CompaniesDataSource
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>? {
        return localDataSource.fetchCopanies()
    }

    public init(localDataSource: CompaniesDataSource) {
        self.localDataSource = localDataSource
    }

}

//////////////////

protocol CompaniesDataSource {
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>?
}

public struct CompaniesLocalDataSource: CompaniesDataSource {
    let fileName: String = "HomeDummy"
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>? {

//        func  getDataIn(path: String) throw ->
//
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
          return  AnyPublisher(
                Fail<HomeCompany, Error>(error: URLError(.cannotOpenFile))
            )
        }

//                if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//                    do {
//                        let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                        print(data)
//
//                        let result = try JSONDecoder().decode(HomeCompany.self, from: data)
//                      // print(result)
//
//                      } catch let error {
//                           // handle error
//                       print(error)
//                      }
//                }

        return Just(path)
            .tryMap { try Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }
            .print()
            .decode(type: HomeCompany.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }

}

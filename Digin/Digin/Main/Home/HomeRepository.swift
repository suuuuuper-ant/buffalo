//
//  HomeRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation
import Combine

protocol HomeCompaniesRepository {
    func fetchCopanies() -> AnyPublisher<[Company], Error>
}



//final class HomeCompaniesDataRepository: HomeCompaniesRepository {
//    func fetchCopanies() -> AnyPublisher<[Company], Error> {
//
//    }
//
//
//
//}

//////////////////

protocol CompaniesDataSource {
    func fetchCopanies() -> AnyPublisher<[Company], Error>
}


//public struct CompaniesLocalDataSource: CompaniesDataSource {
//    let fileName: String = "HomeDummy"
//    func fetchCopanies() -> AnyPublisher<[Company], Error> {
//
//
//        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//            do {
//                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//
//
//                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                let result = try JSONDecoder().decode(HomeCompany.self, from: data)
//
//                return JS
//
//              } catch {
//                   // handle error
//              }
//        }
//
//
//    }
//
    
//}

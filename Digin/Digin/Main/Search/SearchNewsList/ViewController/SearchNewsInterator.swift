//
//  SearchNewsInterator.swift
//  Digin
//
//  Created by jinho jeong on 2021/11/22.
//

import Foundation
import Combine
import UIKit
//
//final class SearchNewsInterator: PresetableInterator<SearchNewsPresenter> {
//
//    override init(presenter: SearchNewsPresenter) {
//        super.init(presenter: presenter)
//    }
//
//
//}

protocol SearchNewsInterator {
    func fetchNewsList(keyword: String)
    var presenter: SearchNewsfeedViewController? { get set }
}

final class SearchNewsInteratorImpl: SearchNewsInterator {
    var cancellables: Set<AnyCancellable>
    var searchNewsRepository: SearchNewsRepository
    weak var presenter: SearchNewsfeedViewController?

    init(searchNewsRepository: SearchNewsRepository) {
        self.searchNewsRepository = searchNewsRepository
        self.cancellables = .init()
    }

    func fetchNewsList(keyword: String) {

        searchNewsRepository.fetch(keyword: keyword)?.sink(receiveCompletion: { _ in
            print("error Alert")
        }) { [weak self] result in
            let viewModelList = result.result.map { SearchNewsViewModel.init(model: $0)}
            self?.presenter?.updateList(list: viewModelList)
        }.store(in: &cancellables)
    }

}

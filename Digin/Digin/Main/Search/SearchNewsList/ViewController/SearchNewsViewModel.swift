//
//  SearchNewsViewModel.swift
//  Digin
//
//  Created by jinho jeong on 2021/12/03.
//

import Foundation

struct SearchNewsViewModel {

    var imageURL: String
    var title: String
    var newsInfoString: String

    init(model: NewsfeedContent) {
        self.title = model.title
        self.imageURL = model.imageUrl
        newsInfoString = model.updatedAt.setDate(format: "MM.dd. HH:ss")

    }
}

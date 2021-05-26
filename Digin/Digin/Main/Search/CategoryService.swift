//
//  CategoryService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/20.
//

import Foundation

struct CategoryService: APIServie {

    static func getCategory(completion: @escaping ([CategoryResult]) -> Void) {
        let jsonData = readLocalJSONFile(forName: "CategoryData")

        if let data = jsonData {
            if let parseData = parse(jsonData: data) {

                //print("category: \(parseData)")
                completion(parseData)
            }
        }
    }

    static func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error1: \(error)")
        }
        return nil
    }

    static func parse(jsonData: Data) -> [CategoryResult]? {

        do {
            let decodedData = try JSONDecoder().decode([CategoryResult].self, from: jsonData)
            return decodedData
        } catch {
            print("error2: \(error)")
        }

        return nil
    }

}

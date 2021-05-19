//
//  String_extension.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import Foundation

extension String {

    //데이트 변환
    func setDate(format: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = TimeZone(abbreviation: "KST")
        dateFormatterGet.locale = NSLocale.current
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format

        guard let date = dateFormatterGet.date(from: self) else { return "" }
        return dateFormatterPrint.string(from: date)
    }
}

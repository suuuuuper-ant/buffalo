//
//  Date._extension.swift
//  Digin
//
//  Created by jinho jeong on 2021/08/07.
//

import Foundation

extension DateFormatter {

    func convertBy(format: String, dateString: String, oldFormat: String) -> String {

        let olDateFormatter = DateFormatter()
             olDateFormatter.dateFormat = oldFormat
        guard let oldDate = olDateFormatter.date(from: dateString) else { return "날짜미정" }
        self.dateFormat = format
        let formattingString = self.string(from: oldDate)
        return formattingString
    }

}

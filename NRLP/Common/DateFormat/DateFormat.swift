//
//  DateFormat.swift
//  1Link-NRLP
//
//  Created by VenD on 29/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class DateFormat {
    enum Formatter: String {
        case daySuffixFullMonth = "dd%@ MMMM yyyy" // 23th July 2020
        case dateTimeMilis = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 2020-07-17T11:20:22.040Z
        case pickerFormat = "d MMMM yyyy"
        case advanceStatementFormat = "YYYYMMdd"
        case reverseYearMonthDayFormat = "yyyy-MM-dd"
        case shortDateFormat = "dd-MMM-yy"
        case shortDateFormatWithSpace = "dd MMM yy"
    }

    func formatDateString(dateString: String, fromFormat: Formatter = .dateTimeMilis, toFormat: Formatter = .daySuffixFullMonth) -> String? {
        let date = formatDate(dateString: dateString, formatter: fromFormat)
        return formatDateString(to: date, formatter: toFormat)
    }

    func formatDate(dateString: String, formatter: Formatter = .dateTimeMilis) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = formatter.rawValue
        let formattedDate = dateFormatter.date(from: dateString)
        return formattedDate
    }

    func formatDateString(to date: Date?, formatter: Formatter) -> String? {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = formatter.rawValue
            let formattedDate = dateFormatter.string(from: date)
            return String.init(format: formattedDate, date.daySuffix())
        }
        return nil
    }
    
    func getDateDiff(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

        let seconds = dateComponents.second
        return Int(seconds ?? 0)
    }
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

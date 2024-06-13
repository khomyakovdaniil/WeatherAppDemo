//
//  String + DateFormatting.swift
//  WeatherAppDemo
//
//  Created by  Даниил Хомяков on 13.06.2024.
//

import Foundation

extension String {

    func formatHourlyTime() -> String? {
        let hour = (Int(self) ?? 0) / 100

        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "HH:mm"

        guard let oldDate = olDateFormatter.date(from: "\(hour):00") else { return nil }

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "h a"

        return convertDateFormatter.string(from: oldDate)
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: self) else { return nil }

        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
    }

}

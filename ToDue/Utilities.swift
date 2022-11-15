//
//  Utilities.swift
//  ToDue
//
//  Created by Mavis on 2022/11/14.
//

import Foundation

func getDateFromEvent(event: Event) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = event.year
    dateComponents.month = event.month
    dateComponents.day = event.day
    dateComponents.hour = event.hour
    dateComponents.minute = event.minute
    dateComponents.weekday = event.weekday
    if let date = Calendar.current.date(from: dateComponents) {
        return date
    }
    return nil
}

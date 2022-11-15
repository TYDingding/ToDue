//
//  Structs.swift
//  ToDue
//
//  Created by Yiding Tao on 11/9/22.
//  Structs.swift is used to define all structs

import Foundation

// This is event struct, not finailzed, can be
// modified to make it more developer friendly
// One major concern is to make it easy for calculating
// time remaing. Maybe we can use some API like Date(),
// DateComponents() or DateFormatter()...

struct Event: Codable {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var weekday: Int
    var title: String
    var description: String
    var location: String
    var isComplete: Bool
    var createDate: Date // Use to calculate time bar value
}

enum Weekday: Int {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

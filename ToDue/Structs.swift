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

struct event {
    var year: Int
    var month: Int
    var day: Int
    var weekDay: String
    var title: String
}

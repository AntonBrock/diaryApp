//
//  CalendarVars.swift
//  DiaryApp
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

var day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

struct CalendarVars {
//    let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    let months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let daysOfMonth = ["Пон", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    var daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
}


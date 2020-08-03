//
//  tasks.swift
//  DiaryApp
//
//  Created by Admin on 30.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    var tasks: [Tasks]
}

struct Tasks: Decodable {
    var id: Int
    var date_start: String
    var date_finish: String
    var name: String
    var description: String
}

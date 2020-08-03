//
//  DataManager.swift
//  DiaryApp
//
//  Created by Admin on 31.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

struct DataManager {
    func getData (from file: String) -> [Tasks]? {
       if let url = Bundle.main.url(forResource: file, withExtension: "json") {
             do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData.tasks
             } catch {
                 print("error:\(error)")
             }
        }
        return nil
    }
}

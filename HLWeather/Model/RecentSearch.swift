//
//  RecentSearch.swift
//  HLWeather
//
//  Created by harry on 1/12/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import Foundation

class RecentSearch {
    static let shared = RecentSearch()
    
    private var list: [String]
    private let MAX_COUNT = 10
    private let KEY_LIST = "SearchList"
    
    private init() {
        if let listd = UserDefaults.standard.object(forKey: KEY_LIST) as? [String] {
            self.list = listd
        } else {
            self.list = [String]()
        }
    }
    
    func addEntry(_ input: String) {
        if input.count <= 0 {
            return
        }
        if (self.list.count + 1 > MAX_COUNT) {
            self.list.remove(at: MAX_COUNT-1)
        }
        for s in self.list {
            if s == input {
                return
            }
        }
        self.list.insert(input, at: 0)
        UserDefaults.standard.set(self.list, forKey: KEY_LIST)
        NSLog("new list\n\(self.list)")
    }
    
    func getList() -> [String] {
        return list
    }
    
    func removeAll() {
        self.list.removeAll()
        UserDefaults.standard.set(self.list, forKey: KEY_LIST)
    }
}

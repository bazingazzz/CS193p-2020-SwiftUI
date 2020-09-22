//
//  Array+Identifiable.swift
//  Set Game
//
//  Created by 郑嘉浚 on 2020/8/5.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation

extension Array where Element:Identifiable{
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count{
            if self[index].id == matching.id{
                return index
            }
        }
        //return optional nil
        return nil
    }
}

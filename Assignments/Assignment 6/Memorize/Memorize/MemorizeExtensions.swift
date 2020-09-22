//
//  MemorizeExtensions.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/8/18.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI

extension Array where Element:Identifiable{
//    func firstIndex(matching: Element) -> Int? {
//        for index in 0..<self.count{
//            if self[index].id == matching.id{
//                return index
//            }
//        }
//        //return optional nil
//        return nil
//    }
    
    func firstIndex(matching element: Element) -> Int? {
        return self.firstIndex{$0.id == element.id}
    }
}

extension Array where Element:Identifiable{
    func findUUID(matching: Element) -> Element.ID?{
        for index in 0..<self.count{
            if self[index].id == matching.id{
                return self[index].id
            }
        }
        return nil
    }
}

extension Array{
    var only:Element?{
        count == 1 ? first : nil
    }
}

extension Array{
    var allMatch:Bool {
        count > 0 ? false : true
    }
}

// Color extensions -> Need to import SwiftUI
extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}

extension UIColor {
    public struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }
    
    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    public var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}

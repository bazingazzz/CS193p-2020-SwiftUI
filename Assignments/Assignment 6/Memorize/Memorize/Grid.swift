//
//  Grid.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/7/16.
//  Copyright © 2020 bazinga. All rights reserved.
//

import SwiftUI

//care a little bit about the item
struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    var body: some View {
        GeometryReader{ geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View{
        ForEach(items){ item in
            self.body(for: item, in: layout)
        }
    }
    private func body(for item: Item, in layout: GridLayout) -> some View{
        //使用！将变量variable声明为隐式解析可选，就相当于程序员在声明的时候告诉编译器，确定该变量一定会有值，这样就编译器就不会抛出变量未初始化的错误。虽然躲过了编译器的检查，但是程序真正运行时，由于变量variable未初始化，值为nil，所以程序会crash。
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
            
    }
    
    private func index(of item: Item) -> Int{
        for index in 0..<self.items.count{
            if self.items[index].id == item.id{
                return index
            }
        }
        return 0 //TODO: Done!
    }
}

//struct Grid_Previews: PreviewProvider {
//    static var previews: some View {
//        Grid()
//    }
//}

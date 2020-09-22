//
//  Grid.swift
//  Memorize
//
//  Created by Roland Schmitz on 31.05.20.
//  Copyright © 2020 Roland Schmitz. All rights reserved.
//

import SwiftUI

struct Grid<Item : Identifiable, ItemView : View>: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView

    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }

    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size, itemAspectRatio: 2/3))
        }
    }

    private func body(for layout: GridLayout) -> some View {
        return ForEach(items) { (item: Item) in
            self.body(for: item, in: layout)
        }
    }

    private func body(for item: Item, in layout: GridLayout) -> some View {
        self.viewForItem(item)
            .frame(width: layout.itemWidth, height: layout.itemHeight)
            .position(layout.location(ofItemAt: items.firstIndex(where: { $0.id == item.id })!))
    }

}

struct GridLayout {
    let itemCount: Int
    let size: CGSize
    private let columnRowRatio: Double

    init(itemCount: Int, in size: CGSize, itemAspectRatio: Double = 1/1) {
        self.itemCount = itemCount
        self.size = size
        self.columnRowRatio = Double(size.width / size.height) / itemAspectRatio
    }

    private var estimatedRowCount: Int { Int(sqrt(Double(itemCount - 1) / columnRowRatio )) + 1 }
    var columnCount: Int { (itemCount - 1) / estimatedRowCount + 1 }
    var rowCount: Int { (itemCount - 1) / columnCount + 1 }
    var itemWidth: CGFloat { size.width / CGFloat(columnCount) }
    var itemHeight: CGFloat { size.height / CGFloat(rowCount) }

    func location(ofItemAt itemIndex: Int) -> CGPoint {
        let rowIndex = itemIndex / columnCount
        let columnIndex = itemIndex % columnCount
        return CGPoint(
            x: (CGFloat(columnIndex) + 0.5) * itemWidth,
            y: (CGFloat(rowIndex) + 0.5) * itemHeight
        )
    }
}

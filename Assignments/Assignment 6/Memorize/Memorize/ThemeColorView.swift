//
//  ThemeColorView.swift
//  Memorize
//
//  Created by 郑嘉浚 on 2020/9/22.
//  Copyright © 2020 bazinga. All rights reserved.
//

import Foundation
import SwiftUI
import ColorPickerRing

struct ThemeColorView: View {
    
    @Binding var uiColor : UIColor
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(uiColor.rgb))
                .frame(width: 40, height: 40)
                ColorPickerRing(color: self.$uiColor, strokeWidth: 30)
                    .frame(width: 150, height: 150, alignment: .center)
                
        } //VStack
    } //body
} //View

struct ThemeColorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeColorView(uiColor: .constant(UIColor(UIColor.RGB(red: 1.011, green: 0.330, blue: -0.003, alpha: 1.0))))
    }
}


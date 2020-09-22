//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by 郑嘉浚 on 2020/8/12.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    
    var uiImage: UIImage?
    
    var body: some View{
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}

struct OptionalImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage()
    }
}

//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by 郑嘉浚 on 2020/8/26.
//  Copyright © 2020 CS193p Instructor. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    //editMode
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView{
            List{
                ForEach(store.documents){ document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document)
                        .navigationBarTitle(self.store.name)){
                            EditableText(self.store.name(for: document), isEditing: self.editMode.isEditing){ name in
                                self.store.setName(name, for: document)
                            }
                    }
                }
                .onDelete{ indexSet in
                    indexSet.map { self.store.documents[$0] }.forEach{ document in
                        self.store.removeDocument(document)
                    }
                }
            }
        .navigationBarTitle(self.store.name)
        .navigationBarItems(
            leading: Button(action: {
                self.store.addDocument()
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }),
            trailing: EditButton()
        )
        //give enviorment an obje named editmode
        .environment(\.editMode, self.$editMode)
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
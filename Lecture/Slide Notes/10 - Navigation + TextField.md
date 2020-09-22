# Lecture 10 - Navigation + TextField
## Demo

### PopOvers

* `.popover` for iPads & `.sheet` for iPhones
* `.environmentObject` to pass the Object & `@EnvironmentObject` to receive
* $ to a binding is essentially to return self or the binding itself

```swift
.popover(isPresented: $showPaletteEditor) {
  PaletteEditor(chosenPalette: self.$chosenPalette, isShowing: self.$showPaletteEditor)
      .environmentObject(self.document)			 // Passing an Environment Object
      .frame(minWidth: 300, minHeight: 300)  // For Size
}
```

### TextField

* 3rd Argument `onEditingChange:` to check when TextField has been edited

```swift
TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
    // !began = when editing ends
    if !began {
        self.document.renamePalette(self.chosenPalette, to: self.paletteName)
    }
})
```

### Keypaths

* `private var id: KeyPath<Item,ID>` is essentially KeyPath<Root,Type>

### Navigation Links + List

* Used to link to other Views

* `.navigationBarTitle` to Title 

  ```swift
  ForEach(store.documents) { document in
      NavigationLink(destination: EmojiArtDocumentView(document: document)
          .navigationBarTitle(self.store.name(for: document))  // Bar Title of View
      ) {
          // View
        }
  ```

* To delete from a List, use `.onDelete`

  ```swift
  .onDelete { indexSet in
      indexSet.map { self.store.documents[$0] }.forEach { document in
          self.store.removeDocument(document)
      }
  }
  ```

* To allow editing, use `Editbutton()` or:

  ```swift
  @State private var editMode: EditMode = .inactive
  
  List {
    Editable(self.store.name(for: document),isEditing: self.editMode.isEditing) { name in
        self.store.setName(name, for: document)
    }
  }
  .environment(\.editMode, $editMode)
  ```

### Copy & Paste

* Cannot put 2 `.alert()` together

```swift
if let url = UIPasteboard.general./* type of thing copied (eg. url) */ {
  // do something
}
```

### Alert

```swift
.navigationBarItems(trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.document.backgroundURL = url
                    }
                    else{
                        self.explainBackgroundPaste = true
                    }
                }, label: {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: self.$explainBackgroundPaste ) {
                            return Alert(title: Text("Paste Background"),
                                         message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of your document."),
                                         dismissButton: .default(Text("OK")))
                        }
                }))
```

### Delete NavigationBarItems

```swift
                .onDelete{ IndexSet in
                    IndexSet.map{ self.store.document[$0] }.forEach{ document in
                        self.store.removeDocument(document)
                    }
                }
```

### NavigationBarItems add EditButton

```swift
        .navigationBarItems(
            leading: Button(action: {
                self.store.addDocument()
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }),
            trailing: EditButton()
        )
```

### editMode

```swift
    //editMode
    @State private var editMode: EditMode

        //give enviorment an obje named editmode
        .environment(\.editMode, self.$editMode)


```

### zIndex

```swift
.zIndex(-1.0)

```
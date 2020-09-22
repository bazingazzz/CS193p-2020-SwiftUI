# Lecture 9 - Data Flow
## Property Wrappers
* `@Something` are property wrappers
* PW is just a struct which **provides template behaviour** for the vars they wrap
* Access `projectedValue` using `$`

```swift
@Published var emoji: EmojiArt = EmojiArt()

// is the same as ...
struct Published {
  var wrappedValue: EmojiArt
  var projectedValue: Publisher<EmojiArt, Never> // Never Fails
}

// makes this vars available
var _emojiArt: Published = Published(wrappedValue: EmojiArt())
var emoji: EmojiArt {
  get { _emojiArt.wrappedValue }
  set { _emojiArt.wrappedValue = newValue }
}
```

### @State

* Stores the wrappedValue in the heap
* `$` is a Binding to the value in the heap

### @ObservedObject
* Redraws the View when it receives a change
* `$` is a Binding to ViewModel

### @Binding
* Bound to something else (ie. gets and sets the value from some other source)
* `$` is a Binding to self
* It is about having a **single source of data**
* Binding to a constant with `Binding.constant(value)`

### @EnvironmentObject
* Same as @ObseveredObject but passed in a different way
* **Visible to all Views in your body**
* One @EnvironmentObject wrapper per ObservableObject type per View
* wrappedValue obtained via `.environmentObject()`

```swift
let myView = MyView().environmentObject(theViewModel)
// ...vs...
let myView = MyView(viewModel: theViewModel)

// In the View
@EnvironmentObject var viewModel: ViewModelClass
// ...vs...
@ObservedObject var viewModel: ViewModelClass
```

### @Environment

* Unrelated to @EnvironmentObject - Manages the Environment
* `@Environment(keypath)`



## Publishers

* Object that emits **values** and a **possible failure object** if it fails `Publisher<Output, Failure>`
* Failure can be Never

### Listening to Publishers

* Execute a `.sink` closure whenever the Publisher publishes
* Returned thing implements the `Cancellable` protocol
  * you can `.cancel()` it to stop listening
  * as long as `var cancellable` exists the `.sink` subscriber will be alive

```swift
cancellable = $myPublisher.sink(
	receiveCompletion: { result in ...}  // Can ignore if failure is never
  receiveValue: { thingThePublisherPublishes in ...}
)
```

* A View can listen to a Publisher too `.onReceive(publisher){ }`



## Demo

* Get / Set vars can be substitutes for functions

* For Publishers in Inits, `var Cancellable` necessary for the `.sink` to continue running

  ```swift
  // needs to import Combine
  private var autosaveCancellable: AnyCancellable?
  
  init(id: UUID? = nil) {
      self.id = id ?? UUID()
      let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
      emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
      autosaveCancellable = $emojiArt.sink { emojiArt in
          print("\(emojiArt.json?.utf8 ?? "nil")")
          UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
      }
      fetchBackgroundImageData()
  }
  ```

* To receive Published Objects `$` from View Model, use `.onReceive`

  ```swift
  // View
  .onReceive(self.document.$backgroundImage) { image in
      self.zoomToFit(image, in: geometry.size)
  }
  ```

* Use `EmptyView()` for the Label of a Stepper if no label required

  ```swift
  Stepper(onIncrement: {
      self.chosenPalette = self.document.palette(after: self.chosenPalette)
  }, onDecrement: {
      self.chosenPalette = self.document.palette(before: self.chosenPalette)
  }, label: { EmptyView() })
  ```

* `.fixedSize` sizes a View to fit

* @State should always be **private**

* @Binding **cannot be private**







## @States

通过使用 @State 修饰器我们可以关联出 View 的状态. SwiftUI 将会把使用过 @State 修饰器的属性存储到一个特殊的内存区域，并且这个区域和 View struct 是隔离的. 当 @State 装饰过的属性发生了变化，SwiftUI 会根据新的属性值重新创建视图

```
struct ProductsView: View {
    let products: [Product]

    @State private var showFavorited: Bool = false

    var body: some View {
        List {
            Button(
                action: { self.showFavorited.toggle() },
                label: { Text("Change filter") }
            )

            ForEach(products) { product in
                if !self.showFavorited || product.isFavorited {
                    Text(product.title)
                }
            }
        }
    }
}
```

这个例子里我们创建了一个列表，点击按钮 showFavorited 会发生值的取反操作，然后 SwiftUI 会通过最新的值更新值

译者：这个 demo 在最新的 `xcode 11 beta 6` 中已经无法运行起来了，因为 Button 组件的语法已经修改了

## @Binding

有时候我们会把一个视图的属性传至子节点中，但是又不能直接的传递给子节点，因为在 Swift 中值的传递形式是`值类型`传递方式，也就是传递给子节点的是一个拷贝过的值。但是通过 @Binding 修饰器修饰后，属性变成了一个`引用类型`，传递变成了引用传递，这样父子视图的状态就能关联起来了。

```
struct FilterView: View {
    @Binding var showFavorited: Bool

    var body: some View {
        Toggle(isOn: $showFavorited) {
            Text("Change filter")
        }
    }
}

struct ProductsView: View {
    let products: [Product]

    @State private var showFavorited: Bool = false

    var body: some View {
        List {
            FilterView(showFavorited: $showFavorited)

            ForEach(products) { product in
                if !self.showFavorited || product.isFavorited {
                    Text(product.title)
                }
            }
        }
    }
}
```

我们在 FilterView 视图里用 @Binding 修饰 showFavorited 属性, 在传递属性是使用 $ 来传递 showFavorited 属性的引用，这样 FilterView 视图就能读写父视图 ProductsView 里的状态值了，并且值发生了修改 SwiftUI 会更新 ProductsView 和 FilterView 视图

译者：在 FilterView 视图里，Toggle 组件的创建也使用 $showFavorited 这种格式，因为 Toggle 组件会修改传入的值，如果是一个纯读的组件比如 Text 就不需要 使用 $showFavorited， 直接 Text(showFavorited) 使用就好了

## @ObservedObject

@ObservedObject 的用处和 @State 非常相似，从名字看来它是来修饰一个对象的，这个对象可以给多个独立的 View 使用。如果你用 @ObservedObject 来修饰一个对象，那么那个对象必须要实现 ObservableObject 协议，然后用 @Published 修饰对象里属性，表示这个属性是需要被 SwiftUI 监听的

```
final class PodcastPlayer: ObservableObject {
    @Published private(set) var isPlaying: Bool = false

    func play() {
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }
}
```

我们定义了一个 PodcastPlayer 类，这个类可以给不同的 View 使用，SwiftUI 会追踪使用 View 里经过 @ObservableObject 修饰过的对象里进过 @Published 修饰的属性变换，一旦发生了变换，SwiftUI 会更新相关联的 UI

```
struct EpisodesView: View {
    @ObservedObject var player: PodcastPlayer
    let episodes: [Episode]

    var body: some View {
        List {
            Button(
                action: {
                    if self.player.isPlaying {
                        self.player.pause()
                    } else {
                        self.player.play()
                    }
            }, label: {
                    Text(player.isPlaying ? "Pause": "Play")
                }
            )
            ForEach(episodes) { episode in
                Text(episode.title)
            }
        }
    }
}
```

译者：这个 demo 在最新的 `xcode 11 beta 6` 中已经无法运行起来了，因为 Button 组件的语法已经修改了

## @EnvironmentObject

从名字上可以看出，这个修饰器是针对全局环境的。通过它，我们可以避免在初始 View 时创建 ObservableObject, 而是从环境中获取 ObservableObject

SceneDelegate.swift 文件

```
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let episodes = [
            Episode(id: 1, title: "First episode"),
            Episode(id: 2, title: "Second episode")
        ]

        let player = PodcastPlayer()
        window.rootViewController = UIHostingController(
            rootView: EpisodesView(episodes: episodes)
                .environmentObject(player)
        )
        self.window = window
        window.makeKeyAndVisible()
    }
}
```

EpisodesView.swift 文件

```
struct EpisodesView: View {
    @EnvironmentObject var player: PodcastPlayer
    let episodes: [Episode]

    var body: some View {
        List {
            Button(
                action: {
                    if self.player.isPlaying {
                        self.player.pause()
                    } else {
                        self.player.play()
                    }
            }, label: {
                    Text(player.isPlaying ? "Pause": "Play")
                }
            )
            ForEach(episodes) { episode in
                Text(episode.title)
            }
        }
    }
}
```

可以看出我们获取 PodcastPlayer 这个 ObservableObject 是通过 @EnvironmentObject 修饰器，但是在入口需要传入 `.environmentObject(player)` 。@EnvironmentObject 的工作方式是在 Environment 查找 PodcastPlayer 实例。

## @Environment

继续上面一段的说明，我们的确开一个从 Environment 拿到用户自定义的 object，但是 SwiftUI 本身就有很多系统级别的设定，我们开一个通过 @Environment 来获取到它们

```
struct CalendarView: View {
    @Environment(\.calendar) var calendar: Calendar
    @Environment(\.locale) var locale: Locale
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        return Text(locale.identifier)
    }
}
```

通过 @Environment 修饰的属性，我们开一个监听系统级别信息的变换，这个例子里一旦 Calendar, Locale, ColorScheme 发生了变换，我们定义的 CalendarView 就会刷新
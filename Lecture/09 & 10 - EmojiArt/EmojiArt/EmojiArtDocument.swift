//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable
{
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    //表情
    static let palette: String = "⭐️⛈🍎🌏🥨⚾️"
    
    //主类EmojiArt
    //@Published workaround for property observer
    @Published private var emojiArt: EmojiArt
//  {
//        willSet{
//            objectWillChange.send()
//        }
//        didSet{
//            //??是判断是否为nil，否则取后面的值
//            print("json = \(emojiArt.json?.utf8 ?? "nil")")
//            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.document_name)
//        }
//    }
    
    @Published private(set) var SelectedEmoji: Set<EmojiArt.Emoji> = Set()
    
    func SelectOrDisSelectEmoji(_ emoji: EmojiArt.Emoji){
        if SelectedEmoji.isEmpty{
            SelectedEmoji.insert(emoji)
        }
        else{
            if SelectedEmoji.contains(emoji){
                SelectedEmoji.remove(emoji)
            }
            else{
                SelectedEmoji.insert(emoji)
            }
        }
    }
    
    func removeAllSelectedEmoji(){
        if !self.SelectedEmoji.isEmpty{
            self.SelectedEmoji.removeAll()
        }
    }
    
    func removeEmoji(_ emoji: EmojiArt.Emoji){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis.remove(at: index)
        }
    }
    
    private static let document_name = "EmojiArtDocument.EmojiArt"
    
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaulKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaulKey)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink(receiveValue: { emojiArt in
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: defaulKey)
        })
        fetchBackgroundImageData()
    }
    
    //主图backgroundImage：UIImage（like color：UIColor）
    @Published private(set) var backgroundImage: UIImage?
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    //添加emoji
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    //移动emoji
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    //放大缩小emoji
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL?{
        get{
            emojiArt.backgroundURL
        }
        set{
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
        //设置背景图片
        //    func setBackgroundURL(_ url: URL?) {
        //        emojiArt.backgroundURL = url?.imageURL
        //        fetchBackgroundImageData()
        //    }
    
    private var fetchImageCancellable: AnyCancellable?
    //获取背景图片数据
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
//            //1.async异步
//            //利用副线程去获取
//            DispatchQueue.global(qos: .userInitiated).async {
//                //利用url去获取数据
//                if let imageData = try? Data(contentsOf: url) {
//                    //获取完数据后再用主线程更新
//                    DispatchQueue.main.async {
//                        if url == self.emojiArt.backgroundURL {
//                            self.backgroundImage = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }
            //2.urlsession deal with the problems
            fetchImageCancellable?.cancel()
            fetchImageCancellable = URLSession
                .shared
                .dataTaskPublisher(for: url)
                .map{data, URLResponse in UIImage(data: data)}
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}

extension Set where Element: Identifiable {
    mutating func toggleMatching(_ emoji: Element) {
        if contains(matching: emoji) {
            let indexOfMatchingEmoji = firstIndex(matching: emoji)
            remove(at: indexOfMatchingEmoji!)
        } else {
            insert(emoji)
        }
    }
}

# Lecture 13 - Persistance

* **UserDefaults** - Simple, Limited & Small
* **Codable/JSON** -turn almost any data structure into an interoperable/storable format
* **UIDocument** -true document 、UIKit-based 
* **CoreData** - Powerful, Object Oriented
* **CloudKit** - Storing into iCloud
  * Has its own *UserDefaults thing*
  * Works with Core Data
* **FileManager/URL/Data** - Storing in a Unix File System



## Cloud Kit

* Simple & asynchronous but slow
* Important Components:
  * `Record Type` - like class or struct
  * `Fields` - vars
  * `Record` - instance of Record Type
  * `Database` - where Records are stored
  * `Reference` - pointer to another record
  * `Query` - a database search
* Enable iCloud under Capabilities in Project Settings

```swift
let db = CKContainer.default.public/shared/privateCloudDatabase

let tweet = CKRecord(“Tweet”)
tweet[“text”] = “140 characters of pure joy”

let tweeter = CKRecord(“TwitterUser”)
tweet[“tweeter”] = CKReference(record: tweeter, action: .deleteSelf)

db.save(tweet) { (savedRecord: CKRecord?, error: NSError?) -> Void in    
    if error == nil {
      // Hooray!    
    } else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue {
      // tell user he or she has to be logged in to iCloud for this to work!
    } else {
      // report other errors (there are 29 different CKErrorCodes!)    
    } 
}
```
* query for records in a database 
```swift
let predicate = NSPredicate(format: “text contains %@“, searchString) let query = CKQuery(recordType: “Tweet”, predicate: predicate) db.perform(query) { (records: [CKRecord]?, error: NSError?) in
      if error == nil {
// records will be an array of matching CKRecords
} else if error?.errorCode == CKErrorCode.NotAuthenticated.rawValue {
// tell user he or she has to be logged in to iCloud for this to work!
} else {
// report other errors (there are 29 different CKErrorCodes!) }
}
```

* Use `NSPredicate` to query for records in Database
  * aka Subscriptions
  * One of the coolest features of Cloud Kit is its ability to send push notifications on changes. All you do is register an NSPredicate and whenever the database changes to match it, boom! 
  * If you’re interested, check out the UserNotifications framework. 
* Dynamic Schema Creation
  * you don’t have to create your schema in the Dashboard.
  * When you store a record with a new, never-before-seen Record Type, it will create that type. Or if you add a Field to a Record, it will automatically create a Field for it in the database. 
* Cloud Kit Dashboard
  * A web-based UI to look at everything you are storing.
  * Shows you all your Record Types and Fields as well as the data in Records.
  * You can add new Record Types and Fields and also turn on/off indexes for various Fields. 



## File System

* There are **file protections** in Unix systems so you can only write in the applications *"sandbox"*
* Why sandbox?
  * Security (so no one else can damage your application)
  * Privacy (so no other applications can view your application’s data)
  * Cleanup (when you delete an application, everything it has ever written goes with it) 
* what’s in this “sandbox”?
  * Application directory — Your executable, .jpgs, etc.; not writeable.
  * Documents directory — Permanent storage created by and always visible to the user. 
  * Application Support directory — Permanent storage not seen directly by the user. 
  * Caches directory — Store temporary files here (this is not backed up).
  * Other directories (see documentation)  
* Use `FileManager` to get a path to sandbox directories:
  * Provides utility operations.
  * Can also create and enumerate directories; move, copy, delete files; etc.

  * Thread safe
  * Also has a delegate you can set which will have functions called on it when things happen. 

```swift
let url: URL = FileManager.default.url(    
  for directory: FileManager.SearchPathDirectory.documentDirectory, // for example    
  in domainMask: .userDomainMask  // always .userDomainMask on iOS    
  appropriateFor: nil, // only meaningful for “replace” file operations    
  create: true // whether to create the system directory if it doesn’t already exist
)

fileExists(atPath: String) -> Bool
```

* Checking URL files:

```swift
var isFileURL: Bool  // is this a file URL (whether file exists or not) or something else?
func resourceValues(for keys: [URLResourceKey]) throws -> [URLResourceKey:Any]? 
// Example keys: .creationDateKey, .isDirectoryKey, .fileSizeKey

// Reading Files
init(contentsOf: URL, options: Data.ReadingOptions) throws 

// Writing Files
func write(to url: URL, options: Data.WritingOptions) throws -> Bool //options can .atomic
```

* Write atomic - write to a temp file and then swap



## Demo

* Need unique names when adding files to FileSystem

```swift
// Using uniqued extention to get Untitled1, Untitled2 etc.
let uniqueName = name.uniqued(withRespectTo: documentNames.values)
```

* Need initialization function to get file from filesystem.

```swift
    var url: URL? { didSet { self.save(self.emojiArt) } }
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
        self.emojiArt = EmojiArt(json: try? Data(contentsOf: url)) ?? EmojiArt()
        fetchBackgroundImageData()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            self.save(emojiArt)
        }
    }
    
    private func save(_ emojiArt: EmojiArt) {
        if url != nil {
            try? emojiArt.json?.write(to: url!)
        }
    }
```

```swift
    private var directory: URL?
    
    init(directory: URL) {
        self.name = directory.lastPathComponent
        self.directory = directory
        do {
            let documents = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for document in documents {
                let emojiArtDocument = EmojiArtDocument(url: directory.appendingPathComponent(document))
                self.documentNames[emojiArtDocument] = document
            }
        } catch {
            print("EmojiArtDocumentStore: couldn't create store from directory \(directory): \(error.localizedDescription)")
        }
    }
```
* extension of string

```swift
extension String
{
    // returns ourself but with numbers appended to the end
    // if necessary to make ourself unique with respect to those other Strings
    func uniqued<StringCollection>(withRespectTo otherStrings: StringCollection) -> String
        where StringCollection: Collection, StringCollection.Element == String {
        var unique = self
        while otherStrings.contains(unique) {
            unique = unique.incremented
        }
        return unique
    }
    
    // if a number is at the end of this String
    // this increments that number
    // otherwise, it appends the number 1
    var incremented: String  {
        let prefix = String(self.reversed().drop(while: { $0.isNumber }).reversed())
        if let number = Int(self.dropFirst(prefix.count)) {
            return "\(prefix)\(number+1)"
        } else {
            return "\(self) 1"
        }
    }
}
```

* Change the AppDelegate to use filesystem

```swift
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = EmojiArtDocumentStore(directory: url)
```

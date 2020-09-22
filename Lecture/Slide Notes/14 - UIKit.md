# Lecture 14 - UIKit

* UIKit uses **MVC**, controlled by a controller

  * This Controller is the granularity at which you present views on screen

    * In other words, UIKit’s .sheet, .popover and NavigationLink destination equivalents 

    don’t present a view, they present a controller (which in turn controls views) 

    Integration
    
  * Delegation

    * Objects (controllers and views) often delegate some of their functionality to other objects 
    * They do this by having a var called delegate
    * That delegate var is constrained via a protocol with all the delegatable functionality 

  * Needs both `UIViewRepresentable` & `UIViewControllerRepresentable` when using UIKit

    1. func that **creates**

       `func makeUIView{Controller}(context: Context) -> view/controller`

    2. func that **updates**

       `func updateUIView{Controller}(view/controller, context: Context)`

    3. Coordinator object that **handles delegate**

       `func makeCoordinator() -> Coordinator`

    4. **Context** (Coordinator, Environment & Animation Transactions)

       `// passed into the methods above`

    5. **Clean up** after View or Controller disappears

       `func dismantleUIView{Controller}(view/controller, coordinator: Coordinator)`

* Uses a concept called **delegation**

  * Objects have a `var delegate`



## Demo

### MapKit

* For Maps, import UIKit & MapKit
* MapView is `UIViewRepresentable`
* For Annotations, coordinator controls how the annotations are drawn

```swift
extension Airport: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    public var title: String? { name ?? icao }
    public var subtitle: String? { location }
}

    var destination: Binding<MKAnnotation?> {
        return Binding<MKAnnotation?>(
            get: { return self.draft.destination },
            set: { annotation in
                if let airport = annotation as? Airport {
                    self.draft.destination = airport
                }
            }
        )
    }

struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation]
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(self.annotations)
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ??
                MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            return view
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                self.selection = annotation
            }
        }
    }
}

MapView(annotations: airports.sorted(), selection: destination)
                        .frame(minHeight: 400)

```

### Photo Image Picker

* ImagePicker is `UIViewControllerRepresentable`
* Controller has to implement `NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate`
* Controller has to have functions for **picking the image and cancelling**
  * Get the image as `info[.originalImage] as? UIImage`
* `typealias` removes need for typing function arguments again and again
* Check if camera is available on device with `.isSourceTypeAvailable(.camera)`
* Info.plist to allow Camera use permissions
```swift
import SwiftUI
import UIKit

typealias PickedImageHandler = (UIImage?) -> Void

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var handlePickedImage: PickedImageHandler
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: PickedImageHandler
        
        init(handlePickedImage: @escaping PickedImageHandler) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage(info[.originalImage] as? UIImage)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
    }
}
```
* how to use it in view
```swift
  @State **private** **var** showImagePicker = **false**

  @State **private** **var** imagePickerSourceType = UIImagePickerController.SourceType.photoLibrary

   

  **private** **var** pickImage: **some** View {

​    HStack {

​      Image(systemName: "photo").imageScale(.large).foregroundColor(.accentColor).onTapGesture {

​        **self**.imagePickerSourceType = .photoLibrary

​        **self**.showImagePicker = **true**

​      }

​      **if** UIImagePickerController.isSourceTypeAvailable(.camera) {

​        Image(systemName: "camera").imageScale(.large).foregroundColor(.accentColor).onTapGesture {

​          **self**.imagePickerSourceType = .camera

​          **self**.showImagePicker = **true**

​        }

​      }

​    }

​    .sheet(isPresented: $showImagePicker) {

​      ImagePicker(sourceType: **self**.imagePickerSourceType) { image **in**

​        **if** image != **nil** {

​          DispatchQueue.main.async {

​            **self**.document.backgroundURL = image!.storeInFilesystem()

​          }

​        }

​        **self**.showImagePicker = **false**

​      }

​    }

  }
```
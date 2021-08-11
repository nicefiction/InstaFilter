// ContentView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/customizing-our-filter-using-actionsheet

// MARK: - LIBRARIES -

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var filterIntensity: Double = 0.5
   @State private var image: Image?
   @State private var uiImage: UIImage?
   @State private var processedUIImage: UIImage?
   @State private var isShowingImagePickerSheet: Bool = false
   // @State private var selectedFilter = CIFilter.sepiaTone()
   @State private var selectedFilter: CIFilter = CIFilter.sepiaTone()
   @State private var isShowingFilterActionSheet: Bool = false
   @State private var isShowingErrorAlert: Bool = false
   @State private var activeFilter: String = "Sepia Tone"
   @State private var filterRadius: Double = 180
   
   
   
   // MARK: - PROPERTIES
   
   let ciContext: CIContext = CIContext()
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      let intensity = Binding<Double>(
         get: {
            self.filterIntensity
         },
         set: {
            self.filterIntensity = $0
            self.processImage()
         })
      
      
      let radius = Binding<Double>(
         get: {
            self.filterRadius
         },
         set: {
            self.filterRadius = $0
            self.processImage()
         }
      )
      
      
      return NavigationView {
         VStack {
            ZStack {
               Rectangle()
                  .fill(Color.secondary)
               // TODO: Display the image.
               if let _image = image {
                  _image
                     .resizable()
                     .scaledToFit()
               } else {
                  Text("Place New Image")
                     .font(.callout)
               }
            }
            .onTapGesture {
               // TODO: Select the image.
               self.isShowingImagePickerSheet.toggle()
            }
            Group {
               if selectedFilter.inputKeys.contains(kCIInputIntensityKey) || selectedFilter.inputKeys.contains(kCIInputScaleKey) {
                  HStack {
                     Text("Intensity")
                     /// Even though the slider is changing the value of filterIntensity,
                     /// changing that property won’t automatically trigger our `procesImage()` method again.
                     /// Instead, we need to do that by hand,
                     /// and it’s not as easy as just creating a property observer on `filterIntensity`
                     /// because they don’t work well thanks to the `@State` property wrapper being used.
                     // Slider(value: $filterIntensity,
                     /// Instead, what we need is a _custom binding_
                     /// that will return `filterIntensity` when it is read,
                     /// but when it is written
                     /// it will both update `filterIntensity` and also call `procesImage()`
                     /// so that the latest intensity setting is immediately used in our filter .
                     Slider(value: intensity,
                            in: 0...1)
                     /// Remember, because intensity is already a binding,
                     /// we don’t need to use a dollar sign before it .
                  }
               }
               if selectedFilter.inputKeys.contains(kCIInputRadiusKey) {
                  HStack {
                     Text("Radius")
                     Slider(value: radius,
                            in: 0...360)
                  }
               }
            }
            .padding()
            HStack {
               if image != nil {
                  Button(activeFilter) {
                     self.isShowingFilterActionSheet.toggle()
                  }
               }
               Spacer()
               Button("Save") {
                  guard let _processedUIImage = self.processedUIImage
                  else {
                     isShowingErrorAlert.toggle()
                     return
                  }
                  
                  let imageSaver = ImageSaver()
                  imageSaver.succesHandler = { print("Succes!") }
                  imageSaver.errorHandler = { (error: Error) in
                     print("Oops: \(error.localizedDescription)")
                  }
                  
                  imageSaver.writeToPhotoAlbum(image: _processedUIImage)
               }
            }
         }
         .padding([.horizontal, .bottom])
         .navigationBarTitle("InstaFilter")
         .sheet(isPresented: $isShowingImagePickerSheet,
                onDismiss: loadImage) {
            ImagePicker(uiImage: $uiImage)
         }
         .actionSheet(isPresented: $isShowingFilterActionSheet) {
            ActionSheet(title: Text("Title"),
                        buttons: [
                           .default(Text("Crystallize")) {
                              activeFilter = "Crystallize"
                              self.setFilter(CIFilter.crystallize()) },
                           .default(Text("Edges")) {
                              activeFilter = "Edges"
                              self.setFilter(CIFilter.edges()) },
                           .default(Text("Gaussian Blur")) {
                              activeFilter = "Gaussian Blur"
                              self.setFilter(CIFilter.gaussianBlur()) },
                           .default(Text("Pixellate")) {
                              self.setFilter(CIFilter.pixellate()) },
                           .default(Text("Sepia Tone")) {
                              activeFilter = "Sepia Tone"
                              self.setFilter(CIFilter.sepiaTone()) },
                           .default(Text("Unsharp Mask")) {
                              activeFilter = "Unsharp Mask"
                              self.setFilter(CIFilter.unsharpMask()) },
                           .default(Text("Vignette")) {
                              activeFilter = "Vignette"
                              self.setFilter(CIFilter.vignette()) },
                           .cancel()
                        ])
         }
         .alert(isPresented: $isShowingErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text("Please select an image to save."),
                  dismissButton: .cancel())
         }
      }
   }
   
   
   
   // MARK: - METHODS
   
   func loadImage() {
      guard let _uiImage = uiImage
      else { return }
      
      // image = Image(uiImage: _uiImage)
      let ciImage = CIImage(image: _uiImage)
      selectedFilter.setValue(ciImage,
                              forKey: kCIInputImageKey)
      processImage()
   }
   
   
   func processImage() {
      
      // selectedFilter.intensity = Float(filterIntensity)
      // selectedFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
      let inputKeys = selectedFilter.inputKeys
      
      if inputKeys.contains(kCIInputIntensityKey) { selectedFilter.setValue(filterIntensity,
                                                                            forKey: kCIInputIntensityKey) }
      
      // if inputKeys.contains(kCIInputRadiusKey) { selectedFilter.setValue(filterIntensity * 200,
      if inputKeys.contains(kCIInputRadiusKey) { selectedFilter.setValue(filterRadius,
                                                                         forKey: kCIInputRadiusKey) }
      
      if inputKeys.contains(kCIInputScaleKey) { selectedFilter.setValue(filterIntensity * 10,
                                                                        forKey: kCIInputScaleKey) }
      
      guard let _outputImage = selectedFilter.outputImage
      else { return }
      
      if let _cgImage = ciContext.createCGImage(_outputImage,
                                                from: _outputImage.extent) {
         let uiImage = UIImage(cgImage: _cgImage)
         image = Image(uiImage: uiImage)
         processedUIImage = uiImage
      }
   }
   
   
   func setFilter(_ filter: CIFilter) {
      
      selectedFilter = filter
      loadImage()
   }
}





// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}

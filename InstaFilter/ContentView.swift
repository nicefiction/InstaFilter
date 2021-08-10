// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var filterIntensity: Double = 0.5
   @State private var image: Image?
   @State private var isShowingImagePickerSheet: Bool = false
   @State private var uiImage: UIImage?
   // @State private var selectedFilter = CIFilter.sepiaTone()
   @State private var selectedFilter: CIFilter = CIFilter.sepiaTone()
   @State private var isShowingFilterActionSheet: Bool = false
   
   
   
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
            .padding()
            HStack {
               Button("Change Filter") {
                  // TODO: Chenge the filter.
                  self.isShowingFilterActionSheet.toggle()
               }
               Spacer()
               Button("Save") {
                  // TODO: Save the image.
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
                           .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                           .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                           .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                           .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                           .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                           .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                           .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                           .cancel()
                        ])
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
      
      if inputKeys.contains(kCIInputRadiusKey) { selectedFilter.setValue(filterIntensity * 200,
                                                                         forKey: kCIInputRadiusKey) }
      
      if inputKeys.contains(kCIInputScaleKey) { selectedFilter.setValue(filterIntensity * 10,
                                                                        forKey: kCIInputScaleKey) }
      
      guard let _outputImage = selectedFilter.outputImage
      else { return }
      
      if let _cgImage = ciContext.createCGImage(_outputImage,
                                                from: _outputImage.extent) {
         let uiImage = UIImage(cgImage: _cgImage)
         image = Image(uiImage: uiImage)
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

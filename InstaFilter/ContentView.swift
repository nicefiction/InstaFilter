// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var filterIntensity: CGFloat = 0.5
   @State private var image: Image?
   @State private var isShowingImagePickerSheet: Bool = false
   @State private var uiImage: UIImage?
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      NavigationView {
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
               Slider(value: $filterIntensity,
                      in: 0...1)
            }
            .padding()
            HStack {
               Button("Change Filter") {
                  // TODO: Chenge the filter.
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
      }
   }
   
   
   
   // MARK: - METHODS
   
   func loadImage() {
      guard let _uiImage = uiImage
      else { return }
      
      image = Image(uiImage: _uiImage)
   }
}





// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}

// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var filterIntensity: CGFloat = 0.5
   @State private var image: Image?
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      NavigationView {
         VStack {
            ZStack {
               Rectangle()
                  .fill(Color.secondary)
               // TODO: Display the image.
            }
            .onTapGesture {
               // TODO: Select the image.
               if let _image = image {
                  _image
                     .resizable()
                     .scaledToFit()
               } else {
                  Text("Select New Image")
                     .font(.headline)
               }
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
      }
   }
}





// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}

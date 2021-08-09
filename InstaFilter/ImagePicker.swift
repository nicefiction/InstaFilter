// ImagePicker.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller

// MARK: - LIBRARIES -

import SwiftUI


struct ImagePicker {
   
   // MARK: - NESTED TYPES
   
   class Coordinator: NSObject,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
      
      // MARK: PROPERTIES
      
      let parent: ImagePicker
      
      
      // MARK: INITIALIZER METHODS
      
      init(_ parent: ImagePicker) { self.parent = parent }
      
      
      // MARK: METHODS
      
      func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
         if let _uiImage = info[.originalImage] as? UIImage {
            parent.uiImage = _uiImage
         }
         
         parent.presentationMode.wrappedValue.dismiss()
      } /// This method will be called when the user has selected an image,
        /// and will be given a dictionary of information about the selected image.
   }
   
   
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.presentationMode) var presentationMode
   @Binding var uiImage: UIImage?
}

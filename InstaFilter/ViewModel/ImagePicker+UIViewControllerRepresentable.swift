// ImagePicker+UIViewControllerRepresentable.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller

// MARK: - LIBRARIES -

import SwiftUI



extension ImagePicker: UIViewControllerRepresentable {
   
   /// When the `ImagePicker` struct is created,
   /// SwiftUI will automatically call its `makeUIViewController()` method,
   /// which is what goes on to create and send back a `UIImagePickerController`.
   func makeUIViewController(context: Context)
   -> some UIViewController {
      
      let uiImagePicker = UIImagePickerController()
      /// Because our `Coordinator` class conforms to the `UIImagePickerControllerDelegate` protocol,
      /// we can make it the delegate of the UIKit image picker by modifying `makeUIViewController()` to this:
      uiImagePicker.delegate = context.coordinator
      
      return uiImagePicker
   }
   
   
   /// The `makeCoordinator()` method tells SwiftUI
   /// to use the `Coordinator` class for the `ImagePicker` coordinator.
   /// From our perspective this is obvious,
   /// because we created a class called `Coordinator` that was inside the `ImagePicker` struct,
   /// but this `makeCoordinator()` method lets us control _how_ the coordinator is made.
   func makeCoordinator()
   -> Coordinator {
      
      /// If you recall, we gave the `Coordinator` class a single property: `let parent: ImagePicker`.
      /// This means we need to create it with a reference to the image picker that owns it,
      /// so the coordinator can forward on interesting events. So,
      /// inside our `makeCoordinator()` method
      /// we’ll create a `Coordinator` object and pass in `self`.
      Coordinator(self)
   }
   
   
   func updateUIViewController(_ uiViewController: UIViewControllerType,
                               context: Context) {}
}

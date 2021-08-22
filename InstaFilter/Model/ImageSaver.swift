// ImageSaver.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/saving-the-filtered-image-using-uiimagewritetosavedphotosalbum

// MARK: - LIBRARIES -

import UIKit


class ImageSaver: NSObject {
   
   // MARK: - PROPERTIES
   
   var succesHandler: (() -> Void)?
   var errorHandler: ((Error) -> Void)?
   
   
   
   // MARK: - METHODS
   
   func writeToPhotoAlbum(image: UIImage) {
      
      UIImageWriteToSavedPhotosAlbum(image,
                                     self,
                                     #selector(saveError),
                                     nil)
   }
   
   
   @objc
   func saveError(_ image: UIImage,
                  didFinishSavingWithError error: Error?,
                  contextInfo: UnsafeRawPointer) {
      
      if let _error = error {
         errorHandler?(_error)
      } else {
         succesHandler?()
      }
   }
}

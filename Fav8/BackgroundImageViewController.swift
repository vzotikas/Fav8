//
//  BackgroundImageViewController.swift
//  Fav8
//
//  Created by Administrator on 2018-05-16.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit

protocol BackgroundImageDelegate {
    func didTapChoise(imgData: NSData)
}

var gradientArray = ["gradient01", "gradient02", "gradient03", "gradient04", "gradient05", "gradient06"]

let defaults = UserDefaults.standard

class BackgroundImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var img = UIImage()
    
    var selectionDelegate: BackgroundImageDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.masksToBounds = false
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
        photoImageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        // let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        img = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBAction func closeButton(_ sender: YTRoundedButton) {}
    
    @IBAction func setCustomImageButton(_ sender: UIButton) {
        // Encode Image
        if let imageData: NSData = img.pngData() as NSData? {
            selectionDelegate.didTapChoise(imgData: imageData)
            defaults.set(imageData, forKey: "Imagine")
            dismiss(animated: true, completion: nil)
        } else {
            print("No image selected")
        }
    }
    
    @IBAction func gradient01(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[0])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradient02(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[1])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradient03(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[2])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradient04(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[3])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradient05(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[4])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gradient06(_ sender: UIButton) {
        let imageData: NSData = UIImage(named: gradientArray[5])!.pngData()! as NSData
        selectionDelegate.didTapChoise(imgData: imageData)
        defaults.set(imageData, forKey: "Imagine")
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

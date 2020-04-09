//
//  NewPlaceViewController.swift
//  KafeShowSwift5
//
//  Created by v on 04.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import UIKit
import Cosmos

class NewPlaceTableViewController: UITableViewController {

    var currentPlace: Place?
    var currentRating: Double = 0.0
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeLocationTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var imageIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
//        DispatchQueue.main.async {
//            self.newCafe.savePlaces() //temp
//        }
        saveButtonItem.isEnabled = false
        placeNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
        cosmosView.settings.fillMode = .half
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
        
    }
    
    @objc private func textFieldChanged(){
        if placeNameTextField.text?.isEmpty == false {
            saveButtonItem.isEnabled = true
        } else {
            saveButtonItem.isEnabled = false
        }

    }
    func savePlace(){
        
        var image: UIImage?
        if imageIsChanged {
            image = placeImage.image
        }else{
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageDate = image?.pngData()
        
        //        let newPlace = Place()
//        newPlace.name = placeNameTextField.text!
//        newPlace.locatin = placeLocationTextField.text
//        newPlace.type = placeTypeTextField.text
//        newPlace.imageDate = imageDate
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = placeNameTextField.text!
                currentPlace?.locatin = placeLocationTextField.text
                currentPlace?.type = placeTypeTextField.text
                currentPlace?.imageDate = imageDate
//                currentPlace?.rating = Double(ratingControl.rating)
                currentPlace?.rating = currentRating
            }
        }else {
        let newPlace = Place(name: placeNameTextField.text!,
                             location: placeLocationTextField.text,
                             type: placeTypeTextField.text,
                             imageDate: imageDate,
                             rating: currentRating
//                             rating: Double(ratingControl.rating)
            )
        
        StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen(){
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageDate, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeNameTextField.text = currentPlace?.name
            placeLocationTextField.text = currentPlace?.locatin
            placeTypeTextField.text = currentPlace?.type
            cosmosView.rating = currentPlace!.rating
//            ratingControl.rating = Int(currentPlace!.rating)
        }
        
        
        
        
//        guard let place = currentPlace else {return}
//        placeNameTextField.text = place.name
//        placeLocationTextField.text = place.locatin
//        placeTypeTextField.text = place.type
//        placeImage.image = UIImage(data: place.imageDate!)
        
        
    }
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButtonItem.isEnabled = true
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
    }
    
    
    @IBAction func cancelActionButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: = Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let acImage = UIAlertController(title: "Add photo", message: nil, preferredStyle: .actionSheet)
            let aaCamera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            let cameraIcon = #imageLiteral(resourceName: "camera")
            aaCamera.setValue(cameraIcon, forKey: "image")
            aaCamera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let aaPhoto = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            let photoIcon = #imageLiteral(resourceName: "photo")
            aaPhoto.setValue(photoIcon, forKey: "image")
            aaPhoto.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let aaCancel = UIAlertAction(title: "Cancel", style: .cancel)
            acImage.addAction(aaCamera)
            acImage.addAction(aaPhoto)
            acImage.addAction(aaCancel)
            present(acImage, animated: true)
            
            
        }else {
            view.endEditing(true)
        }
    }
    
}

extension NewPlaceTableViewController: UITextFieldDelegate{
    
    // скрываем клавиатуру при нажатии Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

// MARK: work with image
extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(sourse: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourse){
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        placeImage.image = image
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
    
}


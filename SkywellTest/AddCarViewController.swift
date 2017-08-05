//
//  AddCarViewController.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/4/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class AddCarViewController: UIViewController {
    var context: NSManagedObjectContext {
        get {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    var carEngine: String? = CarEngine.allValues.first?.rawValue
    var carTransmission: String? = CarTransmission.allValues.first?.rawValue
    var carCondition: String? = CarCondition.allValues.first?.rawValue
    
    var photos: [UIImage] = []
    
    var currentParameters: [String] = []
    var currentParameter: String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carPriceTextField: UITextField!
    
    @IBOutlet weak var carEngineSelectView: UIView! {
        didSet {
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(carEngineViewClicked))
            carEngineSelectView.addGestureRecognizer(tapRecogniser)
        }
    }
    
    @IBOutlet weak var carTransmissionSelectView: UIView! {
        didSet {
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(carTransmissionViewClicked))
            carTransmissionSelectView.addGestureRecognizer(tapRecogniser)
            
        }
    }
    
    @IBOutlet weak var carConditionSelectView: UIView! {
        didSet {
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(carConditionViewClicked))
            carConditionSelectView.addGestureRecognizer(tapRecogniser)
            
        }
    }
    
    @IBOutlet weak var carEngineLabel: UILabel!
    @IBOutlet weak var carTransmissionLabel: UILabel!
    @IBOutlet weak var carConditionLabel: UILabel!
    
    @IBOutlet weak var carDescriptionTextView: UITextView!
    
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    func carEngineViewClicked() {
        currentParameter = "engine"
        currentParameters = CarEngine.allValues.map { $0.rawValue }
        
        showPickerView()
    }
    
    func carTransmissionViewClicked() {
        currentParameter = "transmission"
        currentParameters = CarTransmission.allValues.map { $0.rawValue }
        
        showPickerView()
    }
    
    func carConditionViewClicked() {
        currentParameter = "condition"
        currentParameters = CarCondition.allValues.map { $0.rawValue }
        
        showPickerView()
    }
    
    func showPickerView() {
        view.endEditing(true)
        self.bottomScrollViewConstraint.constant = customPickerView.frame.height
        
        pickerView.reloadComponent(0)
        customPickerView.isHidden = false
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        if currentParameter == "engine" {
            self.carEngine = currentParameters[pickerView.selectedRow(inComponent: 0)]
        }
        
        if currentParameter == "transmission" {
            self.carTransmission = currentParameters[pickerView.selectedRow(inComponent: 0)]
        }
        
        if currentParameter == "condition" {
            self.carCondition = currentParameters[pickerView.selectedRow(inComponent: 0)]
        }
        
        setupValuesUI()
        
        customPickerView.isHidden = true
        self.bottomScrollViewConstraint.constant = 0
    }
    
    @IBAction func saveCarButtonClicked(_ sender: Any) {
        DispatchQueue.main.async {
            let newCar = Car(context: self.context)
            
            newCar.model = self.carModelTextField.text
            
            if let carPriceString = self.carPriceTextField.text, let carPriceInt = Int(carPriceString) {
                newCar.price = Int64(carPriceInt)
            }
            
            newCar.carDescription = self.carDescriptionTextView.text
            
            let photoModels: [Photo] = self.photos.map { image in
                let data = UIImageJPEGRepresentation(image, 0.8)
                let photo = Photo(context: self.context)
                photo.data = data! as NSData
                
                return photo
            }
            
            newCar.addToPhotos(NSOrderedSet(array: photoModels))
            
            newCar.engine = self.carEngine
            newCar.transmission = self.carTransmission
            newCar.condition = self.carCondition
            
            do {
                self.context.insert(newCar)
                
                try self.context.save()
            } catch {
                print("error")
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.carEngine = CarEngine.allValues.first?.rawValue
        self.carTransmission = CarTransmission.allValues.first?.rawValue
        self.carCondition = CarCondition.allValues.first?.rawValue
        
        setupValuesUI()
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func setupValuesUI() {
        self.carEngineLabel.text = self.carEngine?.localized
        self.carTransmissionLabel.text = self.carTransmission?.localized
        self.carConditionLabel.text = self.carCondition?.localized
    }
    
    @IBAction func addPhotoButtonClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomScrollViewConstraint.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.bottomScrollViewConstraint.constant = 0
    }
}

extension AddCarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.photos.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath)
        }
        
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let image: UIImage = self.photos[indexPath.row]
        
        cell.imageView.image = image
        
        return cell
    }
}

extension AddCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.append(pickedImage)
            
            self.photosCollectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddCarViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentParameters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentParameters[row].localized
    }
}

extension AddCarViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

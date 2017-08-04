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
    
    lazy var newCar: Car? = {
        return Car(context: self.context)
    }()
    
    var photos: [Photo] = []
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carPriceTextField: UITextField!
    
    var currentParameters: [String] = []
    
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
    
    func carEngineViewClicked() {
        currentParameters = CarEngine.allValues.map { $0.rawValue }
        
        pickerView.reloadComponent(0)
        customPickerView.isHidden = false
    }
    
    func carTransmissionViewClicked() {
        currentParameters = CarTransmission.allValues.map { $0.rawValue }
        
        pickerView.reloadComponent(0)
        customPickerView.isHidden = false
    }
    
    func carConditionViewClicked() {
        currentParameters = CarCondition.allValues.map { $0.rawValue }
        
        pickerView.reloadComponent(0)
        customPickerView.isHidden = false
    }
    
    @IBOutlet weak var carEngineLabel: UILabel!
    @IBOutlet weak var carTransmissionLabel: UILabel!
    @IBOutlet weak var carConditionLabel: UILabel!
    
    @IBOutlet weak var carDescriptionTextView: UITextView!
    
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        customPickerView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func addPhotoButtonClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
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
        
        let data: Data = self.photos[indexPath.row].data! as Data
        
        cell.imageView.image = UIImage(data: data)
        
        return cell
    }
}

extension AddCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let newPhoto = Photo(context: self.context)
            newPhoto.data = UIImageJPEGRepresentation(pickedImage, 0.8)! as NSData
            
            photos.append(newPhoto)
            
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
        return currentParameters[row]
    }
}

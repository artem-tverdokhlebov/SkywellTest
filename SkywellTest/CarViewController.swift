//
//  CarViewController.swift
//  SkywellTest
//
//  Created by Artem Tverdokhlebov on 8/5/17.
//  Copyright © 2017 Artem Tverdokhlebov. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {
    
    @IBOutlet weak var currentPhotoImageView: UIImageView! {
        didSet {
            let leftSwipeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(photoLeftSwipeGestureHandler))
            leftSwipeRecognizer.direction = .left
            
            let rightSwipeRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(photoRightSwipeGestureHandler))
            rightSwipeRecognizer.direction = .right
            
            currentPhotoImageView.addGestureRecognizer(leftSwipeRecognizer)
            currentPhotoImageView.addGestureRecognizer(rightSwipeRecognizer)
        }
    }
    
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    
    @IBOutlet weak var carEngineLabel: UILabel!
    @IBOutlet weak var carTransmissionLabel: UILabel!
    @IBOutlet weak var carConditionLabel: UILabel!
    
    @IBOutlet weak var carDescriptionTextView: UITextView!
    
    var carModel: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        if let carModel = self.carModel {
            self.navigationItem.title = carModel.model
            
            if let photos = carModel.photos {
                photosPageControl.numberOfPages = photos.count
                
                if let firstPhoto = photos.firstObject as? Photo {
                    let photoModelData = firstPhoto.data as Data?
                    
                    if let photoModelData = photoModelData, let photoImage = UIImage(data: photoModelData) {
                        currentPhotoImageView.image = photoImage
                    }
                }
                
                photosPageControl.addTarget(self, action: #selector(photoChanged), for: .valueChanged)
            }
            
            self.carModelLabel.text = carModel.model
            self.carPriceLabel.text = String(carModel.price) + " $"
            
            self.carEngineLabel.text = carModel.engine?.localized
            self.carTransmissionLabel.text = carModel.transmission?.localized
            self.carConditionLabel.text = carModel.condition?.localized
            
            self.carDescriptionTextView.text = carModel.carDescription
        }
    }
    
    func photoLeftSwipeGestureHandler() {
        if photosPageControl.currentPage < photosPageControl.numberOfPages {
            photosPageControl.currentPage = photosPageControl.currentPage + 1
            photoChanged()
        }
    }
    
    func photoRightSwipeGestureHandler() {
        if photosPageControl.currentPage > 0 {
            photosPageControl.currentPage = photosPageControl.currentPage - 1
            photoChanged()
        }
    }
    
    func photoChanged() {
        if let carModel = self.carModel, let photos = carModel.photos {
            if photos.array.count > photosPageControl.currentPage {
                let photo = photos.array[photosPageControl.currentPage]
                
                if let photoModel = photo as? Photo {
                    let photoModelData = photoModel.data as Data?
                    
                    if let photoModelData = photoModelData, let photoImage = UIImage(data: photoModelData) {
                        currentPhotoImageView.image = photoImage
                    }
                }
            }
        }
    }
}

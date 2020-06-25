//
//  DetailUserGalleryController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 26.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class DetailUserGalleryController: UIViewController {
    let photoService: ServiceProtocol = DataForServiceProtocol()
    
    var id: Int?
    
    //массив картинок пользователя
    
    var imageArray = [Photo]()
    
    //индекс для слайдера
    var indexArray = 0

    @IBOutlet weak var galleryImage: UIImageView!
    
    @IBOutlet weak var galleryImageAfterSwipe: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addID: [String : String] = [
            "owner_id" :  String(id!)
        ]
        
        photoService.loadPhotos(addParameters: addID) { (photos) in
            self.imageArray = photos
            
        }
        
        //Свайпы по слайдеру
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_ :)))
        swipeRight.direction = .right
        galleryImageAfterSwipe.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeImage(_ :)))
        swipeLeft.direction = .left
        galleryImageAfterSwipe.addGestureRecognizer(swipeLeft)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openFullScreen))
        galleryImageAfterSwipe.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func openFullScreen(){
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ImageFullScreenController") else { return }
        present(viewController, animated: true, completion: nil)
        
        //определяем куда переходим
        guard let destination = viewController as? ImageFullScreenController else { return }
        
        var image: UIImage?
        //получаем картинку, которая на данный момент отображается в галлерее
        image = self.photoService.getImageByURL(imageURL: imageArray[indexArray].imageURL)
 //       imageArray[indexArray]
        
        // Передаём картинку на другой контроллер
        destination.imageFull.image = image
        
    }
    
    //анимация появления фото с лева на право
    func animationFotoLeftToRight() {
        galleryImageAfterSwipe.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.galleryImageAfterSwipe.transform = .identity
        })
    }
    
    //анимация появления фото с права на лево
    func animationFotoRightToLeft() {
        galleryImageAfterSwipe.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.galleryImageAfterSwipe.transform = .identity
        })
    }
    
    //анимация уменьшения фото
    func animationFotoSize() {
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 1
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.7
        scaleAnimation.stiffness = 100
        scaleAnimation.mass = 2
        scaleAnimation.beginTime = CACurrentMediaTime()
        
        galleryImage.layer.add(scaleAnimation, forKey: nil)
    }
    
    //обработка свайпов
    @objc func swipeImage(_ gesture: UISwipeGestureRecognizer) {
             
        if gesture.direction == .left {
            if indexArray >= 0 && indexArray != imageArray.count - 1 {
                galleryImage.image = self.photoService.getImageByURL(imageURL: self.imageArray[self.indexArray].imageURL)
                animationFotoSize()
                
                indexArray += 1
                
                galleryImageAfterSwipe.image = self.photoService.getImageByURL(imageURL: imageArray[indexArray].imageURL)
                animationFotoRightToLeft()
                
                
            } else {
                galleryImage.image = self.photoService.getImageByURL(imageURL: imageArray[indexArray].imageURL)
            }
            
        } else if gesture.direction == .right {
            if indexArray > 0 {
                
                galleryImage.image = self.photoService.getImageByURL(imageURL: imageArray[indexArray].imageURL)

                animationFotoSize()
                
                indexArray -= 1
                
                galleryImageAfterSwipe.image = self.photoService.getImageByURL(imageURL: imageArray[indexArray].imageURL)

                animationFotoLeftToRight()
                
                
            } else {
                galleryImage.image = UIImage(named: "landscape\(indexArray)")
            }
        }
    }
}

//
//  GalleryCollectionViewController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 30.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GalleryCollectionViewController: UICollectionViewController {
    
    let photoService: ServiceProtocol = DataForServiceProtocol()
        
    var id: Int?
        
    var imageArray = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addID: [String : String] = [
            "owner_id" :  String(id!)
        ]
        
        photoService.loadPhotos(addParameters: addID) { (photos) in
            self.imageArray = photos
            self.collectionView.reloadData()
        }
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendGalleryCell", for: indexPath) as! FriendGalleryCell
        
        let url = imageArray[indexPath.row].imageURL
        
        DispatchQueue.global().async {
            if let image = self.photoService.getImageByURL(imageURL: url) {
                
                DispatchQueue.main.async {
                    cell.galleryCellImage.image = image
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {  // UIStoryboardSegue
        // Получаем ссылку на контроллер, на который осуществлен переход
        guard let destination = segue.destination as? ImageFullScreenController,
            let cell = sender as? FriendGalleryCell else { return }
        
        destination.image = cell.galleryCellImage.image
        
    }
}



//
//  DetailedController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 07.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class DetailedController: UICollectionViewController {
    
    var image: UIImage?
    var nameLabelDetail: String?
    var lastNameLabelDetail: String?
    var id: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailedCell", for: indexPath) as! DetailedCell
        
        cell.DetailedImage.image = image
        cell.NameLabelDetail.text = nameLabelDetail
        cell.lastNameDetail.text = lastNameLabelDetail
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Получаем ссылку на контроллер, на который осуществлен переход
        guard let destination = segue.destination as? GalleryCollectionViewController else { return }

        destination.id = id
    }

}

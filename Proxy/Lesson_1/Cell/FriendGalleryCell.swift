//
//  FriendGalleryCell.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 30.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class FriendGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryCellImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        galleryCellImage.image = nil
    }
}

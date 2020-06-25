//
//  ImageFullScreenController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 06.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class ImageFullScreenController: UIViewController {
    
    @IBOutlet weak var imageFull: UIImageView!
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFull.image = image

    }

}

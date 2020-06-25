//
//  LoadingScenController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 24.02.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class LoadingScenController: UIViewController {

    @IBOutlet weak var firstPointView: UIView!
    @IBOutlet weak var secondPointView: UIView!
    @IBOutlet weak var thirdPointView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.firstPointView.alpha = 0.0
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.secondPointView.alpha = 0.0
        })
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.repeat, .autoreverse], animations: {
            self.thirdPointView.alpha = 0.0
        })
        
        
    }

}

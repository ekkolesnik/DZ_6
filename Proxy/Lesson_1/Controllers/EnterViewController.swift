//
//  EnterViewController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 22.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = loginButton.bounds.width / 15

    }
    



}

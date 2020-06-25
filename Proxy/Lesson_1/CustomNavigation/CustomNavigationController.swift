//
//  CustomNavigationController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 02.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CustomPushAnimator()
            
        }
        else if operation == .pop {
            return CustomPopAnimator()
            
        }
        
        return nil
    }
}

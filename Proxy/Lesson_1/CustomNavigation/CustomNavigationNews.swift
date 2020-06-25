//
//  CustomNavigationNews.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 03.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class CustomNavigationNews: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    let interactiveTransition = CustomInteractiveTransition()

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
                              -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }
    
    
}

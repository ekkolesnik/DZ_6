//
//  CustomPopPushTransitioning.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 02.03.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0,
                                                       animations: {
                                                        let position = CGAffineTransform(translationX: source.view.frame.width, y: source.view.bounds.height)
                                                        let rotation = CGAffineTransform(rotationAngle: .pi/2*3)
                                                        destination.view.transform = position.concatenating(rotation)
                                    })

                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1.0,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
       
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1.0,
                                                       animations: {
                                                        let position = CGAffineTransform(translationX: -source.view.frame.width, y: source.view.bounds.height)
                                                        let rotation = CGAffineTransform(rotationAngle: .pi/2)
                                                        destination.view.transform = position.concatenating(rotation)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
                                    
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}

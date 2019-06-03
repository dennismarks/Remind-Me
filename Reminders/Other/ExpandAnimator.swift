//
//  Expand Animator.swift
//  Expanding Table Animation
//
//  Created by Dennis M on 2019-05-30.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit

class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static var animator = ExpandAnimator()
    
    enum ExpandTransitionMode: Int {
        case Present, Dismiss
    }
    
    let presentDuration = 0.4
    let dismissDuration = 0.2
    
    var openingFrame: CGRect?
    var transitionMode: ExpandTransitionMode = .Present
    
    var topView: UIView!
    var bottomView: UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (transitionMode == .Present) {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // From view controller
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let fromViewFrame = fromViewController.view.frame
        
        // To view controller
        let toViewCOntroller = transitionContext.viewController(forKey: .to)!
        
        // Container view
        let containerView = transitionContext.containerView
        
        if (transitionMode == .Present) {
            
            // Get the top view using resizableSnapshotViewFromRect
            topView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: openingFrame!.origin.y, left: 0, bottom: 0, right: 0))
            topView.frame = CGRect(x: 0, y: 0, width: fromViewFrame.width, height: openingFrame!.origin.y)
            
            // Add top view to container
            containerView.addSubview(topView)
            
            // Get bottom view using resizableSnapshotViewFromRect
            bottomView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: fromViewFrame.height - openingFrame!.origin.y - openingFrame!.height, right: 0))
            bottomView.frame = CGRect(x: 0, y: openingFrame!.origin.y + openingFrame!.height, width: fromViewFrame.width, height: fromViewFrame.height - openingFrame!.origin.y - openingFrame!.height)
            
            // Add bottom view to container
            containerView.addSubview(bottomView)
            
            // Take a snapshot of the to view controller and change its frame to opening frame
            let snapshotView = toViewCOntroller.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            snapshotView?.frame = openingFrame!
            containerView.addSubview(snapshotView!)
            
            toViewCOntroller.view.alpha = 0.0
            containerView.addSubview(toViewCOntroller.view)
            
            UIView.animate(withDuration: presentDuration, animations: {
                
                // Move top and bottom views out of the screen
                self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewFrame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                
                // Expand snaphot view to fill entire frame
                snapshotView?.frame = toViewCOntroller.view.frame
                
            }) { (finished) in
                
                // Remove snapshot view from container view
                snapshotView?.removeFromSuperview()
                
                toViewCOntroller.view.alpha = 1.0
                
                // COmplete transition
                transitionContext.completeTransition(finished)
            }
        } else {
            let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            containerView.addSubview(snapshotView!)
            
            fromViewController.view.alpha = 0.0
            
            UIView.animate(withDuration: dismissDuration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewController.view.frame.height - self.bottomView.frame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                snapshotView?.frame = self.openingFrame!
            }) { (finished) in
                snapshotView?.removeFromSuperview()
                fromViewController.view.alpha = 1.0
                transitionContext.completeTransition(finished)
            }
            
        }
    }
    
}

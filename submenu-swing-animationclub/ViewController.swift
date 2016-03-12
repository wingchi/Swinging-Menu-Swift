//
//  ViewController.swift
//  submenu-swing-animationclub
//
//  Created by Stephen Wong on 3/12/16.
//  Copyright © 2016 Wingchi. All rights reserved.
//

import UIKit

enum RotationAxis {
    case X, Y, Z
}

final class ViewController: UIViewController {

    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var submenuView: UIView!

    var submenuExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        
        submenuView.frame = CGRect(x: 0, y: viewHeight / 2, width: viewWidth, height: viewHeight / 2)
    }
    
    
    @IBAction func expandButtonPressed(sender: UIButton) {
        toggleMainMenu()
        toggleSubMenu()
    }
    
    private func animate3DRotation(fromDegrees from: Double, toDegrees to: Double, rotationAxis: RotationAxis, forView view: UIView) {
        
        var fromTransform = CATransform3DIdentity
        var toTransform = CATransform3DIdentity
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var z: CGFloat = 0.0

        fromTransform.m34 = 1.0 / 1000.0
        toTransform.m34 = 1.0 / 1000.0
        
        switch rotationAxis {
        case .X:
            x = 1.0
            break;
        case .Y:
            y = 1.0
            break;
        case .Z:
            z = 1.0
            break;
        }
        
        fromTransform = CATransform3DRotate(fromTransform, CGFloat(from * M_PI / 180), x, y, z)
        toTransform = CATransform3DRotate(toTransform, CGFloat(to * M_PI / 180), x, y, z)
        
        // the keyPath is the property we are animating
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(CATransform3D: fromTransform)
        animation.toValue = NSValue(CATransform3D: toTransform)
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.transform = toTransform
        
        view.layer.addAnimation(animation, forKey: "swing")
    }
    
    private func toggleMainMenu() {
        
        let options: UIViewAnimationOptions = submenuExpanded ? .CurveEaseOut : .CurveEaseIn
        let transform = submenuExpanded ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0.0, -mainMenuView.frame.height / 2)
        
        UIView.animateWithDuration(
            1.0,
            delay: 0.0,
            options: options,
            animations: {
                self.mainMenuView.transform = transform
            },
            completion: { completed in
                if completed {
                    self.submenuExpanded = !self.submenuExpanded
                }
            }
        )
    }
    
    private func toggleSubMenu() {
        
        if submenuExpanded {
            setAnchorPoint(CGPoint(x: 1.0, y: 0.5), forView: submenuView)
            animate3DRotation(fromDegrees: 0.0, toDegrees: 90.0, rotationAxis: .Y, forView: submenuView)
        } else {
            setAnchorPoint(CGPoint(x: 0.0, y: 0.5), forView: submenuView)
            animate3DRotation(fromDegrees: -90.0, toDegrees: 0.0, rotationAxis: .Y, forView: submenuView)

        }
    }
    
    // method from codepath on Github https://github.com/codepath/ios_guides/wiki/Using-Perspective-Transforms
    private func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }

}


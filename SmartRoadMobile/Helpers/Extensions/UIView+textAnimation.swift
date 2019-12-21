//
//  UIView+textAnimation.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/20/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

extension UIView {
  func fadeTransition(_ duration:CFTimeInterval) {
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animation.type = CATransitionType.fade
    animation.duration = duration
    layer.add(animation, forKey: CATransitionType.fade.rawValue)
  }
}

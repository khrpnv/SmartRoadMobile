//
//  NSLayoutConstraint+multiplier.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/20/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
  func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([self])
    
    let newConstraint = NSLayoutConstraint(
      item: firstItem as Any,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)
    
    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier
    
    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }
}

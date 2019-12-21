//
//  ColorCalculator.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/20/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

struct RGB {
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  
  var color: UIColor {
    return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1.0)
  }
  
  init(red: CGFloat, green: CGFloat, blue: CGFloat) {
    self.red = red
    self.green = green
    self.blue = blue
  }
  
  init(color: UIColor) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    color.getRed(
      &red,
      green: &green,
      blue: &blue,
      alpha: nil)
    self.red = red
    self.green = green
    self.blue = blue
  }
  
  static func +(left: RGB, right: RGB) -> RGB {
    return RGB(red: left.red + right.red,
               green: left.green + right.green,
               blue: left.blue + right.blue)
  }
}

struct GradientColorCalculator {
  public func countColorDelta(startColor: UIColor, finishColor: UIColor, maxContentOffset: CGFloat) -> RGB {
    let startColor = RGB(color: startColor)
    let finishColor = RGB(color: finishColor)
    
    let redDelta = (finishColor.red - startColor.red) / maxContentOffset
    let greenDelta = (finishColor.green - startColor.green) / maxContentOffset
    let blueDelta = (finishColor.blue - startColor.blue) / maxContentOffset
    
    return RGB(red: redDelta, green: greenDelta, blue: blueDelta)
  }
}

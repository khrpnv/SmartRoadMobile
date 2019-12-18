//
//  UIButton+imageAlignment.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

extension UIButton {
  func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
    self.setImage(image.withRenderingMode(renderMode), for: .normal)
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    self.contentHorizontalAlignment = .left
    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    self.imageView?.contentMode = .scaleAspectFit
  }
  
  func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
    self.setImage(image.withRenderingMode(renderMode), for: .normal)
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
    self.contentHorizontalAlignment = .right
    self.imageView?.contentMode = .scaleAspectFit
  }
}

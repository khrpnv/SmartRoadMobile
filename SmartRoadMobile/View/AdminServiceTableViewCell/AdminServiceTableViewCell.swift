//
//  AdminServiceTableViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 1/9/20.
//  Copyright © 2020 Illia Khrypunov. All rights reserved.
//

import UIKit

class AdminServiceTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.backgroundColor = .clear
    self.titleLabel.textColor = .white
  }
  
  func configureWith(name: String) {
    titleLabel.text = name
  }
}

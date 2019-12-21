//
//  MenuCollectionViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/19/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class MenuCollectionViewCell: UICollectionViewCell {
  private weak var delegate: MenuCollectionViewCellDelegate?
  private var item: MenuItem?
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var mainView: UIView!
  @IBOutlet private weak var button: UIButton!
  @IBOutlet private weak var cardDescriptionTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(item: MenuItem, delegate: MenuCollectionViewCellDelegate) {
    mainView.layer.cornerRadius = 20
    self.item = item
    self.titleLabel.text = item.name
    cardDescriptionTextView.text = item.cardDescription[LanguageManager.shared.currentLanguage]
    guard let icon = UIImage(named: item.button) else { return }
    button.setBackgroundImage(icon, for: .normal)
    self.delegate = delegate
  }
  
  @IBAction func cardButtonPressed(_ sender: Any) {
    if let item = self.item {
      delegate?.didPressControlButtonFor(item)
    } else {
      return
    }
  }
  
}

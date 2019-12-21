//
//  RoadTableViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class RoadTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dataTextView: UITextView!
  @IBOutlet weak var nameTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func localizedTitles() -> [String] {
    let currentLanguage = LanguageManager.shared.currentLanguage
    nameTitleLabel.text = currentLanguage == .en ? "Name" : "Назва"
    let descriptionTitle = currentLanguage == .en ? "Description" : "Опис"
    let lengthTitle = currentLanguage == .en ? "Length" : "Довжина"
    let amountOfLinesTitle = currentLanguage == .en ? "Amount of lines" : "Кількість полос"
    let bandwidthTitle = currentLanguage == .en ? "Bandwidth" : "Пропуснка здатність"
    let maxSpeedTitle = currentLanguage == .en ? "Max allowed speed" : "Максимальна швидкість"
    let stateTitle = currentLanguage == .en ? "State" : "Стан"
    return [descriptionTitle, lengthTitle, amountOfLinesTitle,
            bandwidthTitle, maxSpeedTitle, stateTitle]
  }
  
  func configureWith(road: Road) {
    nameLabel.text = road.address
    let titles = localizedTitles()
    let description = "\(titles[0]): \(road.description)\n"
    let length = "\(titles[1]): \(road.length)\n"
    let amountOfLines = "\(titles[2]): \(road.amountOfLines)\n"
    let bandwidth = "\(titles[3]): \(road.bandwidth)\n"
    let maxSpeed = "\(titles[4]): \(road.maxAllowedSpeed)\n"
    let state = "\(titles[5]): \(road.state ?? "")"
    dataTextView.text = description + length + amountOfLines + bandwidth + maxSpeed + state
  }
  
}

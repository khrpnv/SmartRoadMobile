//
//  RoadTableViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class RoadTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dataTextView: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(road: Road) {
    nameLabel.text = road.address
    let description = "Description: \(road.description)\n"
    let length = "Length: \(road.length)\n"
    let amountOfLines = "Amount of lines: \(road.amountOfLines)\n"
    let bandwidth = "Bandwidth: \(road.bandwidth)\n"
    let maxSpeed = "Max allowed speed: \(road.maxAllowedSpeed) km\n"
    let state = "State: \(road.state ?? "")"
    dataTextView.text = description + length + amountOfLines + bandwidth + maxSpeed + state
  }
  
}

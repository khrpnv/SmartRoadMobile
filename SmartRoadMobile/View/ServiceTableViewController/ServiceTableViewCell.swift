//
//  ServiceTableViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ServiceTableViewCell: UITableViewCell {
  
  var serviceStation: ServiceStation?
  
  private weak var delegate: ServiceTableViewCellDelegate?
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var descriptionTextView: UITextView!
  @IBOutlet private weak var showOnMapButton: UIButton!
  @IBOutlet private weak var availabilityButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(serviceStation: ServiceStation, delegate: ServiceTableViewCellDelegate) {
    self.serviceStation = serviceStation
    self.delegate = delegate
    styleButton(button: showOnMapButton,
                backgroundColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1),
                textColor: .white)
    styleButton(button: availabilityButton,
                backgroundColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),
                textColor: .white)
    nameLabel.text = serviceStation.name
    descriptionTextView.text = serviceStation.description
  }
  
  private func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 20
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = backgroundColor
  }
  
  @IBAction func showOnMap(_ sender: Any) {
    guard serviceStation != nil else { return }
    delegate?.showMapsAlertActionForStation(serviceStation!)
  }
  
  @IBAction func showAvailability(_ sender: Any) {
    if let id = serviceStation?.id {
      delegate?.showEmptyPlacesForServiceStationWith(id)
    }
  }
}


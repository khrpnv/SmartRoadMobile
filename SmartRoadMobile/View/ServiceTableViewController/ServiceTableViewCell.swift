//
//  ServiceTableViewCell.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
  
  var serviceStation: ServiceStation?
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var descriptionTextView: UITextView!
  @IBOutlet private weak var showOnMapButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(serviceStation: ServiceStation) {
    self.serviceStation = serviceStation
    styleButton(button: showOnMapButton,
                backgroundColor: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1),
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
    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(serviceStation!.latitude),\(serviceStation!.longtitude)&directionsmode=driving") {
        UIApplication.shared.open(url, options: [:])
    } else {
        UIApplication.shared.open(URL(string:
          "https://www.google.co.in/maps/dir/?saddr=&daddr=\(serviceStation!.latitude),\(serviceStation!.longtitude)")! as URL)
    }
  }
  
}

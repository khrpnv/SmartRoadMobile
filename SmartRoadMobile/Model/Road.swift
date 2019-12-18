//
//  Road.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Road {
  let id: String
  let address: String
  let length: Double
  let description: String
  let maxAllowedSpeed: Int
  let amountOfLines: Int
  let bandwidth: Int
  var state: String?
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.address = object["address"].stringValue
    self.description = object["description"].stringValue
    self.maxAllowedSpeed = object["maxAllowedSpeed"].intValue
    self.amountOfLines = object["amountOfLines"].intValue
    self.length = object["length"].doubleValue
    self.bandwidth = object["bandwidth"].intValue
  }
}

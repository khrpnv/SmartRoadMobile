//
//  ServiceStation.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServiceStation {
  var id: String?
  var name: String
  var description: String
  var latitude: Double
  var longtitude: Double
  var type: Int
  
  init(name: String, description: String, latitude: Double, longtitude: Double, type: Int) {
    self.name = name
    self.description = description
    self.latitude = latitude
    self.longtitude = longtitude
    self.type = type
  }
  
  init(object: JSON) {
    self.id = object["id"].stringValue
    self.name = object["name"].stringValue
    self.description = object["description"].stringValue
    self.latitude = object["latitude"].doubleValue
    self.longtitude = object["longtitude"].doubleValue
    self.type = object["type"].intValue
  }
  
  func convertToParameters() -> [String: Any] {
    return [
      "name": self.name,
      "description": self.description,
      "latitude": self.latitude,
      "longtitude": self.longtitude,
      "type": self.type,
    ]
  }
}

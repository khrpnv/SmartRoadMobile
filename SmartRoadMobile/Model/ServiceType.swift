//
//  ServiceType.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServiceType: Codable {
  let id: Int
  let typeName: String
  
  init(object: JSON) {
    self.id = object["id"].intValue
    self.typeName = object["typeName"].stringValue
  }
}

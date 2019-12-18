//
//  User.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
  let email: String
  let password: String
  
  init(email: String, password: String) {
    self.email = email
    self.password = password
  }
  
  func convertToParameters() -> [String: Any] {
    return [
      "email": self.email,
      "password": self.password
    ]
  }
}

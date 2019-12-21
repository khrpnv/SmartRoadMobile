//
//  String+email.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/20/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

public extension String {
  var isEmail: Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
  }
}

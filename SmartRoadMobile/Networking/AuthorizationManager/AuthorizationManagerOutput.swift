//
//  AuthorizationManagerOutput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol AuthorizationManagerOutput: class {
  func loggedUserIn()
  func signedUserUp()
  func didGetErrors(_ message: String?)
}

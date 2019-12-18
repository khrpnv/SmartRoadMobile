//
//  LoginViewControllerInput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol LoginViewControllerInput: class {
  func didFinishSuccessfully()
  func didGetErrors(_ message: String?)
}

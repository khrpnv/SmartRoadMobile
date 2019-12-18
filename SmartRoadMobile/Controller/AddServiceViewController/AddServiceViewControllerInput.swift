//
//  AddServiceViewControllerInput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/18/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol AddServiceViewControllerInput: class {
  func didFinishLoadingTypes(types: [ServiceType])
  func didAddedSuccessfully()
  func didGetErrors(message: String?)
}

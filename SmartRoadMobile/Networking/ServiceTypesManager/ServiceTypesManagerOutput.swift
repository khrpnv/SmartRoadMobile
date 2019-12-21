//
//  ServiceTypesManagerOutput.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol ServiceTypesManagerOutput: class {
  func didFinishLoadingTypes(serviceTypes: [ServiceType])
}

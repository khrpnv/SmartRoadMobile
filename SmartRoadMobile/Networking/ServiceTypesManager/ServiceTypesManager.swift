//
//  ServiceTypesManager.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServiceTypesManager {
  private weak var delegate: ServiceTypesManagerOutput?
  
  init(delegate: ServiceTypesManagerOutput) {
    self.delegate = delegate
  }
  
  func getAllServiceTypes() {
    let url = "\(Const.Base.url)/service_types"
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var serviceTypes: [ServiceType] = []
      for object in jsonArray {
        serviceTypes.append(ServiceType(object: object))
      }
      self.delegate?.didFinishLoadingTypes(serviceTypes: serviceTypes)
    }
  }
}

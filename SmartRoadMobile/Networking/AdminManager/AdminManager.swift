//
//  AdminManager.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 1/9/20.
//  Copyright © 2020 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AdminManager {
  private weak var delegate: AdminManagerOutput?
  
  init(delegate: AdminManagerOutput) {
    self.delegate = delegate
  }
  
  func addServiceType(serviceType: ServiceType) {
    let url = "\(Const.Base.url)/service_types"
    let parameters = serviceType.convertToParameters()
    Alamofire.request(url, method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        if response.result.isSuccess {
          self.delegate?.didAddNewServiceType()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrors(jsonResponse?["reason"].stringValue)
          }
        }
    }
  }
  
  func deleteServiceStationWith(id: String) {
    let url = "\(Const.Base.url)/service_stations/\(id)"
    Alamofire.request(url, method: .delete)
      .responseJSON { response in
        guard response.result.error == nil else {
          if let error = response.result.error {
            self.delegate?.didGetErrors("Error: \(error)")
          }
          return
        }
        self.delegate?.didRemoveServiceStation()
    }
  }
  
  func getAllStations() {
    let serviceTypesUrl = "\(Const.Base.url)/service_types"
    Alamofire.request(serviceTypesUrl).responseJSON { (response) in
      guard let value = response.result.value else { return }
      var services: [String: [ServiceStation]] = [:]
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      for index in 0 ..< jsonArray.count {
        let type = ServiceType(object: jsonArray[index])
        var stations: [ServiceStation] = []
        let stationsUrl = "\(Const.Base.url)/service_types/\(type.id)/services"
        Alamofire.request(stationsUrl).responseJSON { (stationsResponse) in
          guard let stationsValue = stationsResponse.result.value else { return }
          let stationsJson = JSON(stationsValue)
          let stationsArray = stationsJson.arrayValue
          for object in stationsArray {
            stations.append(ServiceStation(object: object))
          }
          services[type.typeName] = stations
          if Array(services.keys).count == jsonArray.count {
            self.delegate?.didLoadedAllServiceStations(services: services)
          }
        }
      }
    }
  }
}

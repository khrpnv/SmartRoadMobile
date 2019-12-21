//
//  RoadsManager.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RoadsManager {
  
  private weak var delegate: RoadsManagerOutput?
  
  init(delegate: RoadsManagerOutput) {
    self.delegate = delegate
  }
  
  func getRoadsData() {
    let url = "\(Const.Base.url)/roads"
    Alamofire.request(url).responseJSON { (response) in
      guard let value = response.result.value else { return }
      let jsonObject = JSON(value)
      let jsonArray = jsonObject.arrayValue
      var roads: [Road] = []
      for object in jsonArray {
        var road = Road(object: object)
        let roadStateUrl = "\(Const.Base.url)/roads/\(road.id)/state"
        Alamofire.request(roadStateUrl).responseString { (stateResponse) in
          let result = stateResponse.result
          switch result {
          case .success(let state):
            road.state = state
            roads.append(road)
            if jsonArray.count == roads.count {
              self.delegate?.didFinishLoadingRoadsData(roads: roads)
            }
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
  
}

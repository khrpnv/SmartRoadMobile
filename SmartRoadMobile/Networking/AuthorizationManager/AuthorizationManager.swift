//
//  AuthorizationManager.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthorizationManager {
  
  private weak var delegate: AuthorizationManagerOutput?
  
  init(delegate: AuthorizationManagerOutput) {
    self.delegate = delegate
  }
  
  private func authorization(user: User, type: String, handler: Command<DataResponse<String>>) {
    let url = "\(Const.Base.url)/users/\(type)"
    let parameters = user.convertToParameters()
    Alamofire.request(url, method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseString { response in
        handler.perform(with: response)
    }
  }
  
  func logIn(user: User) {
    authorization(
      user: user,
      type: "login",
      handler: .init(with: { (response) in
      if response.result.isSuccess {
        self.delegate?.loggedUserIn()
      } else {
        if let responseData = response.data {
          let jsonResponse = try? JSON(data: responseData)
          self.delegate?.didGetErrors(jsonResponse?["reason"].stringValue)
        }
      }
    }))
  }
  
  func signUp(user: User) {
    authorization(
      user: user,
      type: "register",
      handler: .init(with: { (response) in
        if response.result.isSuccess {
          self.delegate?.signedUserUp()
        } else {
          if let responseData = response.data {
            let jsonResponse = try? JSON(data: responseData)
            self.delegate?.didGetErrors(jsonResponse?["reason"].stringValue)
          }
        }
      }))
  }
}

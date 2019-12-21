//
//  Command.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/21/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

struct Command<T> {
  private let action: (T) -> Void
  
  init(with action: @escaping (T) -> Void) {
    self.action = action
  }
  
  func perform(with value: T) {
    action(value)
  }
}

extension Command where T == Void {
  func perform() {
    perform(with: ())
  }
}

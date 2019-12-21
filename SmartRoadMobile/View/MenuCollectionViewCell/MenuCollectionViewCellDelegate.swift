//
//  MenuCollectionViewCellDelegate.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/20/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import Foundation

protocol MenuCollectionViewCellDelegate: class {
  func didPressControlButtonFor(_ item: MenuItem)
}

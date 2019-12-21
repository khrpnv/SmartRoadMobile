//
//  MenuItem.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/19/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS

enum MenuItemType {
  case driver
  case services
  case roads
  case addService
}

struct MenuItem {
  let name: String
  let background: (top: UIColor, bottom: UIColor)
  let button: String
  let titleDescription: [Languages : String]
  let cardDescription: [Languages : String]
  let type: MenuItemType
}

struct MenuItems {
  private let items: [MenuItem] = []
  
  static func getItems() -> [MenuItem] {
    let currentLanguage = LanguageManager.shared.currentLanguage
    let driver = MenuItem(
      name: currentLanguage == .en ? "Driver" : "Водій",
      background: (
        top: UIColor(red: 249.0/255.0, green: 181.0/255.0, blue: 82.0/255.0, alpha: 1.0),
        bottom: UIColor(red: 240.0/255.0, green: 93.0/255.0, blue: 112.0/255.0, alpha: 1.0)
      ),
      button: Const.Image.open,
      titleDescription: [
        .en: "Get information about nearest to you different kinds of car service stations, that are empty and build your route.",
        .uk: "Отримайте інформацію про найближчі до себе станції обслуговування авто, де є вільні місця, та побудуйте маршрут на карті."
      ],
      cardDescription: [
        .en: "If you need nearest empty place to serve your car, check this out:",
        .uk: "Якщо Ви шукаєте найближче вільне місце для обслуговування авто, то Вам сюди:"
      ],
      type: .driver
    )
    
    let services = MenuItem(
      name: currentLanguage == .en ? "Services" : "Сервіси",
      background: (
        top: UIColor(red: 213.0/255.0, green: 169.0/255.0, blue: 170.0/255.0, alpha: 1.0),
        bottom: UIColor(red: 104.0/255.0, green: 110.0/255.0, blue: 204.0/255.0, alpha: 1.0)
      ),
      button: Const.Image.open,
      titleDescription: [
        .en: "Explore actual information about all service stations, available in the system whenever you need this.",
        .uk: "Переглядайте актуальну інформацію про різні сервіси для авто, що доступні в системі в будь-який час."
      ],
      cardDescription: [
        .en: "Looking for some specific service station? Choose this:",
        .uk: "Шукаєте специфічний сервіс для авто? Оберіть це:"
      ],
      type: .services
    )
    
    let roads = MenuItem(
      name: currentLanguage == .en ? "Roads" : "Дороги",
      background: (
        top: UIColor(red: 46.0/255.0, green: 160.0/255.0, blue: 127.0/255.0, alpha: 1.0),
        bottom: UIColor(red: 0.0/255.0, green: 90.0/255.0, blue: 127.0/255.0, alpha: 1.0)
      ),
      button: Const.Image.open,
      titleDescription: [
        .en: "Observe road state whenever you need. Before going somewhere, just check, if the road you need is free of jams.",
        .uk: "Спостерігайте за станом доріг в будь-який час. Перш ніж їхати куди-небудь, перевірте, чи немає на дорозі пробок."
      ],
      cardDescription: [
        .en: "In order to get information about road state, press this button:",
        .uk: "Щоб отримати інформацію про стан дороги, натисніть цю кнопку:"
      ],
      type: .roads
    )
    
    let addService = MenuItem(
      name: currentLanguage == .en ? "Add Service" : "Додати сервіс",
      background: (
        top: UIColor(red: 39.0/255.0, green: 162.0/255.0, blue: 219.0/255.0, alpha: 1.0),
        bottom: UIColor(red: 140.0/255.0, green: 40.0/255.0, blue: 174.0/255.0, alpha: 1.0)
      ),
      button: Const.Image.add,
      titleDescription: [
        .en: "Add your service station to our system and you will increase your income very fast and easy.",
        .uk: "Додайте Вашу точку обслуговування авто до системи, і Ви зможете збільшити свій прибуток швидко та легко."
      ],
      cardDescription: [
        .en: "Want to earn more money from your service? Then this is for you:",
        .uk: "Хочете збільшити прибуток від свого сервісу? Тоді це для Вас:"
      ],
      type: .addService
    )
    
    return [driver, services, roads, addService]
  }
}

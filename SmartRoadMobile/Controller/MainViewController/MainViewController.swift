//
//  MainViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class MainViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var driversButton: UIButton!
  @IBOutlet weak var ownersButton: UIButton!
  @IBOutlet weak var roadsButton: UIButton!
  @IBOutlet weak var addServiceButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  // MARK: - Actions
  @IBAction func driversPressed(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let destVC = storyboard.instantiateViewController(identifier: "ServicesViewController") as? ServicesViewController else {
      return
    }
    destVC.isDriver = true
    let navigationController = UINavigationController(rootViewController: destVC)
    navigationController.modalPresentationStyle = .fullScreen
    self.navigationController?.pushViewController(destVC, animated: true)
  }
  
  @IBAction func ownersPressed(_ sender: Any) {
    presentScreen(id: "ServicesViewController")
  }
  
  @IBAction func roadsPressed(_ sender: Any) {
    presentScreen(id: "RoadsViewController")
  }
  
  @IBAction func addServicePressed(_ sender: Any) {
    presentScreen(id: "AddServiceViewController")
  }
}

// MARK: - Private
private extension MainViewController {
  private func setupView() {
    switch LanguageManager.shared.currentLanguage {
    case .en:
      self.title = "Menu"
    case .uk:
      self.title = "Меню"
    default:
      break
    }
    addLogoutButton()
    styleButton(button: driversButton,
                backgroundColor: #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1),
                textColor: .white)
    styleButton(button: roadsButton,
                backgroundColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),
                textColor: .white)
    styleButton(button: ownersButton,
                backgroundColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),
                textColor: .white)
    styleButton(button: addServiceButton,
                backgroundColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                textColor: .white)
  }
  
  private func addLogoutButton(){
    let barButton = UIBarButtonItem(
      image: UIImage(named: Const.Image.logout),
      style: .plain,
      target: self,
      action: #selector(logout))
    self.navigationItem.rightBarButtonItem = barButton
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 30
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = backgroundColor
  }
  
  func presentScreen(id: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destVC = storyboard.instantiateViewController(identifier: id)
    let navigationController = UINavigationController(rootViewController: destVC)
    navigationController.modalPresentationStyle = .fullScreen
    self.navigationController?.pushViewController(destVC, animated: true)
  }
}

// MARK: - ActionHandlers
private extension MainViewController {
  @objc func logout() {
    self.dismiss(animated: true, completion: nil)
  }
}

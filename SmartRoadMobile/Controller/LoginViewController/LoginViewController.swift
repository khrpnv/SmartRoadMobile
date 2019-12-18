//
//  LoginViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import Toast_Swift

class LoginViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var switchLanguageButton: UIButton!
  @IBOutlet private weak var emailDescriptionLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var logInButton: UIButton!
  @IBOutlet private weak var signUpButton: UIButton!
  
  // MARK: - Properties
  private var networkManager: Networking?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkManager = Networking()
    setupView()
    setupDelegates()
  }
  
  // MARK: - Actions
  @IBAction func switchLanguage(_ sender: Any) {
    let currentLanguage = LanguageManager.shared.currentLanguage
    let selectedLanguage: Languages
    switch currentLanguage {
    case .en:
      selectedLanguage = .uk
    case .uk:
      selectedLanguage = .en
    default:
      return
    }
    
    LanguageManager.shared.setLanguage(language: selectedLanguage,
                                       viewControllerFactory: { title -> UIViewController in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      return storyboard.instantiateInitialViewController()!
    }) { view in
      view.alpha = 0
    }
  }
  
  @IBAction func loginPressed(_ sender: Any) {
    guard
      let email = emailTextField.text,
      let password = passwordTextField.text,
      email.count > 0, password.count > 0
      else {
        showToast(message: "Input fields are empty")
        return
    }
    showActivityIndicator()
    let user = User(email: email, password: password)
    networkManager?.authorization(user: user, type: "login")
  }
  
  @IBAction func signupPressed(_ sender: Any) {
    guard
      let email = emailTextField.text,
      let password = passwordTextField.text,
      email.count > 0, password.count > 0
      else {
        showToast(message: "Input fields are empty")
        return
    }
    showActivityIndicator()
    let user = User(email: email, password: password)
    networkManager?.authorization(user: user, type: "register")
  }
  
}


// MARK: - Private
private extension LoginViewController {
  func setupView() {
    if let icon = UIImage(named: Const.Image.languageIcon)?
      .withTintColor(Const.Color.languageTint) {
      switchLanguageButton.leftImage(image: icon, renderMode: .alwaysTemplate)
    }
    emailDescriptionLabel.textColor = Const.Color.lightGray
    styleButton(button: logInButton,
                backgroundColor: Const.Color.languageTint,
                textColor: .white)
    styleButton(button: signUpButton,
                backgroundColor: .white,
                textColor: Const.Color.languageTint)
  }
  
  func setupDelegates() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
    networkManager?.setLoginDelegate(loginViewControllerInput: self)
  }
  
  func styleButton(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
    button.layer.cornerRadius = 30
    button.layer.borderWidth = 2
    button.layer.borderColor = Const.Color.languageTint.cgColor
    button.setTitleColor(textColor, for: .normal)
    button.backgroundColor = backgroundColor
  }
  
  func showToast(message: String) {
    self.view.makeToast(message, duration: 3.0, position: .bottom)
  }
  
  func showActivityIndicator() {
    self.view.makeToastActivity(.center)
  }
  
  func hideActivityIndicator() {
    self.view.hideToastActivity()
  }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 2
    textField.layer.cornerRadius = 5
    textField.layer.borderColor = Const.Color.textFieldFocusColor.cgColor
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 0
  }
}

// MARK: -
extension LoginViewController: LoginViewControllerInput {
  func didFinishSuccessfully() {
    hideActivityIndicator()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(identifier: "MainViewController")
    let navigationController = UINavigationController(rootViewController: mainVC)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
  
  func didGetErrors(_ message: String?) {
    hideActivityIndicator()
    if let message = message {
      showToast(message: message)
    }
  }
}

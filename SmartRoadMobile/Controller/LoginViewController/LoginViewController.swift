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
  
  private let gradientLayer = CAGradientLayer()
  private let topGradientColor = UIColor(red: 37.0/255.0,
                                         green: 37.0/255.0,
                                         blue: 37.0/255.0,
                                         alpha: 1.0)
  private let bottomGradientColor = UIColor(red: 5.0/255.0,
                                            green: 5.0/255.0,
                                            blue: 5.0/255.0,
                                            alpha: 1.0)
  
  // MARK: - Outlets
  @IBOutlet private weak var switchLanguageButton: UIButton!
  @IBOutlet private weak var emailDescriptionLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var logInButton: UIButton!
  @IBOutlet private weak var signUpButton: UIButton!
  @IBOutlet weak var logoWidthContraint: NSLayoutConstraint!
  @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
  
  
  // MARK: - Properties
  private var networkManager: Networking?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkManager = Networking()
    setupView()
    setupDelegates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNotificationsObserver()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
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
    guard email.isEmail else {
      showToast(message: "Invalid email address")
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
    if let icon = UIImage(named: Const.Image.languageIcon)?.withRenderingMode(.alwaysTemplate){
      switchLanguageButton.leftImage(image: icon, renderMode: .alwaysTemplate)
      switchLanguageButton.titleLabel?.textColor = .white
      switchLanguageButton.tintColor = .white
    }
    emailDescriptionLabel.textColor = Const.Color.lightGray
    styleButton(button: logInButton,
                backgroundColor: Const.Color.languageTint,
                textColor: .white)
    styleButton(button: signUpButton,
                backgroundColor: .white,
                textColor: Const.Color.languageTint)
    setGradientColor(top: topGradientColor, bottom: bottomGradientColor)
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
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  func setupNotificationsObserver() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(willShowKeyboard),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(willHideKeyboard),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}

// MARK: - LoginViewControllerInput
extension LoginViewController: LoginViewControllerInput {
  func didFinishSuccessfully() {
    hideActivityIndicator()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainVC = storyboard.instantiateViewController(identifier: "MainViewController")
    mainVC.modalPresentationStyle = .fullScreen
    present(mainVC, animated: true)
  }
  
  func didGetErrors(_ message: String?) {
    hideActivityIndicator()
    if let message = message {
      showToast(message: message)
    }
  }
}

// MARK: - Keyboard notifications handler
private extension LoginViewController {
  @objc func willShowKeyboard() {
    self.logoWidthContraint = self.logoWidthContraint.setMultiplier(multiplier: 0.4)
    logoCenterConstraint.constant = -110
    UIView.animate(withDuration: 3.0) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func willHideKeyboard() {
    self.logoWidthContraint = self.logoWidthContraint.setMultiplier(multiplier: 0.65)
    logoCenterConstraint.constant = 0
    UIView.animate(withDuration: 3.0) {
      self.view.layoutIfNeeded()
    }
  }
}

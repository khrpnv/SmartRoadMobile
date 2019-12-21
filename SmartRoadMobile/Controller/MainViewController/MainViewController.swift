//
//  MainViewController.swift
//  SmartRoadMobile
//
//  Created by Illia Khrypunov on 12/17/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import UPCarouselFlowLayout

class MainViewController: UIViewController {
  
  // MARK: - Properties
  private let cellId = "MenuCell"
  private let dataSource = MenuItems.getItems()
  
  private let gradientLayer = CAGradientLayer()
  private var topDeltaRGB: RGB = RGB(red: 249.0/255.0, green: 181.0/255.0, blue: 82.0/255.0)
  private var bottomDeltaRGB: RGB = RGB(red: 240.0/255.0, green: 93.0/255.0, blue: 112.0/255.0)
  private var startTopRGB: RGB = RGB(red: 249.0/255.0, green: 181.0/255.0, blue: 82.0/255.0)
  private var startBottomRGB: RGB = RGB(red: 240.0/255.0, green: 93.0/255.0, blue: 112.0/255.0)
  
  var currentPage: Int = 0 {
    didSet {
      let item = dataSource[currentPage]
      textViewDescription.fadeTransition(0.5)
      textViewDescription.text = item.titleDescription[LanguageManager.shared.currentLanguage]
    }
  }
  
  var pageSize: CGSize {
    guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout else {
      fatalError("Layout hasn't been set")
    }
    var pageSize = layout.itemSize
    if layout.scrollDirection == .horizontal {
      pageSize.width += layout.minimumLineSpacing
    } else {
      pageSize.height += layout.minimumLineSpacing
    }
    return pageSize
  }
  
  // MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var textViewDescription: UITextView!
  @IBOutlet private weak var titleImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupView()
    currentPage = 0
    setGradientColor(top: dataSource[0].background.top, bottom:  dataSource[0].background.bottom)
  }
  
  // MARK: - Actions
  @IBAction func logoutPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - Private
extension MainViewController {
  func setupCollectionView() {
    let nib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    collectionView.delegate = self
    collectionView.dataSource = self
    guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout else {
      return
    }
    layout.spacingMode = .overlap(visibleOffset: 30)
    layout.itemSize = CGSize(width: collectionView.bounds.height - 100,
                             height: collectionView.bounds.height)
    collectionView.backgroundColor = .clear
  }
  
  func setupView() {
    view.backgroundColor = .white
    view.layer.insertSublayer(gradientLayer, at: 0)
    if let logo = UIImage(named: Const.Image.title)?.withRenderingMode(.alwaysTemplate) {
      titleImageView.image = logo
      titleImageView.tintColor = .white
    }
  }
  
  func setGradientColor(top: UIColor, bottom: UIColor) {
    let colorTop =  top.cgColor
    let colorBottom = bottom.cgColor
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = self.view.bounds
  }
  
  func getColorRGBValues(color: UIColor) -> [CGFloat] {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    color.getRed(
      &red,
      green: &green,
      blue: &blue,
      alpha: nil)
    return [red, green, blue]
  }
  
  func presentScreen(id: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destVC = storyboard.instantiateViewController(identifier: id)
    destVC.modalPresentationStyle = .fullScreen
    self.present(destVC, animated: true, completion: nil)
  }
  
  func presentDriverScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let destVC = storyboard.instantiateViewController(identifier: "ServicesViewController") as? ServicesViewController else {
      return
    }
    destVC.isDriver = true
    destVC.modalPresentationStyle = .fullScreen
    self.present(destVC, animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MenuCollectionViewCell else {
      fatalError("No such cell")
    }
    let item = dataSource[indexPath.item]
    cell.configureWith(item: item, delegate: self)
    return cell
  }
  
  func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    return true
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
    let step = (scrollView.contentSize.width - scrollView.frame.size.width) / 3.0
    
    let colorDelta = translation.x < 0 ? 1 : -1
    let currentColor = dataSource[currentPage].background
    if (currentPage == 0 && colorDelta < 0) || (currentPage == dataSource.count - 1 && colorDelta > 0) { return }
    let nextColor = dataSource[currentPage + colorDelta].background
    
    startTopRGB = RGB(color: currentColor.top)
    startBottomRGB = RGB(color: currentColor.bottom)
    
    let calculator = GradientColorCalculator()
    
    topDeltaRGB = calculator.countColorDelta(startColor: currentColor.top,
                                                          finishColor: nextColor.top,
                                                          maxContentOffset: step)
    bottomDeltaRGB = calculator.countColorDelta(startColor: currentColor.bottom,
                                                             finishColor: nextColor.bottom,
                                                             maxContentOffset: step)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if collectionView.contentOffset.x < 0 && currentPage == 0 { return }
    if collectionView.contentOffset.x > 0 && currentPage == dataSource.count - 1 { return }
    
    startTopRGB = startTopRGB + topDeltaRGB
    startBottomRGB = startBottomRGB + bottomDeltaRGB
    setGradientColor(top: startTopRGB.color, bottom: startBottomRGB.color)
  }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
    let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
    let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
    currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
  }
}

// MARK: - ActionHandlers
private extension MainViewController {
  @objc func logout() {
    self.dismiss(animated: true, completion: nil)
  }
}

// MARK: - MenuCollectionViewCellDelegate
extension MainViewController: MenuCollectionViewCellDelegate {
  func didPressControlButtonFor(_ item: MenuItem) {
    switch item.type {
    case .driver:
      presentDriverScreen()
    case .services:
      presentScreen(id: "ServicesViewController")
    case .roads:
      presentScreen(id: "RoadsViewController")
    case .addService:
      presentScreen(id: "AddServiceViewController")
    }
  }
}

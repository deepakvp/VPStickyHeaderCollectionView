//
//  CityCollectionViewCell.swift
//  VPStickyHeaderCollectionView
//
//  Created by Deepak VP on 7/5/14.
//  Copyright (c) 2014 Deepak VP. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var cityNameLabel : UILabel!

  func setUpCellWithCityName(cityName: String) {
      cityNameLabel!.text = cityName
  }
}

//
//  ContinentStickyHeaderView.swift
//  VPStickyHeaderCollectionView
//
//  Created by Deepak VP on 7/6/14.
//  Copyright (c) 2014 Deepak VP. All rights reserved.
//

import UIKit

class ContinentStickyHeaderView: UICollectionReusableView {

  @IBOutlet weak var headerLabel : UILabel!

  func setupStickyHeaderView(header : String) {
      headerLabel.text = header
  }

}

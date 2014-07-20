//
//  CountriesViewController: .swift
//  VPStickyHeaderCollectionView
//
//  Created by Deepak VP on 7/4/14.
//  Copyright (c) 2014 Deepak VP. All rights reserved.
//

import UIKit

let cityCellReuseIdentifier : String = "cityCollectionCell"
let continentHeaderViewReuseIdentifier : String = "continentHeaderView"
let stickyheaderBackgroundColor : UIColor = UIColor(red: 219.0/255, green:219.0/255, blue:219.0/255, alpha:0.8);
let continentHeaderViewHeight = 40.0

class CountriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  var citiesInContinent = Dictionary<String, Array<String>>()

  @IBOutlet var collectionView: UICollectionView;

  override func viewDidLoad() {
    super.viewDidLoad()

    // Register header view
    let stickyHeaderViewNib : UINib = UINib(nibName: "ContinentStickyHeaderView", bundle: nil)
    collectionView.registerNib(stickyHeaderViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier)

    // Populate sample data
    populateDataSource()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // #pragma mark UICollectionViewDataSource
  func numberOfSectionsInCollectionView(collectionView: UICollectionView?) -> Int {
    return citiesInContinent.count;
  }

  func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
    let citiesKeys = Array(citiesInContinent.keys)
    let continentKeyAtSection : String = citiesKeys[section]
    let citiesArray : Array = citiesInContinent[continentKeyAtSection]!
    return citiesArray.count;
  }

  func collectionView(collectionView: UICollectionView?, cellForItemAtIndexPath indexPath: NSIndexPath?) -> UICollectionViewCell? {
    var cell = collectionView?.dequeueReusableCellWithReuseIdentifier(cityCellReuseIdentifier, forIndexPath: indexPath) as CityCollectionViewCell
    let citiesKeys = Array(citiesInContinent.keys)
    let continentKeyAtSection : String = citiesKeys[indexPath!.section]
    let citiesArray : Array = citiesInContinent[continentKeyAtSection]!
    cell.setUpCellWithCityName(citiesArray[indexPath!.row])
    return cell
  }

  func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
    var supplementaryView = collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier, forIndexPath: indexPath) as ContinentStickyHeaderView
    let keys = Array(citiesInContinent.keys)
    supplementaryView.setupStickyHeaderView(keys[indexPath!.section])
    return supplementaryView
  }

  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSizeMake(collectionView.frame.size.width, continentHeaderViewHeight)
  }

  func populateDataSource() {
    var northAmericaCities : String[] = ["New York City", "Los Angeles", "Chicago", "Toronto", "San Francisco"];
    var southAmericaCities : String[] = ["Sao Paulo", "Buenos Aires", "Rio de Janiero", "Lima", "Bogota"];
    var europeCities : String[] = ["Moscow", "Paris", "London", "Istanbul", "Frankfurt"];
    var asiaCities : String[] = ["Tokyo", "Mumbai", "Shangai", "Delhi", "Seoul"];
    var africaCities : String[] = ["Cairo", "Lagos", "Kinshasa", "Johannesburg", "Luanda"];
    var austrialaCities : String[] = ["Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide"];

    citiesInContinent =
      ["North America" : northAmericaCities,
      "South America": southAmericaCities,
      "Europe" : europeCities,
      "Asia" : asiaCities,
      "Africa" : africaCities,
      "Australia" : austrialaCities]

  }


}


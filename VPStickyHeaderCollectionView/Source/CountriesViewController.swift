//
//  CountriesViewController: .swift
//  VPStickyHeaderCollectionView
//
//  Created by Deepak VP on 7/4/14.
//  Copyright (c) 2014 Deepak VP. All rights reserved.
//

import UIKit


class CountriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var citiesInContinent = [String : [String]]()
    let cityCellReuseIdentifier = "cityCollectionCell"
    let continentHeaderViewReuseIdentifier = "continentHeaderView"
    let contientStickyHeaderViewIdentifier = "ContinentStickyHeaderView"
    let stickyheaderBackgroundColor = UIColor(red: 219.0/255, green:219.0/255, blue:219.0/255, alpha:0.8)
    let continentHeaderViewHeight = 40.0

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register header suppplementary view
        let stickyHeaderViewNib = UINib(nibName: contientStickyHeaderViewIdentifier, bundle: nil)
        collectionView.registerNib(stickyHeaderViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier)

        // Populate sample data. This will mostly be a call to data manager which eithe returns back with cached data
        // or makes a network request to get fresh data
        populateDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return citiesInContinent.count;
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let citiesKeys = Array(citiesInContinent.keys)
        let continentKeyAtSection : String = citiesKeys[section]
        let citiesArray : Array = citiesInContinent[continentKeyAtSection]!
        return citiesArray.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cityCellReuseIdentifier, forIndexPath: indexPath) as CityCollectionViewCell
        let citiesKeys = Array(citiesInContinent.keys)
        let continentKeyAtSection : String = citiesKeys[indexPath.section]
        let citiesArray : Array = citiesInContinent[continentKeyAtSection]!
        cell.setUpCellWithCityName(citiesArray[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
        var supplementaryView = collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier, forIndexPath: indexPath) as ContinentStickyHeaderView
        let keys = Array(citiesInContinent.keys)
        supplementaryView.setupStickyHeaderView(keys[indexPath!.section])
        return supplementaryView
    }

    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, CGFloat(continentHeaderViewHeight))
    }

    // MARK: Private Util methods
    private func populateDataSource() {
        var northAmericaCities : [String] = ["New York City", "Los Angeles", "Chicago", "Toronto", "San Francisco"];
        var southAmericaCities : [String] = ["Sao Paulo", "Buenos Aires", "Rio de Janiero", "Lima", "Bogota"];
        var europeCities : [String] = ["Moscow", "Paris", "London", "Istanbul", "Frankfurt"];
        var asiaCities : [String] = ["Tokyo", "Mumbai", "Shangai", "Delhi", "Seoul"];
        var africaCities : [String] = ["Cairo", "Lagos", "Kinshasa", "Johannesburg", "Luanda"];
        var austrialaCities : [String] = ["Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide"];

        citiesInContinent =
            ["North America" : northAmericaCities,
                "South America": southAmericaCities,
                "Europe" : europeCities,
                "Asia" : asiaCities,
                "Africa" : africaCities,
                "Australia" : austrialaCities]
        
    }
    
    
}


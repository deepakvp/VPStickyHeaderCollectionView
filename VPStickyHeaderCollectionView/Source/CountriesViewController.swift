// CountriesViewController: .swift
//
// Copyright (c) 2014-2015 Deepak VP
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class CountriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var citiesInContinent = [String : [String]]()
    let cityCellReuseIdentifier = "cityCollectionCell"
    let continentHeaderViewReuseIdentifier = "continentHeaderView"
    let contientStickyHeaderViewIdentifier = "ContinentStickyHeaderView"
    let stickyheaderBackgroundColor = UIColor(red: 219.0/255, green:219.0/255, blue:219.0/255, alpha:0.8)
    let continentHeaderViewHeight = 40.0

    @IBOutlet weak var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register header suppplementary view
        let stickyHeaderViewNib = UINib(nibName: contientStickyHeaderViewIdentifier, bundle: nil)
        collectionView?.registerNib(stickyHeaderViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier)

        // Populate sample data. This will mostly be a call to data provider which either returns back with cached datas
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
        let continentKeyAtSection = citiesKeys[section]
        let citiesArray = citiesInContinent[continentKeyAtSection]
        return citiesArray?.count ?? 0;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cityCellReuseIdentifier, forIndexPath: indexPath) as CityCollectionViewCell
        let citiesKeys = Array(citiesInContinent.keys)
        let continentKeyAtSection = citiesKeys[indexPath.section]
        let citiesArray = citiesInContinent[continentKeyAtSection]
        if let cityName = citiesArray?[indexPath.row] {
            cell.setUpCellWithCityName(cityName)
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: continentHeaderViewReuseIdentifier, forIndexPath: indexPath) as ContinentStickyHeaderView
        let keys = Array(citiesInContinent.keys)
        supplementaryView.setupStickyHeaderView(keys[indexPath.section])
        return supplementaryView
    }

    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
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


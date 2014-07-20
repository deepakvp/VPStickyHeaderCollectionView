//
//  VPStickyHeaderCollectionViewLayout.swift
//  VPStickyHeaderCollectionView
//
//  Created by Deepak VP on 7/4/14.
//  Copyright (c) 2014 Deepak VP. All rights reserved.
//

import UIKit

let stickyHeaderZIndex = 100

class VPStickyHeaderCollectionViewLayout: UICollectionViewFlowLayout {

  var stickyHeaderIndexPaths = Array<NSIndexPath>()

  override func prepareLayout()  {
    super.prepareLayout()

    stickyHeaderIndexPaths.removeAll(keepCapacity: true)
    let numberOfSections = collectionView.numberOfSections()
    for index in 0 .. numberOfSections {
      var indexPath = NSIndexPath(forItem: 0, inSection: index)
      stickyHeaderIndexPaths.append(indexPath)
    }
  }

  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }

  override func layoutAttributesForElementsInRect(rect: CGRect) -> AnyObject[]! {
    var attributesInRect = super.layoutAttributesForElementsInRect(rect)
    var updatedAttributesInRect = Array<UICollectionViewLayoutAttributes>()

    for obj : AnyObject in attributesInRect {
      let attribute = obj as UICollectionViewLayoutAttributes
      let attributeIndexPath = attribute.indexPath
      let representedElementKind = attribute.representedElementKind

      if (representedElementKind != UICollectionElementKindSectionHeader) {
        updatedAttributesInRect.append(attribute)
      }
    }

    for indexPath in stickyHeaderIndexPaths {
      let headerAttribute = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
      updatedAttributesInRect.append(headerAttribute)
    }

    return updatedAttributesInRect
  }

  override func layoutAttributesForSupplementaryViewOfKind(elementKind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes! {
    var layoutAttribute : UICollectionViewLayoutAttributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
    let contentOffset = collectionView.contentOffset
    var nextHeaderOrigin : CGPoint = CGRect.infiniteRect.origin
    var nextHeaderIndex : Int;

    if (indexPath.section + 1 < collectionView.numberOfSections()) {
      nextHeaderIndex = indexPath.section + 1
      let nextIndexPath : NSIndexPath = NSIndexPath(forItem: 0, inSection: nextHeaderIndex)
      var nextHeaderFrame : CGRect = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: nextIndexPath).frame
      nextHeaderOrigin = nextHeaderFrame.origin
    }
    else {
      return layoutAttribute;
    }

    var headerFrame : CGRect = layoutAttribute.frame
    if (scrollDirection == UICollectionViewScrollDirection.Vertical) {
      var nextStickyCellY : CGFloat = nextHeaderOrigin.y - headerFrame.size.height
      var currentStickyCellY : CGFloat = max(contentOffset.y, headerFrame.origin.y)
      headerFrame.origin.y = min(currentStickyCellY, nextStickyCellY)
    }
    else {
      var nextStickyCellX : CGFloat = nextHeaderOrigin.x - headerFrame.size.width
      var currentStickyCellX = max(contentOffset.x, headerFrame.origin.x)
      headerFrame.origin.x = min(currentStickyCellX, nextStickyCellX)
    }

    layoutAttribute.zIndex = stickyHeaderZIndex
    layoutAttribute.frame = headerFrame
    return layoutAttribute
  }

}

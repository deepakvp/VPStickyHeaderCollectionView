// VPStickyHeaderCollectionViewLayout.swift
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

/// A custom collection view layout to overrides the default behaviour of supplementary view
/// and provides a sticky header implementation. The implementation overrides the frame layout attribute
/// of supplementary and keeps it at positioned at the top. This handles sticky header in both vertical and
/// horizontal scrolling collectionview
///
/// TODO: Adding all indexPaths in layoutAttributesForElementsInRect might result in poor performance
/// if the collection view is large. This can be optimized to only add indexPaths which needs to be in the rect
class VPStickyHeaderCollectionViewLayout: UICollectionViewFlowLayout {

    /// Specifies the z index of the supplementary view so that they can on top of cells and decoration views
    private let stickyHeaderZIndex = 1

    /// stores the sticky header indexpaths
    private var stickyHeaderIndexPaths = [NSIndexPath]()

    // MARK - UICollectionViewLayout method overrides
    override func prepareLayout()  {
        super.prepareLayout()

        // Identifies all the section which needs a sticky supplementary header view.
        stickyHeaderIndexPaths.removeAll(keepCapacity: false)
        if let numberOfSections = collectionView?.numberOfSections() {
            for index in 0 ..< numberOfSections {
                var indexPath = NSIndexPath(forItem: 0, inSection: index)
                stickyHeaderIndexPaths.append(indexPath)
            }
        }
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // For every change in bounds we need to invalidate the layout, so that we can override the
        // supplementary frame attribute
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        // In layoutAttributesForElementsInRect, we need to get the indexpaths within the rect 
        // and add all header indexPath
        var attributesInRect = super.layoutAttributesForElementsInRect(rect)
        var updatedAttributesInRect = [UICollectionViewLayoutAttributes]()

        if let attributes = attributesInRect {
            for obj in attributes {
                let attribute = obj as UICollectionViewLayoutAttributes
                let attributeIndexPath = attribute.indexPath

                if attribute.representedElementCategory == .Cell {
                    updatedAttributesInRect.append(attribute)
                }
            }
        }

        for indexPath in stickyHeaderIndexPaths {
            let headerAttribute = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            updatedAttributesInRect.append(headerAttribute)
        }

        // Returning attributes for cell and all sticky supplmentary header views
        return updatedAttributesInRect
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let layoutAttribute  = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        let contentOffset = collectionView?.contentOffset ?? CGPointZero
        var nextHeaderOrigin = CGPointZero
        var nextHeaderIndex : Int = 0

        // Get the layout attribute of next supplementary index and use that to modify current header view
        // to get the next header pushing out the current sticky header
        if (indexPath.section + 1 < collectionView?.numberOfSections()) {
            nextHeaderIndex = indexPath.section + 1
            let nextIndexPath = NSIndexPath(forItem: 0, inSection: nextHeaderIndex)
            var nextHeaderFrame = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: nextIndexPath).frame
            nextHeaderOrigin = nextHeaderFrame.origin
        }
        else {
            return layoutAttribute;
        }

        // Override header origin
        var headerFrame = layoutAttribute.frame
        if (scrollDirection == UICollectionViewScrollDirection.Vertical) {
            var nextStickyCellY = nextHeaderOrigin.y - headerFrame.size.height
            var currentStickyCellY = max(contentOffset.y, headerFrame.origin.y)
            headerFrame.origin.y = min(currentStickyCellY, nextStickyCellY)
        }
        else {
            var nextStickyCellX = nextHeaderOrigin.x - headerFrame.size.width
            var currentStickyCellX = max(contentOffset.x, headerFrame.origin.x)
            headerFrame.origin.x = min(currentStickyCellX, nextStickyCellX)
        }

        // Set the zIndex of the supplementary view so that it can stay on top of other elements in collection view
        layoutAttribute.zIndex = stickyHeaderZIndex
        layoutAttribute.frame = headerFrame
        return layoutAttribute
    }
    
}

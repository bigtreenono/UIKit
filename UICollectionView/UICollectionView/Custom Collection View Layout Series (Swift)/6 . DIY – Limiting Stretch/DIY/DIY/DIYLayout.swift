//
//  DIYLayout.swift
//  DIY
//
//  Created by Mic Pringle on 10/03/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class DIYLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var deltaY: CGFloat = 0
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! DIYLayoutAttributes
    copy.deltaY = deltaY
    return copy
  }
  
  override func isEqual(object: AnyObject?) -> Bool {
    if let attributes = object as? DIYLayoutAttributes {
      if attributes.deltaY == deltaY {
        return super.isEqual(object)
      }
    }
    return false
  }
  
}

class DIYLayout: UICollectionViewFlowLayout {
  
  var maximumStretchHeight: CGFloat = 0
  
  override class func layoutAttributesClass() -> AnyClass {
    return DIYLayoutAttributes.self
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    let layoutAttributes = super.layoutAttributesForElementsInRect(rect) as! [DIYLayoutAttributes]
    let insets = collectionView!.contentInset
    let offset = collectionView!.contentOffset
    let minY = -insets.top
    if (offset.y < minY) {
      let deltaY = fabs(offset.y - minY)
      for attributes in layoutAttributes {
        if let elementKind = attributes.representedElementKind {
          if elementKind == UICollectionElementKindSectionHeader {
            var frame = attributes.frame
            frame.size.height = min(max(minY, headerReferenceSize.height + deltaY), maximumStretchHeight)
            frame.origin.y = CGRectGetMinY(frame) - deltaY
            attributes.frame = frame
            attributes.deltaY = deltaY
          }
        }
      }
    }
    return layoutAttributes
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
}

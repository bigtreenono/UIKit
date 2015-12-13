//
//  ScheduleHeaderView.swift
//  RWDevCon
//
//  Created by Mic Pringle on 06/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class ScheduleHeaderView: UICollectionReusableView {
  
  @IBOutlet private weak var backgroundImageView: UIView!
  @IBOutlet private weak var backgroundImageViewHeightLayoutConstraint: NSLayoutConstraint!
  
  @IBOutlet private weak var foregroundImageView: UIView!
  
    @IBOutlet weak var foregroundImageViewHeightContstaint: NSLayoutConstraint!
    
    private var backgroundImageViewHeight: CGFloat = 0
    private var foregroundImageViewHeight: CGFloat = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundImageViewHeight = CGRectGetHeight(backgroundImageView.bounds)
    foregroundImageViewHeight = CGRectGetHeight(foregroundImageView.bounds)
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
    super.applyLayoutAttributes(layoutAttributes)
    let attributes = layoutAttributes as! DIYLayoutAttributes
    backgroundImageViewHeightLayoutConstraint.constant = backgroundImageViewHeight - attributes.deltaY
    foregroundImageViewHeightContstaint.constant = attributes.deltaY + foregroundImageViewHeight
  }
  
}



























//
//  TutorialCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 02/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var timeAndRoomLabel: UILabel!
  @IBOutlet private weak var speakerLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  
  var tutorial: Tutorial? {
    didSet {
      if let tutorial = tutorial {
        titleLabel.text = tutorial.title
        timeAndRoomLabel.text = tutorial.timeAndRoom
        speakerLabel.text = tutorial.speaker
        imageView.image = tutorial.backgroundImage
      }
    }
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
    super.applyLayoutAttributes(layoutAttributes)
    imageView.transform = CGAffineTransformMakeRotation(degreesToRadians(14))
  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
    }
  
}

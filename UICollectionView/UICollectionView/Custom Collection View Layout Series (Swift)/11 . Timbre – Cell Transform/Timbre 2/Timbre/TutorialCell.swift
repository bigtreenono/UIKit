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
  
  var tutorial: Tutorial? {
    didSet {
      if let tutorial = tutorial {
        titleLabel.text = tutorial.title
        timeAndRoomLabel.text = tutorial.timeAndRoom
        speakerLabel.text = tutorial.speaker
      }
    }
  }
  
}

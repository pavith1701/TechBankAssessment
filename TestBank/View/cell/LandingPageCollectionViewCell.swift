//
//  LandingPageCollectionViewCell.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import UIKit

class LandingPageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardPrize: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgCard.layer.cornerRadius = 28     // or custom radius
        imgCard.clipsToBounds = true
    }
}

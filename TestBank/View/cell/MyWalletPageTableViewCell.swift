//
//  MyWalletPageTableViewCell.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import UIKit

class MyWalletPageTableViewCell: UITableViewCell {

    @IBOutlet weak var tableSubView: UIView!
    
    @IBOutlet weak var cardImg: UIImageView!
    
    @IBOutlet weak var coinNameLabel: UILabel!
    
    @IBOutlet weak var coinValLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableSubView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

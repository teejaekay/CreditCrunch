//
//  CardCell.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 11/1/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var bankLogo: UIImageView!
    
    func buildCell(card: CreditCard) {
        
        // set the title of the cell to the card name
        cardName.text = card.original_title
       
        if (card.img != "") {
            
            cardImage.image = UIImage(named: card.img!)
            bankLogo.image = nil
            
        } else {
            
            // getting the image name for the bank
            let imgName = card.getBankImage()
            
            cardImage.image = UIImage(named: "blank-card")
            bankLogo.image = UIImage(named: imgName)
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

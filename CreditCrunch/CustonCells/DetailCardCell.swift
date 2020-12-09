//
//  DetailCardCell.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 11/24/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailCardCell: UITableViewCell {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var benefit1: UILabel!
    @IBOutlet weak var benefit2: UILabel!
    @IBOutlet weak var bonusInfo: UILabel!
    @IBOutlet weak var annualFee: UILabel!
    @IBOutlet weak var bankLogo: UIImageView!
    
    @IBOutlet var categories: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func buildCell(card: CreditCard, region: MKCoordinateRegion) {
        
        // set the image of the card if one exists 
        if (card.img == "") {
            
            self.cardImage.image = UIImage(named: "blank-card")
            
            let bankImgName = card.getBankImage()
            self.bankLogo.image = UIImage(named: bankImgName)
            
        } else {
            
            self.cardImage.image = UIImage(named: card.img!)
            self.bankLogo.image = nil
        }
        
        // set the name of the card
        cardName.text = card.original_title
        
        // presenting 2 random benefits of a card
        benefit1.text = card.rewards.randomElement()?.title
        var str = card.rewards.randomElement()?.title
        
        while (str == benefit1.text) {
            str = card.rewards.randomElement()?.title
        }
        
        benefit2.text = str
        
        // presenting the bonus of the card
        let amount = card.bonus.amount
        let spend = card.bonus.spend
        let currency = card.bonus.currency
        let period = card.bonus.month_period
        
        // show the details of the bonus
        bonusInfo.text = getBonusText(amount: amount, spend: spend, currency: currency, period: period)
        
        // presenting the annual fee of the card
        annualFee.text = "Annual Fee: $\(card.fee!)"
        
        // presenting the categories that earn rewards for the card
        for i in 0...3 {
            
            categories[i].text = ""
            
            if (i < card.earnings.count) {
                
                categories[i].text = card.categories[card.earnings[i].category]

            }
        }
        
        // building the map
        addPins(card: card, region: region)
        self.map.setRegion(region, animated: true)
        
        
    }
    
    func getBonusText(amount: Int, spend: Int, currency: String, period: Int) -> String {
        
        var str = ""
        
        if (amount == 0) {
            str = "No welcome bonus."
        }
        
        else if (currency == "USD") {
            
            str = "Earn $\(amount) after spending $\(spend) in the first \(period) months."
            
        } else {
            
            str = "Earn \(amount) points after spending $\(spend) in the first \(period) months."
        }
        
        return str
    }
    
    func addPins(card: CreditCard, region: MKCoordinateRegion) {
        
        for reward in card.earnings {
            
            if (reward.category != 7 && reward.category != 12 && reward.category != 15) {
                
                // store the category to be search for in map search
                let category = card.categories[reward.category]
                
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = category!
                request.region = region
                
                let search = MKLocalSearch(request: request)
                
                search.start {response, _ in
                    
                    guard let response = response else {
                        return
                    }
                    
                    var matchingItems: [MKMapItem] = []
                    matchingItems = response.mapItems
                    
                    if (matchingItems.count > 1) {
                        
                        for i in 1...matchingItems.count - 1{
                            
                            let place = matchingItems[i].placemark
                            let pin = MKPointAnnotation()
                            pin.coordinate = place.coordinate
                            pin.title = place.name!
                            pin.subtitle = "\(reward.points)x PTS"
                            
                            self.map.addAnnotation(pin)
                        }
                        
                    }
                    
                }
                
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

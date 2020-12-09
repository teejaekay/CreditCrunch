//
//  CreditCard.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 10/31/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import Foundation

struct Response: Codable {
   
    var results: [CreditCard]
}

struct Rewards: Codable {
    
    let title: String

}

struct Bank: Codable {
    
    let name: String

}

struct Earnings: Codable {
    
    let points: Double
    let description: String
    let category: Int

}

struct Bonus: Codable {
    
    let amount: Int
    let spend: Int
    let currency: String
    let month_period: Int

}

struct CreditCard: Codable {
    
    let categories: [Int : String] = [1: "Airline", 2: "Cable Services", 3: "Car Rental",
                                      4: "Department Store", 5: "Drug Store", 6: "Entertainment",
                                      7: "Everywhere", 8: "Gas Station", 9: "Home Improvement",
                                      10: "Hotel", 11: "Office Supply", 12: "Online Shopping",
                                      13: "Phone Service", 14: "Restaurant", 15: "Variable",
                                      16: "Supermarket", 17: "Utility"]
    
    let original_title: String?
    let fee: Int?
    let rewards: [Rewards]
    var img: String?
    let bonus: Bonus
    let earnings: [Earnings]
    let bank: Bank

    
    func validBank() -> Bool {
        
        switch self.bank.name {
            
        case "Chase":
            return true
            
        case "American Express (AmEx)":
            return true
        
        case "Bank of America (BOA)":
            return true
            
        case "Citibank":
            return true
            
        case "US Bank":
            return true
            
        case "Discover":
            return true
            
        case "Capital One":
            return true
        
        case "Barclaycard":
            return true
            
        default:
            return false
        }
    }
    
    func getImage() -> String {
        
        switch self.original_title {
            
        case "Chase Freedom®":
            return "freedom"
            
        case "Chase Sapphire Preferred":
            return "sapphire-preferred"
            
        case "Chase Sapphire Reserve":
            return "sapphire-reserve"
            
        case "Ink Business Cash Credit Card":
            return "ink-cash-card"
            
        case "American Express® Green Card":
            return "green-card"
                   
        case "American Express Platinum (Personal)":
            return "platinum-card"
            
        case "American Express® Gold Card":
            return "gold-card"
                   
        case "Citi Prestige® Card":
            return "citi-prestige"
            
        case "Southwest Rapid Rewards Priority Card":
            return "southwest-rapid-rewards-priority"
                   
        case "Discover it® chrome":
            return "chrome"
       
        default:
            return ""
        }
    }
    
    func getBankImage() -> String {
        
        switch self.bank.name {
            
        case "Chase":
            return "chase-logo"
            
        case "American Express (AmEx)":
            return "amex-logo"
        
        case "Bank of America (BOA)":
            return "boa-logo"
            
        case "Citibank":
            return "citi-logo"
            
        case "US Bank":
            return "usbank-logo"
            
        case "Discover":
            return "discover-logo"
            
        case "Capital One":
            return "capital-one-logo"
        
        case "Barclaycard":
            return "barclays-logo"
            
        default:
            return ""
        }
    }
}

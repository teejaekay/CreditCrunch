//
//  AllCardsViewController.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 10/31/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import UIKit
import CoreLocation

class AllCardsViewController: RecommendedViewController {

    var results2: [CreditCard] = []
    var coord : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = table.dequeueReusableCell(withIdentifier: "creditCardCell", for: indexPath) as! CardCell
               
               if (results2.count > 0) {
                   
                   let card = results2[indexPath.row]
                   cell.buildCell(card: card)
                   
               } else {
                   
                   cell.cardName.text = ""
               }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedIndex: IndexPath = self.table.indexPath(for: sender as! UITableViewCell)!
        
        let card = results2[selectedIndex.row]
        
        if (segue.identifier == "showDetailView") {
            
            if let vc: CardDetailsViewController = segue.destination as? CardDetailsViewController {
                
                vc.card = card
                vc.coordinate = coord!
            }
            
        }
        
    }
}

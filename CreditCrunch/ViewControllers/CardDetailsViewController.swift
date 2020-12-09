//
//  CardDetailsViewController.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 10/31/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class CardDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var card: CreditCard?
    var region = MKCoordinateRegion()
    var span = MKCoordinateSpan()
    var coordinate = CLLocationCoordinate2D()
    
    @IBAction func addToMyCards(_ sender: Any) {
        
        let newCard = MyCard(context: self.context)
        newCard.name = self.card?.original_title
        
        do {
            
            try context.save()
            let alert = UIAlertController(title: "Success!", message: "\"\(card!.original_title!)\"\n was saved to your cards.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } catch {
            print("could not save card")
        }
        
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.span = MKCoordinateSpan.init(latitudeDelta: 0.006, longitudeDelta: 0.006)
        self.region = MKCoordinateRegion.init(center: self.coordinate, span: span)
        
        table.delegate = self
        table.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = table.dequeueReusableCell(withIdentifier: "detailCell") as! DetailCardCell
        
        cell.buildCell(card: card!, region: region)
        
        if (indexPath.row == 1) {
            
            cell.cardImage.image = nil
            cell.cardName.text = ""
            cell.bankLogo.image = nil
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 2
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        if (indexPath.row == 0) {
            return 1200
        } else {
            return 600
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
    }
}

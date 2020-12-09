//
//  RecommendedViewController.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 10/31/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import UIKit
import CoreLocation

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var results: [CreditCard] = []
    var recommendedCards: [CreditCard] = []
    let locationManager = CLLocationManager()
    var coordinate = CLLocationCoordinate2D()

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        table.delegate = self
        table.dataSource = self
        
        getData()
        
        
    }
    
    func getData() {
        
        for i in 1...23 {
            
            let pageNum: String = String(i)
            let urlAsString = "https://api.ccstack.io/v1/discover/cards?page="+pageNum+"&api_key=d34c584029fe11eb985a4f0f779a1793"
            guard let url = URL(string: urlAsString) else {
                print("invalid url")
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        
                        DispatchQueue.main.async {
                            
                            for card in decodedResponse.results {
                                
                                if (card.rewards.count > 1 && card.earnings.count > 1 && card.validBank()) {
                                    
                                    self.results.append(card)
                                    
                                    let imgName = self.results[(self.results.count - 1)].getImage()
                                    self.results[(self.results.count - 1)].img = imgName
                                    
                                    if (i == 22) {
                                        
                                        self.table.reloadData()
                        
                                        let myCardsVC = self.tabBarController?.viewControllers![1] as! MyCardsViewController
                                        myCardsVC.results = self.results
                                        let allCardsVC = self.tabBarController?.viewControllers![2] as! AllCardsViewController
                                        allCardsVC.results2 = self.results
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        return
                    }
                }
               
            } .resume()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "creditCardCell", for: indexPath) as! CardCell
        
        if (results.count > 0) {
            
            let card = results.randomElement()
            recommendedCards.append(card!)
            cell.buildCell(card: card!)
            
        } else {
            
            cell.cardName.text = ""
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (results.count == 0) {
            return 0
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedIndex: IndexPath = self.table.indexPath(for: sender as! UITableViewCell)!
        
        let card = recommendedCards[selectedIndex.row]
        
        if (segue.identifier == "showDetailView") {
            
            if let vc: CardDetailsViewController = segue.destination as? CardDetailsViewController {
                
                vc.card = card
                vc.coordinate = self.coordinate
            
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            locationManager.stopUpdatingLocation()
            
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
            
            self.coordinate = location.coordinate
            
            let allCardsVC = self.tabBarController?.viewControllers![2] as! AllCardsViewController
            allCardsVC.coord = self.coordinate
            
            let myCardsVC = self.tabBarController?.viewControllers![1] as! MyCardsViewController
            myCardsVC.coord = self.coordinate
            
        }
    }
    
}

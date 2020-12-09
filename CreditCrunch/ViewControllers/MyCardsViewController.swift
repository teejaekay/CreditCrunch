//
//  MyCardsViewController.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 10/31/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MyCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let picker = UIImagePickerController()
    
    var myCards: [MyCard]?
    var results: [CreditCard] = []
    var imgs: [UserImage]?
    var coord : CLLocationCoordinate2D?
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var userPic: UIImageView!
    
    @IBAction func editPicture(_ sender: Any) {
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        table.delegate = self
        table.dataSource = self
        
        fetchMyCards()
        fetchUserImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        fetchMyCards()
        table.reloadData()
    }
    
    func fetchUserImage() {
        
        do {
            
            self.imgs = try context.fetch(UserImage.fetchRequest())
            
        } catch {
            print("could not fetch user image")
        }
        
        if (self.imgs!.count > 0) {
            
            userPic.image = UIImage(data: self.imgs![0].img!)
        }
    }
    
    func fetchMyCards() {
        
        do {
            
            self.myCards = try context.fetch(MyCard.fetchRequest())
        
        } catch {
            print("could not fetch cards from CoreData")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let infod = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker .dismiss(animated: true, completion: nil)
        
        let newImage = infod[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        userPic.image = newImage!
        
        let gg = UserImage(context: self.context)
        gg.img = newImage!.pngData()! as Data
        
        
        if (imgs!.count > 1) {
            
            imgs![0].img = gg.img
            
        } else {
            
            imgs!.append(gg)
        }
        
        do {
            try self.context.save()
            
        } catch {
            print("could not save new image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "creditCardCell", for: indexPath) as! CardCell
        
        for card in results {
            
            if (card.original_title == myCards![indexPath.row].name) {
                
                cell.buildCell(card: card)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCards!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cardToDelete = self.myCards![indexPath.row]
        
        self.context.delete(cardToDelete)
        
        do {
            try self.context.save()
            
        } catch {
            print("could not save card after deletion")
        }
        
        fetchMyCards()
        
        self.table.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedIndex: IndexPath = self.table.indexPath(for: sender as! UITableViewCell)!
        
        let cardName = myCards![selectedIndex.row].name
        
        var index = 0
        
        while (cardName != (results[index].original_title)) {
            index += 1
        }
        
        if (segue.identifier == "showDetailView") {
            
            if let vc: CardDetailsViewController = segue.destination as? CardDetailsViewController {
                
                vc.card = results[index]
                vc.coordinate = self.coord!
            }
            
        }
        
    }
}

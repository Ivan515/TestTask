//
//  HistoryVC.swift
//  MapWithHistory
//
//  Created by Andrey Apet on 02.02.17.
//  Copyright © 2017 i.Apet. All rights reserved.
//
import UIKit
import RealmSwift

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTableView: UITableView!
    
    var adrString = [String]()
    var townString = [String]()
    var dateString = [Date]()
    var latString = [Double]()
    var longString = [Double]()
    var temperatureString = [String]()
    var forecastString = [String]()
    
    var numberOfObjects = 0
    let realm = try! Realm()
    let allReauests = try! Realm().objects(ObjectRequest.self)
    
    let reqObject = ObjectRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.queryRequsets()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1  //this is not a magic number, this is one section in talbe
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let dateForTitle = DateFormatter.localizedString(from: self.dateString[indexPath.row], dateStyle: .short, timeStyle: .none)
        let timeForTitle = DateFormatter.localizedString(from: self.dateString[indexPath.row], dateStyle: .none, timeStyle: .short)
        
        cell.cityInCell.text = self.townString[indexPath.row]
        cell.dateInCell.text = dateForTitle
        cell.timeInCell.text = timeForTitle
        cell.latInCell.text = "Latitude: \(String(self.latString[indexPath.row]))"
        cell.longInCell.text = "Longitude: \(String(self.longString[indexPath.row]))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reqObject.town = self.townString[indexPath.row]
        self.reqObject.addressString = self.adrString[indexPath.row]
        self.reqObject.dateOfRequest = self.dateString[indexPath.row]
        self.reqObject.coordinateLatitudeForUser = self.latString[indexPath.row]
        self.reqObject.coordinateLongitudeForUser = self.longString[indexPath.row]
        self.reqObject.temperatureForUser = Int(self.temperatureString[indexPath.row])!
        self.reqObject.forecastForUser = self.forecastString[indexPath.row]
        
        self.historyTableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "HistoryVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FullHistoryVC
        destinationVC.transferReq = reqObject
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.realm.beginWrite()
            self.realm.delete(self.allReauests[indexPath.row])
            self.numberOfObjects = self.allReauests.count
            self.historyTableView.reloadData()
            try! self.realm.commitWrite()
        }
    }
    
    func queryRequsets() {
        self.numberOfObjects = self.allReauests.count
        for req in self.allReauests {
            self.adrString.append(req.addressString)
            self.townString.append(req.town)
            self.dateString.append(req.dateOfRequest)
            self.latString.append(req.coordinateLatitudeForUser)
            self.longString.append(req.coordinateLongitudeForUser)
            self.forecastString.append(req.forecastForUser)
            self.temperatureString.append(String(req.temperatureForUser))
            self.historyTableView.reloadData()
        }
    }
}

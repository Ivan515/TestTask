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
    
    var addressString = [String]()
    var dateString = [Date]()
    var latString = [Double]()
    var longString = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        
//        self.queryRequsets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.queryRequsets()
    }
    
    func queryRequsets() {
        let realm = try! Realm()
        let allReauests = realm.objects(ObjectRequest.self)
        for req in allReauests {
            self.addressString.append(req.addressString)
            self.dateString.append(req.dateOfRequest)
            self.latString.append(req.coordinateLatitudeForUser)
            self.longString.append(req.coordinateLongitudeForUser)
            self.historyTableView.reloadData()
            print(req)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.historyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        
        
        let dateForTitle = DateFormatter.localizedString(from: self.dateString[indexPath.row], dateStyle: .short, timeStyle: .none)
        let timeForTitle = DateFormatter.localizedString(from: self.dateString[indexPath.row], dateStyle: .none, timeStyle: .short)
        
        cell.cityInCell.text = self.addressString[indexPath.row]
        cell.dateInCell.text = dateForTitle
        cell.timeInCell.text = timeForTitle
        cell.latInCell.text = String(self.latString[indexPath.row])
        cell.longInCell.text = String(self.longString[indexPath.row])
        
        return cell
    }
    
}

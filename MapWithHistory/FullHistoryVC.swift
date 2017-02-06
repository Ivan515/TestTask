//
//  FullHistoryVC.swift
//  MapWithHistory
//
//  Created by Andrey Apet on 05.02.17.
//  Copyright © 2017 i.Apet. All rights reserved.
//

import UIKit

class FullHistoryVC: UIViewController {

    
    @IBOutlet weak var dateOfReq: UILabel!
    @IBOutlet weak var addressOfReq: UILabel!
    @IBOutlet weak var latOfReq: UILabel!
    @IBOutlet weak var longOfReq: UILabel!
    @IBOutlet weak var temperatuteOfReq: UILabel!
    @IBOutlet weak var forecastOfReq: UILabel!
    
    var transferReq = ObjectRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        self.dateOfReq.text = DateFormatter.localizedString(from: transferReq.dateOfRequest, dateStyle: .medium, timeStyle: .short)
        self.addressOfReq.text = "\(transferReq.town), \(transferReq.addressString)"
        self.latOfReq.text = String(transferReq.coordinateLatitudeForUser)
        self.longOfReq.text = String(transferReq.coordinateLongitudeForUser)
        self.temperatuteOfReq.text = String(transferReq.temperatureForUser)
        self.forecastOfReq.text = transferReq.forecastForUser
    }
}

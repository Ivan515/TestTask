//
//  ObjectRequest.swift
//  MapWithHistory
//
//  Created by Andrey Apet on 02.02.17.
//  Copyright © 2017 i.Apet. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectRequest: Object {
    
    var addressString = ""
    var coordinateLatitudeForUser = 0.0
    var coordinateLongitudeForUser = 0.0
    var temperatureForUser = 0
    var forecastForUser = ""
    var dateOfRequest = Date()

}

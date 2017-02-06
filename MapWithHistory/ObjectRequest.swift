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
    
    dynamic var addressString = ""
    dynamic var town = ""
    dynamic var coordinateLatitudeForUser = 0.0
    dynamic var coordinateLongitudeForUser = 0.0
    dynamic var temperatureForUser = 0
    dynamic var forecastForUser = ""
    dynamic var dateOfRequest = Date()

}

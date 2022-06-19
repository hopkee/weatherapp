//
//  FloatExtensions.swift
//  WeatherApp
//
//  Created by Valya on 18.06.22.
//

import Foundation

extension Double {
    var removeZero: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

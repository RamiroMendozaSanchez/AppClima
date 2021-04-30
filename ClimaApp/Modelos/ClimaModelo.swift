//
//  ClimaModelo.swift
//  ClimaApp
//
//  Created by Ramiro y Jennifer on 27/04/21.
//

import Foundation

struct ClimaModelo{
    let temp: Double
    let nombreCiudad: String
    let id: Int
    let humedad:Int
    //propiedades calculadas
    var tempString: String{
        return String(format: "%.1f", temp)
    }
    
    
    var condicionClima: String{
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.hail"
        case 500...531:
            return "cloud.sleet"
        case 600...622:
            return "snow"
        case 700...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
    
    
}

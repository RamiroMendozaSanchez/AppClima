//
//  ClimaManager.swift
//  ClimaApp
//
//  Created by Ramiro y Jennifer on 25/04/21.
//

import Foundation
import CoreLocation

protocol ClimaManagerDelegado {
    func actualizarClima(clima: ClimaModelo)
    
    func huboError(erro: Error)
}

struct ClimaManager {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=8e7b63d4e3498aded9a8135084330265&units=metric&lang=es"
    
    //Quien sea el delegado deberá implementar este protocolo
    var delegado: ClimaManagerDelegado?
    
    func buscarClima(ciudad: String){
        let urlString = "\(climaURL)&q=\(ciudad)"
        realizarSolicitud(urlString: urlString)
    }
    
    func buscarClimaGPS(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(lon)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String){
        //1.- Crear una URL
        if let url = URL(string: urlString){
            //2.- Crear una URLSession
            let session = URLSession(configuration: .default)
            //3.- Asignarle una tarea a la URLSession
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    delegado?.huboError(erro: error!)
                    return
                }
                if let datosSeguros = datos {
                    //Parsear JSON
                    if let objClima = self.pasearJSON(datosClima: datosSeguros){
                        
                        //madar ese obj al VC principal
                        //let ClimaVC = ClimaViewController()
                        //ClimaVC.actualizarClima(objclima: objClima)
                        //Designar un delegado
                        self.delegado?.actualizarClima(clima: objClima)
                    }
                }
            }
            //4.- Iniciar la tarea
            tarea.resume()
        }
    }
    
    func pasearJSON(datosClima: Data) -> ClimaModelo?{
        //Creara un decodificador JSON
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados = try decodificador.decode(ClimaDatos.self, from: datosClima)
            //Imprimir los datos de la API en un formato especifico u ordenado
            let id = datosDecodificados.weather[0].id
            let ciudad = datosDecodificados.name
            let temp = datosDecodificados.main.temp
            let humedad = datosDecodificados.main.humidity
            let objClima = ClimaModelo(temp: temp, nombreCiudad: ciudad, id: id, humedad: humedad)
            
            print(objClima.condicionClima)
            print(objClima.tempString)
            return objClima
        } catch  {
            delegado?.huboError(erro: error)
            return nil
        }
    }
    
    
}

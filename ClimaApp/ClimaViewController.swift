//
//  ViewController.swift
//  ClimaApp
//
//  Created by marco rodriguez on 01/04/21.
//

import UIKit
import CoreLocation

class ClimaViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegado, CLLocationManagerDelegate {
    
    var latitud: CLLocationDegrees?
    var longitud: CLLocationDegrees?
    
    func huboError(erro: Error) {
        print(erro.localizedDescription)
        DispatchQueue.main.async {
            let alerta = UIAlertController(title: "ERROR", message: "Lugar no encontrado", preferredStyle: .actionSheet)
            
            let accionOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alerta.addAction(accionOK)
            
            self.present(alerta, animated: true, completion: nil)
        }
    }
    

    var climaManager = ClimaManager()
    //ayudar a obtener las coordenasdas o ubicación del usuario
    var climaLocationManager = CLLocationManager()
    
    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var condicionClimaImageView: UIImageView!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var humedad: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        climaLocationManager.delegate = self
        
        //solicitar el permiso del usuario para acceder a la ubicación
        climaLocationManager.requestWhenInUseAuthorization()
        
        //rastrear la ubicacción en todo momento
        climaLocationManager.requestLocation()
        
        //Establecer esta clase como delegado del ClimaManager
        climaManager.delegado = self
        
        buscarTextField.delegate = self
    }


    @IBAction func buscarButton(_ sender: UIButton) {
        //Para ocultar el teclado virtual
        buscarTextField.endEditing(true)
        //print(buscarTextField.text!)
        //ciudadLabel.text = buscarTextField.text
    }
    
    @IBAction func GPSButton(_ sender: UIButton) {
        climaManager.buscarClimaGPS(lat: latitud! , lon: longitud!)
    }
    //MARK:Métodos del delegado
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Para ocultar el teclado virtual
        buscarTextField.endEditing(true)
        //print(buscarTextField.text!)
        //ciudadLabel.text = buscarTextField.text
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTextField.text != ""{
            return true
        }else{
            buscarTextField.placeholder = "Escribe algo.."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //limpiar el textField
        climaManager.buscarClima(ciudad: buscarTextField.text!)
        buscarTextField.text = ""
        
    }
    
    func actualizarClima(clima: ClimaModelo){
        DispatchQueue.main.async {
            self.temperaturaLabel.text = clima.tempString
            self.ciudadLabel.text = clima.nombreCiudad
            self.condicionClimaImageView.image = UIImage(systemName: clima.condicionClima)
            self.humedad.text = "\(clima.humedad) %"
        }
    }
    
    //MARK: Métodos de ubicación
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubicacion = locations.last{
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            self.latitud = latitud
            self.longitud = longitud
            print("Se obtuvo la ubicacion lat: \(latitud) long: \(longitud)")
            climaManager.buscarClimaGPS(lat: latitud, lon: longitud)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación")
    }
}

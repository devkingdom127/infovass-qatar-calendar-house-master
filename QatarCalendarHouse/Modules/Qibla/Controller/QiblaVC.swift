//
//  QiblaVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/8/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import CoreLocation
import Adhan

class QiblaVC: UIViewController, Storyboarded {
    
    @IBOutlet var imageCompassArrow: UIImageView!
    @IBOutlet var imageCompassBG: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var labelDegree: UILabel!
    
    // MARK: - Properties
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = CLActivityType.other
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 1000.0
        return locationManager
    }()
    var currentLocation : CLLocation?
    var askForAuthorizationIfNeeded = true
    let accuracy = 3.0 // as degree
    let shouldDisplayHeadingCalibration = true
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tryStartUpdating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func isLocationServiceAuthorized() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() == false {
            return false // globally disabled.
        }
        var status : Bool
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            status = true
            break
        case .denied, .restricted, .notDetermined:
            status = false
            break
        @unknown default:
            status = false
            break
        }
        
        return status
    }
    
    
    func tryStartUpdating() {
        if isLocationServiceAuthorized(){
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            self.currentLocation = locationManager.location
        } else {
            if self.askForAuthorizationIfNeeded && locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                    locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
}

extension QiblaVC: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let magneticHeading = newHeading.trueHeading //degrees
        let currentAngle = Double(magneticHeading)

        guard let coordinate = self.currentLocation?.coordinate else { return }
        
        let angleOfQibla = Qibla(coordinates: Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)).direction
        
        var rotationInDegree = currentAngle - angleOfQibla
                        
        if fabs(currentAngle - angleOfQibla) <= accuracy {
            labelDegree.text = "انت الآن تواجه القبلة"
        } else {
            let degree = Int(rotationInDegree)
            labelDegree.text = "تحرك  \(abs(degree))˚ \(degree > 0 ? "جهة اليسار" : "جهة اليمين") حتى تواجه القبلة"
        }

        rotationInDegree = fmod((rotationInDegree + 360), 360);  //just to be on the safe side :-)

        self.imageCompassArrow.transform = CGAffineTransform(rotationAngle: CGFloat((angleOfQibla-newHeading.trueHeading) * Double.pi / 180));
        self.imageCompassBG.transform = CGAffineTransform(rotationAngle: CGFloat(fmod((newHeading.trueHeading + 343), 360) * Double.pi / 180))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.tryStartUpdating()
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return shouldDisplayHeadingCalibration
    }
}

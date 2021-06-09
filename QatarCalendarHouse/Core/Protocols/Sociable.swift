//
//  Sociable.swift
//
//  Created by Amr Salman on 7/4/18.
//  Copyright © 2018 Amr Salman. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

protocol Sociable: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func openInstagramAccount(withID id: String)
    func openTwitterAccount(withID id: String)
    func openFacebookAccount(withID id: String)
    func openSnapchatAccount(withID id: String)
    func sendEmail(to email: String, withDefaultMessage message: String)
    func call(_ mobileNumber: String)
    func openMapps(name: String, location: (lat: String, long: String))
    func openMapps(name: String, location: (lat: Double, long: Double))
}

extension UIViewController: Sociable {
    
    //MARK: - Actions
    
    func openMapps(name: String, location: (lat: Double, long: Double)) {
        self.openMapps(name: name, location: (lat: "\(location.lat)", long: "\(location.long)"))
    }
    
    func openMapps(name: String, location: (lat: String, long: String)) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            self.openLocationInGoogleMaps(name: name, location: location)
        }))
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            self.openLocationInMaps(name: name, location: location)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    func openFacebookAccount(withID id: String) {
        deeplink(to: "fb://facebook.com/\(id)/", or: "https://www.facebook.com/\(id)/")
    }
    
    func openTwitterAccount(withID id: String) {
        deeplink(to: "twitter://user?screen_name=\(id)", or: "https://twitter.com/\(id)")
    }
    
    func openSnapchatAccount(withID id: String) {
        deeplink(to: "snapchat://add/\(id)", or: "https://www.snapchat.com/add/\(id)/")
    }
    
    func openInstagramAccount(withID id: String) {
        deeplink(to: "instagram://user?username=\(id)", or: "https://instagram.com/\(id)/")
    }
    
    func call(_ mobileNumber: String) {
        guard let telURL = URL(string: "tel://\(mobileNumber)") else { return }
        if UIApplication.shared.canOpenURL(telURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(telURL)
            } else {
                UIApplication.shared.openURL(telURL)
            }
        }
    }
    
    func sendEmail(to email: String, withDefaultMessage message: String = "") {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients([email])
            composer.setMessageBody(message, isHTML: false)
            self.present(composer, animated: true, completion: nil)
        } else {
            error(withMessage: NSLocalizedString("Can't send Email", comment: "Error with sending email"))
        }
    }
    
    //MARK: - Helpers
    
    private func openLocationInMaps(name: String, location: (lat: String, long: String)) {
        
        guard let latitude = Double(location.lat) else { return }
        guard let longitude = Double(location.long) else { return }
        
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func openLocationInGoogleMaps(name: String, location: (lat: String, long: String)) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=&daddr=\(location.lat),\(location.long)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Google Maps should be installed on your device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Install Google Maps", style: .default, handler: { _ in
                guard let url  = URL(string: "itms-apps://itunes.apple.com/app/google-maps-gps-navigation/id585027354") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith
        result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
            break
        case MFMailComposeResult.saved:
            print("Mail saved")
            break
        case MFMailComposeResult.sent:
            print("Mail sent")
            break
        case MFMailComposeResult.failed:
            guard let error = error else { return }
            self.error(withMessage: error.localizedDescription)
        @unknown default:
            print("Not handeld")
        }

        dismiss(animated: true, completion: nil)
    }
    
    private func deeplink(to deeplink: String, or alternative: String) {
        guard let deeplinkURL: URL = URL(string: deeplink) else { return }
        guard let webURL: URL = URL(string: alternative) else { return }
        if UIApplication.shared.canOpenURL(deeplinkURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(deeplinkURL)
            } else {
                UIApplication.shared.openURL(deeplinkURL)
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL)
            } else {
                UIApplication.shared.openURL(webURL)
            }
        }
    }
    
    private func error(withMessage message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert action title"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

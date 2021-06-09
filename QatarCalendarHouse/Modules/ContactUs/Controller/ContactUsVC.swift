//
//  ContactUsVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/26/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit

class ContactUsVC: UIViewController, Storyboarded {

    
    //MARK: - Outlets
    
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelTelephone: UILabel!
    @IBOutlet weak var labelFax: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonFacebook: UIButton!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var buttonInstagram: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var buttonWebsite: UIButton!
    @IBOutlet weak var buttonYoutube: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewFax: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var labelMailBox: UILabel!
    
    //MARK: - Properties
    
    private let model = ContactUsModel()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startLoading(shouldFreeze: false)
        firstly {
            self.model.requestSettings()
        }.done { [weak self] in
            self?.setup(with: $0)
        }.ensure { [weak self] in
            self?.stopLoading()
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
    
    //MARK: - Actions
        
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers

    private func setup(with items: [String: String]) {
        viewPhone.isHidden = items[SettingType.phone.rawValue] == nil && items[SettingType.telephone.rawValue] == nil
        labelPhone.text = "\(items[SettingType.phone.rawValue] ?? "")"
        let phoneTap = UITapGestureRecognizer(target: self, action:#selector(self.phoneNumberLabelTap))
        labelPhone.addGestureRecognizer(phoneTap)
        
        labelTelephone.text = "\(items[SettingType.telephone.rawValue] ?? "")"
        let telephoneTap = UITapGestureRecognizer(target: self, action:#selector(self.telephoneNumberLabelTap))
        labelTelephone.addGestureRecognizer(telephoneTap)
        
        viewFax.isHidden = true
        labelFax.text = items[SettingType.fax.rawValue]
        viewEmail.isHidden = items[SettingType.email.rawValue] == nil
        labelEmail.text = items[SettingType.email.rawValue]
        let emailTap = UITapGestureRecognizer(target: self, action:#selector(self.emailLabelTap))
        labelEmail.addGestureRecognizer(emailTap)
        
        viewAddress.isHidden = items[SettingType.address.rawValue] == nil
        labelAddress.text = items[SettingType.address.rawValue]
        labelMailBox.isHidden = items[SettingType.mailbox.rawValue] == nil
        labelMailBox.text = items[SettingType.mailbox.rawValue]
        buttonTwitter.isHidden = items[SettingType.twitter.rawValue] == nil
        buttonWebsite.isHidden = items[SettingType.website.rawValue] == nil
        buttonYoutube.isHidden = items[SettingType.youtube.rawValue] == nil

        buttonTwitter.addTargetClosure { [weak self] _ in
            if let url = URL(string: items[SettingType.twitter.rawValue] ?? "") {
                self?.openTwitterAccount(withID: url.lastPathComponent)
            } else {
                self?.open(link: items[SettingType.twitter.rawValue])
            }
        }
//        buttonFacebook.isHidden = items[SettingType.facebook.rawValue] == nil
//        buttonFacebook.addTargetClosure { [weak self] _ in
//            if let url = URL(string: items[SettingType.facebook.rawValue] ?? "") {
//                self?.openFacebookAccount(withID: url.lastPathComponent)
//            } else {
//                self?.open(link: items[SettingType.facebook.rawValue])
//            }
//        }
        buttonInstagram.isHidden = items[SettingType.instagram.rawValue] == nil
        buttonInstagram.addTargetClosure { [weak self] _ in
            if let url = URL(string: items[SettingType.instagram.rawValue] ?? "") {
                self?.openInstagramAccount(withID: url.lastPathComponent)
            } else {
                self?.open(link: items[SettingType.instagram.rawValue])
            }
        }
        buttonWebsite.addTargetClosure { [weak self] _ in
            self?.open(link: items[SettingType.website.rawValue])
        }
        buttonYoutube.addTargetClosure { [weak self] _ in
            self?.open(link: items[SettingType.youtube.rawValue])
        }
        buttonMap.isHidden = false
        if let lat = items[SettingType.lat.rawValue], let latValue = Double(lat),
            let lang = items[SettingType.lang.rawValue], let langValue = Double(lang) {
            buttonMap.addTargetClosure { _ in
                self.openMapps(name: "دار التقويم", location: (lat: latValue, long: langValue))
            }
        }
    }

    @objc func phoneNumberLabelTap() {
        let phoneUrl = URL(string: "telprompt:\(labelPhone.text ?? "")")!
        if(UIApplication.shared.canOpenURL(phoneUrl)) {
            UIApplication.shared.open(phoneUrl)
        }
    }

    @objc func telephoneNumberLabelTap() {
        let telephoneUrl = URL(string: "telprompt:\(labelTelephone.text ?? "")")!
        if(UIApplication.shared.canOpenURL(telephoneUrl)) {
            UIApplication.shared.open(telephoneUrl)
        }
    }

    @objc func emailLabelTap() {
        let emailUrl = URL(string: "mailto:\(labelEmail.text ?? "")")!
        if(UIApplication.shared.canOpenURL(emailUrl)) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func open(link: String?) {
        guard let link = link, let url = URL(string: link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

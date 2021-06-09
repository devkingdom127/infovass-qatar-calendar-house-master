//
//  NotificationsVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/5/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import PromiseKit
import AVFoundation
import DLRadioButton

class NotificationsVC: UIViewController, Storyboarded {
    
    //MARK: - Outlets
    
    @IBOutlet weak var switchAzan: UISwitch!
    @IBOutlet weak var switchIqama: UISwitch!
    @IBOutlet weak var labelAzanIqamaDifference: UILabel!
    @IBOutlet weak var fieldSelectedPray: UITextField!
    @IBOutlet var buttonsAzanIqamaDifference: [UIButton]!
    @IBOutlet var collectionSwitchesPray: [UISwitch]!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var lightModeButton: UIButton!
    @IBOutlet weak var lightModeLabel: UILabel!
    @IBOutlet weak var azanSoundPlayButton: UIButton!
    @IBOutlet weak var toneSoundPlayButton: UIButton!
    @IBOutlet weak var azanSoundSelectionButton: DLRadioButton!
    @IBOutlet weak var toneSoundSelectionButton: DLRadioButton!

    //MARK: - Properties
    
    let model = NotificationsModel()
    lazy var pickerNotificationType: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    var selectedType: NotificationType = .fajr {
        didSet {
            fieldSelectedPray.text = selectedType.displayTitle
            setupSwitches()
        }
    }
    
    var iqamaDifference: Int = 10 {
        didSet {
            labelAzanIqamaDifference.text = "\(iqamaDifference)"
            UserDefaults.standard.azanIqamaNotificationPreference[selectedType.rawValue] = iqamaDifference
        }
    }
    
    var player: AVAudioPlayer?

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAppAppearance()
        azanSoundPlayButton.addTarget(self, action: #selector(playAzanSound), for: .touchUpInside)
        toneSoundPlayButton.addTarget(self, action: #selector(playToneSound), for: .touchUpInside)
        fieldSelectedPray.inputView = pickerNotificationType
        selectedType = .fajr
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        buttonsAzanIqamaDifference.forEach { $0.shape = .circular }
        labelAzanIqamaDifference.shape = .circular
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.refresh()
            .done(on: .main) { [weak self] in
                self?.showCompleted {
                    
                }
            }.catch(on: .main) { [weak self] in
                self?.stopLoading(withErrorMessage: $0.localizedDescription)
            }
        }
    }
    
    func applyAppAppearance() {
        let appearance = UserDefaults.standard.appearance
        if appearance == "dark" {
            darkModeButton.setImage(#imageLiteral(resourceName: "moon_red"), for: .normal)
            darkModeLabel.textColor = R.color.primary()
            lightModeButton.setImage(#imageLiteral(resourceName: "sun_black"), for: .normal)
            lightModeLabel.textColor = R.color.black()
        } else if appearance == "light" {
            lightModeButton.setImage(#imageLiteral(resourceName: "sun_red"), for: .normal)
            lightModeLabel.textColor = R.color.primary()
            darkModeButton.setImage(#imageLiteral(resourceName: "moon_black"), for: .normal)
            darkModeLabel.textColor = R.color.black()
        }
    }
    
    //MARK: - Actions
    
    @objc private func playAzanSound() {
        playSound(resourceName: "azan")
    }

    @objc private func playToneSound() {
        playSound(resourceName: "beeb")
    }

    private func playSound(resourceName: String) {
        let extensionName = "caf"
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: extensionName) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }


    @IBAction func onDarkModeButtonTouched(_ sender: UIButton) {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
              let window = app.window else { return }
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.appearance = "dark"
            applyAppAppearance()
        }
    }

    @IBAction func onLightModeButtonTouched(_ sender: UIButton) {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
              let window = app.window else { return }
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
            UserDefaults.standard.appearance = "light"
            applyAppAppearance()
        }
    }

    @IBAction private func logSelectedButton(radioButton: DLRadioButton) {
        UserDefaults.standard.azanSoundTurnOff = !azanSoundSelectionButton.isSelected
    }

    @IBAction func onPraySwitchValueChanged(_ sender: UISwitch) {
        switch sender {
        case switchAzan:
            if switchAzan.isOn != UserDefaults.standard.azanNotificationPreference?.contains(selectedType) {
                changeStatus(for: selectedType, isAzan: true, isActive: switchAzan.isOn)
            }
        case switchIqama:
            if switchIqama.isOn != UserDefaults.standard.iqamaNotificationPreference?.contains(selectedType) {
                changeStatus(for: selectedType, isAzan: false, isActive: switchIqama.isOn)
            }
        default: break
        }
    }
    
    @IBAction func onChangeIqamaDifference(_ sender: UIButton) {
        if (iqamaDifference <= 1 && sender.tag == 1) ||
            (iqamaDifference >= 60 && sender.tag == 2) { return }
        if sender.tag == 1 {
            iqamaDifference -= 1
        } else {
            iqamaDifference += 1
        }
    }
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    //MARK: - Helpers

    private func setupSwitches() {
        collectionSwitchesPray.forEach {
            $0.semanticContentAttribute = .forceRightToLeft
        }
        switchAzan.isOn = UserDefaults.standard.azanNotificationPreference?.contains(selectedType) ?? false
        switchIqama.isOn = UserDefaults.standard.iqamaNotificationPreference?.contains(selectedType) ?? false
        azanSoundSelectionButton.isSelected = !UserDefaults.standard.azanSoundTurnOff
        azanSoundSelectionButton.otherButtons.first?.isSelected = UserDefaults.standard.azanSoundTurnOff
        
        if let chosenValue = UserDefaults.standard.azanIqamaNotificationPreference[selectedType.rawValue] {
            iqamaDifference = chosenValue
        } else {
            iqamaDifference = 10
        }
    }
    
    private func changeStatus(for type: NotificationType, isAzan: Bool, isActive: Bool) {
        if isAzan {
            if isActive {
                UserDefaults.standard.azanNotificationPreference?.append(type)
            } else {
                UserDefaults.standard.azanNotificationPreference?.removeAll(where: { $0 == type } )
                _ = model.deactivateNotification(ofType: type, isAzan: true)
            }
        } else {
            if isActive {
                UserDefaults.standard.iqamaNotificationPreference?.append(type)
            } else {
                UserDefaults.standard.iqamaNotificationPreference?.removeAll(where: { $0 == type } )
                UserDefaults.standard.azanIqamaNotificationPreference.removeValue(forKey: type.rawValue)
                _ = model.deactivateNotification(ofType: type, isAzan: false)
            }
        }
    }
}

extension NotificationsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NotificationType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NotificationType.allCases[row].displayTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedType = NotificationType.allCases[row]
    }
}

//
//  AstrologicalDetailsVC.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 3/25/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit

class AstrologicalDetailsVC: UIViewController, Storyboarded {

    //MARK: - Outlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelBigTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    //MARK: - Properties
    
    var model: AstrologicalDetailsModel?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - Actions
    
    @IBAction func onCloseButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    private func setup() {
        guard let model = model else { return }
        model.requestContent().done {
            self.labelTitle.superview?.isHidden = false
            self.labelTitle.text = $0.title
            self.labelBigTitle.text = $0.title
            self.labelDescription.text = $0.description
        }.catch { [weak self] in
            self?.stopLoading(withErrorMessage: $0.localizedDescription)
        }
    }
}

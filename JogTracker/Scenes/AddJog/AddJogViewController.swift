//
//  AddJogViewController.swift
//  JogTracker
//
//  Created by Prostor9 on 10/29/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

protocol AddJogViewControllerDelegate: class {
    func dataDidSave()
}

class AddJogViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    static func create(with jog: Jog? = nil) -> AddJogViewController? {
        guard let addJogViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddJogViewController") as? AddJogViewController else { return nil }
        addJogViewController.jogModel = jog
        return addJogViewController
    }
    
    @IBOutlet private weak var topBarView: TopBarView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var distanceTextField: UITextField!
    @IBOutlet private weak var timeTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    
    weak var delegate: AddJogViewControllerDelegate?
    
    private var jogModel: Jog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareTextFields()
    }

    // MARK: Actions
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let jog = makeJog() else { return }
        
        let sendMethod: NetworkService.SendMethod = (jogModel == nil) ? .add : .update
        NetworkService.shared.sendJog(jog: jog, sendMethod: sendMethod) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.delegate?.dataDidSave()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(_):
                    self?.showAlert(withTitle: "Error", message: "Data didn't save", buttonTitle: "OK")
                }
            }
        }
    }
    
    // MARK: Private functions
    private func setupUI() {
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.cornerRadius = 21
    }
    
    private func prepareTextFields() {
        guard let jog = jogModel else { return }
        distanceTextField.text = String(jog.distance)
        timeTextField.text = String(jog.time)
        dateTextField.text = prepareDateForShowing(jog.date)
    }
    
    private func makeJog() -> Jog? {
        if let distanceText = distanceTextField.text,
            let timeText = timeTextField.text,
            let dateText = dateTextField.text,
            let distance = Float(distanceText),
            let time = Float(timeText),
            let date = validateDate(dateText) {
            
            let jog = Jog(id: jogModel?.id ?? 0, userId: jogModel?.userId ?? "", date: date, distance: distance, time: time)
            return jog//Jog(date: date, distance: distance, time: time)
        } else {
            showAlert(withTitle: "Error", message: "Data isn't valid", buttonTitle: "OK")
            return nil
        }
    }
    
    private func validateDate(_ text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: text)
    }
    
    private func prepareDateForShowing(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}


// MARK: - UITextFieldDelegate
extension AddJogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

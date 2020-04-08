//
//  AddNewLocationViewController.swift
//  CodeTest
//
//  Created by Özgür Ersöz on 8.04.2020.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation
import UIKit

class AddNewLocationViewController: UIViewController {
    
    private var controller: AddNewLocationController!

    static func create(controller: AddNewLocationController) -> AddNewLocationViewController {
        let viewController = Storyboard.Main.view(controllerClass: AddNewLocationViewController.self)
        viewController.controller = controller
        return viewController
    }

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var tempertureField: UITextField!
    @IBOutlet weak var statusField: UITextField!
    let statuses =  ["CLOUDY","SUNNY","MOSTLY_SUNNY","PARTLY_SUNNY_RAIN","THUNDER_CLOUD_AND_RAIN","TORNADO","BARELY_SUNNY","LIGHTENING","SNOW_CLOUD","RAINY","PARTLY_SUNNY"]
    override func viewDidLoad() {
        super.viewDidLoad()
        statusField.inputView = pickerView
        statusField.resignFirstResponder()
        
        idField.becomeFirstResponder()
        controller.bind(view: self)
        setup()
    }

    private func setup() {
        title = "Weather Add"
    }
    
    @IBAction func saveButton(_ sender: Any) {
        controller.saveLocation(id: idField.text ?? "", city: cityField.text ?? "", status: statusField.text ?? "", temperture: tempertureField.text ?? "")
    }
}

extension AddNewLocationViewController: AddNewLocationViewLogic {
    func navigateToBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}

extension AddNewLocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusField.text = statuses[row]
    }
}

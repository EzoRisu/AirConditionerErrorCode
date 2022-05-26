//
//  DetailViewController.swift
//  AirConditionerErrorCode
//
//  Created by Yoshiyuki Karikome on 2022/05/23.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var ErrorCodeTextField: UITextField!
    @IBOutlet weak var ManufacturerTextField: UITextField!
    @IBOutlet weak var UnitTextField: UITextField!
    @IBOutlet weak var DiscriptionTextField: UITextField!
    @IBOutlet weak var CauseTextField: UITextField!
    
    let realm = try! Realm()
    var errorCode: ErrorCode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        ErrorCodeTextField.text = errorCode.errorCode
        ManufacturerTextField.text = errorCode.manifacturer
        UnitTextField.text = errorCode.unit
        DiscriptionTextField.text = errorCode.discription
        CauseTextField.text = errorCode.cause
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        if self.ErrorCodeTextField.text! != "" {
            try! realm.write {
                self.errorCode.errorCode = self.ErrorCodeTextField.text!
                self.errorCode.manifacturer = self.ManufacturerTextField.text!
                self.errorCode.unit = self.UnitTextField.text!
                self.errorCode.discription = self.DiscriptionTextField.text!
                self.errorCode.cause = self.CauseTextField.text!
                self.realm.add(self.errorCode, update: .modified)
            }
        }

        
        // try! realm.write {
        //     realm.add(errorCode)
            
        // self.ErrorCodeTextField.text = ""
        // self.ManufacturerTextField.text = ""
        // self.UnitTextField.text = ""
        // self.DiscriptionTextField.text = ""
        // self.CauseTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

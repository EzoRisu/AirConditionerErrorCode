//
//  ViewController.swift
//  AirConditionerErrorCode
//
//  Created by Yoshiyuki Karikome on 2022/05/23.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    
   
    let realm = try! Realm()
    var errorCode: ErrorCode!
    var errorCodeArray = try! Realm().objects(ErrorCode.self)
    var csvArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.fillerRowHeight = UITableView.automaticDimension
        // tableView.delegate = self
        // tableView.dataSource = self
        
        searchField.delegate = self
        
        var csvLines = [String]()
        
        guard let path = Bundle.main.path(forResource: "PacErrorCode", ofType: "csv") else {
            print("ERROR: No file")
            return
        }
        
        do {
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8 )
            csvLines = csvString.components(separatedBy: .newlines)
            csvLines.removeLast()
        } catch let error as NSError {
            print("ERROR")
            return
        }
        
        for csvData in csvLines {
            let csvDetail = csvData.components(separatedBy: ",")
            print("DEBUG_PRINT: csvDetail ID = \(csvDetail[0])")
            print("DEBUG_PRINT: csvDetail CODE = \(csvDetail[1])")
            print("DEBUG_PRINT: csvDetail MANI = \(csvDetail[2])")
            print("DEBUG_PRINT: csvDetail UNIT = \(csvDetail[3])")
            print("DEBUG_PRINT: csvDetail DISCRIPTION = \(csvDetail[4])")
            
            //self.errorCode.id = Int(csvDetail[0])!
            self.errorCode.errorCode = csvDetail[1]
            self.errorCode.manifacturer = csvDetail[2]
            self.errorCode.unit = csvDetail[3]
            self.errorCode.discription = csvDetail[4]
            
            try! realm.write {
                self.realm.add(self.errorCode, update: .modified)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController:DetailViewController = segue.destination as! DetailViewController
        
        if segue.identifier == "cellSegue" {
            print("DEBUG_PRINT: segue.identifier = cellSegue")
            let indexPath = self.tableView.indexPathForSelectedRow
            detailViewController.errorCode = errorCodeArray[indexPath!.row]
        } else {
            let errorCode = ErrorCode()
            
            let allErrorCodes = realm.objects(ErrorCode.self)
            if allErrorCodes.count != 0 {
                errorCode.id = allErrorCodes.max(ofProperty: "id")! + 1
            }
            
            detailViewController.errorCode = errorCode
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG_PRINT: numberOfRow = \(errorCodeArray.count)")
        return errorCodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let errorCode = errorCodeArray[indexPath.row]
        cell.textLabel?.text = errorCode.errorCode
        cell.detailTextLabel?.text = errorCode.manifacturer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // self.view.addGestureRecognizer(tapGesture)
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                self.realm.delete(self.errorCodeArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            errorCodeArray = realm.objects(ErrorCode.self).filter("errorCode == %@", searchText)
            // errorCodeArray = realm.objects(ErrorCode.self)
        } else {
            tableView.fillerRowHeight = 0.0
            tableView.delegate = self
            tableView.dataSource = self
            errorCodeArray = realm.objects(ErrorCode.self).filter("errorCode == %@", searchText)
        }
        tableView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


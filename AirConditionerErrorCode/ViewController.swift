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
    
    var errorCode: ErrorCode!
    let realm = try! Realm()
    var errorCodeArray = try! Realm().objects(ErrorCode.self)
    var csvArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.fillerRowHeight = UITableView.automaticDimension
        // tableView.delegate = self
        // tableView.dataSource = self
        
        searchField.delegate = self
        csvArray = loadCSV(filename: "PacErrorCode")
        self.saveCsvValue(csvArray)
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
    
    func loadCSV(filename: String) -> [String] {
        print("DEBUG_PRINT: LoadCSV")
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8 )
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\r")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("ERROR")
        }
        return csvArray
    }
    
    func saveCsvValue(csvArray: String) {
        let splitStr = csvArray.components(separatedBy: ",")
        errorCode.id = Int(splitStr[0])!
        errorCode.errorCode = splitStr[1]
        errorCode.manifacturer = splitStr[2]
        errorCode.unit = splitStr[3]
        errorCode.discription = splitStr[4]
        errorCode.cause = splitStr[5]
        
        do {
            try realm.write {
                realm.add(errorCode ,update: .modified)
            }
        } catch {
        }
    }
}


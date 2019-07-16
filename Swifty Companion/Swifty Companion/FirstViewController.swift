//
//  FirstViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
 
    var studentArray = [Student]()
    var currentStudentArray = [Student]()
    let file = "students.txt"
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStudents()
        setUpSearchBar()
    }
    
    private func setUpStudents(){
        if let asset = NSDataAsset(name: "Data") {
            let data = String(data: asset.data, encoding: .utf8)
            let myStrings = (data?.components(separatedBy: .newlines))!
            
            for name in myStrings {
                studentArray.append(Student(name:name.lowercased(), campus:"WeThinkCode_", image:"default"))
            }
        } else {
            print("Students Not Found")
        }
        
        currentStudentArray = studentArray
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentStudentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.name.text = currentStudentArray[indexPath.row].name
        cell.campus.text = currentStudentArray[indexPath.row].campus
        cell.intraProfilePicture.image = UIImage(named: currentStudentArray[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            currentStudentArray = studentArray
            table.reloadData()
            return
        }
        
        currentStudentArray = studentArray.filter({ student -> Bool in
            guard let text = searchBar.text else {return false}
            return student.name.contains(text.lowercased())
        })
        table.reloadData()
    }

}

class Student {
    let name: String
    let campus: String
    let image: String
    
    init(name: String, campus:String, image:String){
        self.name = name
        self.campus = campus
        self.image = image
    }
}


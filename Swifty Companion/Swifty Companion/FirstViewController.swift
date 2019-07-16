//
//  FirstViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {
 
    var studentArray = [Student]()

    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStudents()
    }
    
    private func setUpStudents(){
        studentArray.append(Student(name:"Philip", campus:"WeThinkCode_", image:"default"))
        studentArray.append(Student(name:"Kirsten", campus:"WeThinkCode_", image:"default"))
        studentArray.append(Student(name:"Xeno", campus:"WeThinkCode_", image:"default"))
        studentArray.append(Student(name:"Teo", campus:"WeThinkCode_", image:"default"))
        studentArray.append(Student(name:"Talon", campus:"WeThinkCode_", image:"default"))
        studentArray.append(Student(name:"Sam", campus:"WeThinkCode_", image:"default"))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.name.text = studentArray[indexPath.row].name
        cell.campus.text = studentArray[indexPath.row].campus
        cell.intraProfilePicture.image = UIImage(named: studentArray[indexPath.row].image)
        
        return cell
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


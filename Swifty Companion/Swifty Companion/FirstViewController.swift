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
    var selectedStudent: Student = Student(name:"", campus:"",image: UIImage(named: "default")!)
    var currentDetailedStudent = DetailedStudent(name:"n", campus:"c",profilePicture: UIImage(named: "default")!);
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
                studentArray.append(Student(name:name.lowercased(), campus:"WeThinkCode_", image: UIImage(named: "default")!))
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
    
    // get selected Student
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!(selectedStudent === studentArray[indexPath.row]))  {
            selectedStudent = studentArray[indexPath.row]
            print(studentArray[indexPath.row].name)
//            var profilePicture = studentArray[indexPath.row]
            
//            detailedStudent = DetailedStudent(name: name, campus: campus, profilePicture: profilePicture)
            self.currentDetailedStudent = DetailedStudent(name: selectedStudent.name, campus: selectedStudent.campus, profilePicture: selectedStudent.image)
            print(currentDetailedStudent.email)
            
            performSegue(withIdentifier: "displayDetailedUser", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! SecondViewController
        print("look at this"+currentDetailedStudent.campus)
        vc.detailedStudent = currentDetailedStudent

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableCell else {
            return UITableViewCell()
        }
        cell.name.text = currentStudentArray[indexPath.row].name
        cell.campus.text = currentStudentArray[indexPath.row].campus
        let url = URL(string: "https://cdn.intra.42.fr/users/medium_"+currentStudentArray[indexPath.row].name+".png")!
        do {
            let data = try Data(contentsOf: url)
            cell.intraProfilePicture.image = UIImage(data: data)
        } catch {
            cell.intraProfilePicture.image = UIImage(named: "default")
        }
   
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
    let image: UIImage
    
    init(name: String, campus:String, image:UIImage){
        self.name = name
        self.campus = campus
        self.image = image
    }
    
    init(){
        self.name = ""
        self.campus = ""
        self.image = UIImage(named: "default")!
    }
}


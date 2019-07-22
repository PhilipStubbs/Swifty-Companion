//
//  FirstViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit



class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
 
    static var studentArray = [Student]()
    var currentStudentArray = [Student]()
    var selectedStudent: Student = Student(name:"", campus:"",image: UIImage(named: "default")!)
    var currentDetailedStudent = DetailedStudent(name:"n", campus:"c", profilePicture: UIImage(named: "default")!);
    let file = "students.txt"
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FirstViewController.studentArray.count < 100){
            setUpStudents()
        }
        setUpSearchBar()
        currentStudentArray = FirstViewController.studentArray
    }
    
    private func setUpStudents() {
        if let asset = NSDataAsset(name: "Data") {
            let data = String(data: asset.data, encoding: .utf8)
            let myStrings = (data?.components(separatedBy: .newlines))!
            
            for name in myStrings {
                var userImage = UIImage(named: "default")
                let pngUrl = URL(string: "https://cdn.intra.42.fr/users/medium_"+name+".png")!
                let jpgUrl = URL(string: "https://cdn.intra.42.fr/users/medium_"+name+".jpg")!
                do {
                    let data = try Data(contentsOf: pngUrl)
                    userImage = UIImage(data: data)
                } catch {
                    do {
                        let data = try Data(contentsOf: jpgUrl)
                        userImage = UIImage(data: data)
                    } catch {
                        // NO OP
                    }
                }
                FirstViewController.studentArray.append(Student(name:name.lowercased(), campus:"WeThinkCode_", image: userImage!))
            }
        } else {
            print("Students Not Found")
        }
    }
    
    
    private func setUpSearchBar(){
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Search"
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
        cell.intraProfilePicture.image = currentStudentArray[indexPath.row].image
        
   
        return cell
    }
    
    // get selected Student
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!(selectedStudent === currentStudentArray[indexPath.row]))  {
            selectedStudent = currentStudentArray[indexPath.row]
            print(currentStudentArray[indexPath.row].name)
            
            self.currentDetailedStudent = DetailedStudent(name: selectedStudent.name, campus: selectedStudent.campus, profilePicture: selectedStudent.image)
            
            performSegue(withIdentifier: "displayDetailedUser", sender: self)
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentDetailedStudent = DetailedStudent(name: (searchBar.text?.lowercased())!, campus: "", profilePicture: UIImage(named: "default")!)
        print(currentDetailedStudent.name)
        performSegue(withIdentifier: "displayDetailedUser", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! SecondViewController
        vc.detailedStudent = currentDetailedStudent
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            currentStudentArray = FirstViewController.studentArray
            table.reloadData()
            return
        }
        
        currentStudentArray = FirstViewController.studentArray.filter({ student -> Bool in
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


//
//  SecondViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    
    var detailedStudent: DetailedStudent = DetailedStudent();
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var campus: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var projectTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = detailedStudent.name
        userEmail.text = detailedStudent.email
        campus.text = detailedStudent.campus
        profilePicture.image = detailedStudent.profilePicture
        getUserInfo()
    }
    
    func getUserInfo(){
        var jsonResponse = ""
        
        let url = URL(string: "https://api.intra.42.fr/v2/users/"+detailedStudent.name+"/cursus_users")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    jsonResponse = dataString
                    print(jsonResponse)
//                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
        
    }
    
    func getAuthKey(){
        
    }

//    func setProfilePicture() {
//        let url = URL(string: "https://cdn.intra.42.fr/users/medium_"+detailedStudent.name+".png")!
//        do {
//            let data = try Data(contentsOf: url)
//            profilePicture.image = UIImage(data: data)
//        } catch {
//            profilePicture.image = UIImage(named: "default")
//        }
//    }

    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "displayAllUsers", sender: self)
    }
    
}



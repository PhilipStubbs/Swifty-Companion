//
//  SecondViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController, UITableViewDataSource {
    
    
   static let authFileName = "Swifty-Companion-Auth"
   static let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
   static let fileURL = DocumentDirURL.appendingPathComponent(authFileName).appendingPathExtension("txt")
    
    var detailedStudent: DetailedStudent = DetailedStudent();
    var authKey: String = ""
    var jsonData: [String: Any]?
    var itemCells = [UserInfo]()
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var campus: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var projectTable: UITableView!
    @IBOutlet var signupTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = detailedStudent.name
        userEmail.text = detailedStudent.email
        campus.text = detailedStudent.campus
        profilePicture.image = detailedStudent.profilePicture

        findAuthKey()
        getUserInfo()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell") as? UserInfoCell else {
            return UITableViewCell()
        }
        cell.itemName.text = itemCells[indexPath.row].name
        cell.mark.text = itemCells[indexPath.row].mark
        cell.progress.progress = Float(itemCells[indexPath.row].mark) as! Float
        return cell
    }
    
    
    
    
    
    func extractUserInfo(){
        var skillSize:Int
        if var cursus_users = try self.jsonData!["cursus_users"] as? [Dictionary<String,Any>] {
            var cursus = cursus_users[0] as? [String:Any]
            var skills = cursus!["skills"] as? [Dictionary<String,Any>]
            skillSize = skills!.count
    
            for i in 0..<skillSize {
                itemCells.append(UserInfo(mark: String(describing: skills?[i]["level"] ?? 0.00) , name: skills![i]["name"] as! String, slug: skills![i]["name"] as! String, type: "Skill"))
            }

        } else {
            print("cursus_users failed")
        }
        
        if var projects_users = try self.jsonData!["projects_users"] as? [Dictionary<String,Any>] {
            for i in 0..<projects_users.count{
                var wholeProjects = projects_users[i] as? [String:Any]
                var project = wholeProjects!["project"] as? [String:Any]
                itemCells.append(UserInfo(mark: String(describing: wholeProjects!["final_mark"] ?? 0), name: project!["name"] as! String, slug: project!["slug"] as! String , type: "Project"))
                
            }
            // WTC data.. most of the time.
            print()
        } else {
            print("projects_users failed")
        }
        
        for i in 0..<itemCells.count {
            print(itemCells[i].name + " ", itemCells[i].mark)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    func getUserInfo(){
        let url = URL(string: "https://api.intra.42.fr/v2/users/"+detailedStudent.name)!
        let token = authKey
        var request = URLRequest(url:url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
       
        let task = URLSession.shared.dataTask(with: request) { (rawData, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                    if (response.statusCode == 401){
                        self.getNewAuthKey()
                        self.findAuthKey()
                        self.getUserInfo()
                    }
                }
                self.setUserInfo(data: rawData!)
          
            }
        }
        task.resume()
        
    }
    
    func setUserInfo(data: Data){
        do{
            //                        if let json = dataString.data(using: String.Encoding.utf8){
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                self.jsonData = jsonData
                var level = 0.0;
                var begin_at = "";
                
                if var wtc = try jsonData["cursus_users"] as? [Dictionary<String,Any>] {
                    // WTC data.. most of the time.
                    print(wtc)
                    print("")
                    begin_at = (wtc[0]["begin_at"] as? String)!
                    level = wtc[0]["level"] as? Double ?? 0.0
                } else {
                    print("cursus_users failed")
                }

                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.async {
                        self.level.text = String(format:"%.2f",level)
                        self.signupTime.text = begin_at
                    }
                })
                extractUserInfo()
                
            } else {
                print("failed")
            }
            //                        }
        }catch {
            print(error.localizedDescription)
            
        }
        
    }
    
    func getNewAuthKey() {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
        let parameters = [
            "grant_type":"client_credentials",
            "client_id": "2395c8f300a32a81e07519353dee66e3e719ba6aa3d176541e6fe1408a4fa83d" ,
            "client_secret":"5c2fd78404ed862bd2a59d9ad6c2097bd4114029e0615556bcc49432aad13a61"
        ]
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            if let response = response as? HTTPURLResponse {
                print("statusCode: \(response.statusCode)")
            }
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    self.writeAuthKey(text: json["access_token"] as! String)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    // Writing Auth key to File, to be used later
    func writeAuthKey(text: String){
        
        do {
            try text.write(to: SecondViewController.fileURL, atomically: true, encoding: .utf8)
            print("writing to :" + SecondViewController.authFileName + text )
        } catch {
            print("failed with error: \(error)")
        }

    }
    
    // Finding the Auth key file
    func findAuthKey(){
        do {
            let text = try String(contentsOf: SecondViewController.fileURL, encoding: .utf8)
            authKey = text
            print("Bearer Token Found: \(authKey)")
        }
        catch {
            print("failed with error: \(error)")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "displayAllUsers", sender: self)
    }
    
}



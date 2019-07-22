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
    var statusCode: Int = 0;
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var campus: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var signupTime: UILabel!
    
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var points: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.rowHeight = 100
        findAuthKey()
        getUserInfo()
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemCell else {
            return UITableViewCell()
        }
        cell.itemName.text = itemCells[indexPath.row].slug
        cell.mark.text = itemCells[indexPath.row].infoType == "Skill" ? String(format:"%.2f",itemCells[indexPath.row].rawMark) : String(format:"%.2f",itemCells[indexPath.row].rawMark) + "%"
        let progressMark = itemCells[indexPath.row].infoType == "Skill" ?  Float(itemCells[indexPath.row].rawMark) / 10 : Float(itemCells[indexPath.row].rawMark) / 100
        cell.progress.progress = progressMark
        cell.itemType.text = itemCells[indexPath.row].infoType
        
        cell.progress.layer.cornerRadius = 10
        cell.progress.clipsToBounds = true
        cell.progress.layer.sublayers![1].cornerRadius = 10
        cell.progress.subviews[1].clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    func extractUserInfo() {
        var skillSize:Int
        print(jsonData)
        if var cursus_users = try self.jsonData!["cursus_users"] as? [Dictionary<String,Any>] {
            var cursus = cursus_users[0] as? [String:Any]
            var skills = cursus!["skills"] as? [Dictionary<String,Any>]
            skillSize = skills!.count
            for i in 0..<skillSize {
                var mark:Double = skills?[i]["level"] as? Double ?? 0.00
                itemCells.append(UserInfo(mark: String(describing: mark) , name: skills![i]["name"] as! String, slug: skills![i]["name"] as! String, infoType: "Skill", rawMark: mark))
            }
            
        } else {
            print("cursus_users failed")
        }
        
        if var projects_users = try self.jsonData!["projects_users"] as? [Dictionary<String,Any>] {
            for i in 0..<projects_users.count{
                var mark:Double
                var wholeProjects = projects_users[i] as? [String:Any]
                var project = wholeProjects!["project"] as? [String:Any]
                mark = wholeProjects!["final_mark"] as? Double ?? 0.00
             
                itemCells.append(UserInfo(mark: String(describing: mark), name: project!["name"] as! String, slug: project!["slug"] as! String , infoType: "Project", rawMark: mark))
                
            }
            // WTC data.. most of the time.
        } else {
            print("projects_users failed")
        }
        
        
        DispatchQueue.main.async { self.table.reloadData() }
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
                    self.statusCode = response.statusCode
//                    if (response.statusCode == 404){
//                        DispatchQueue.global().async(execute: {
//                            DispatchQueue.main.async {
//                                self.backButton(self)
//                            }
//                        })
//                    }
                }
                self.setUserInfo(data: rawData!)
          
            }
        }
        task.resume()
        
    }
    
    func setUserInfo(data: Data){
        do{
            //                        if let json = dataString.data(using: String.Encoding.utf8){
            if (self.statusCode == 200)
            {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    self.jsonData = jsonData
                    var level = 0.0;
                    var begin_at = "";
                    
                    if var wtc = try jsonData["cursus_users"] as? [Dictionary<String,Any>] {
                        // WTC data.. most of the time.
                        begin_at = (wtc[0]["begin_at"] as? String)!
                        level = wtc[0]["level"] as? Double ?? 0.0

                    } else {
                        print("cursus_users failed")
                    }
            
                        let url = try jsonData["image_url"] as! String
                        let data = try Data(contentsOf: URL(string:url)!)
                        let userImage = UIImage(data: data)
                    
                    let login = try jsonData["login"] as! String
                    let displayName = try jsonData["displayname"] as! String
                    let points = try jsonData["correction_point"] as! Int
                    let campusLocationRaw = try jsonData["campus"]! as! [Dictionary<String,Any>]
                    let campusLocation = try campusLocationRaw[0]["name"] as! String
                    let emailAddress = try jsonData["email"] as! String
                    DispatchQueue.global().async(execute: {
                        DispatchQueue.main.async {
                            self.fullName.text = displayName
                            self.profilePicture.image = userImage
                            self.userName.text = login
                            self.campus.text = campusLocation
                            self.userEmail.text = emailAddress
                            self.points.text = "CP:"+String(format:"%d",points)
                            self.level.text = "Level:"+String(format:"%.2f",level).replacingOccurrences(of: ".", with: " - ", options: .literal, range: nil) + "%"
                            self.signupTime.text = String(begin_at.prefix(10))
                        }
                    })
               
                    extractUserInfo()
                    
                } else {
                    print("failed")
                }
          }
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



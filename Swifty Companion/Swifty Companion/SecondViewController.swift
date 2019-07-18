//
//  SecondViewController.swift
//  Swifty Companion
//
//  Created by Philip STUBBS on 2019/07/16.
//  Copyright © 2019 Philip Stubbs. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    
   static let authFileName = "Swifty-Companion-Auth"
   static let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
   static let fileURL = DocumentDirURL.appendingPathComponent(authFileName).appendingPathExtension("txt")
    
    var detailedStudent: DetailedStudent = DetailedStudent();
    var authKey: String = ""
    
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

        findAuthKey()
        getUserInfo()
    }
    

    
    func getUserInfo(){
        var jsonResponse = ""
        
        let url = URL(string: "https://api.intra.42.fr/v2/users/"+detailedStudent.name+"/cursus_users")!
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
//                if let data = rawData, let dataString = String(data: data, encoding: .utf8) {
////                    jsonResponse = dataString
////                    print(jsonResponse)
////                    self.setUserInfo(data: dataString)
////                    print("data: \(dataString)")
//                     print(dataString)
//                }
                

//                }
          
            }
        }
        task.resume()
        
    }
    
    func setUserInfo(data: Data){
        do{
            //                        if let json = dataString.data(using: String.Encoding.utf8){
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>] {
                print(jsonData)
                var level = 0.0;
                if var wtc = try jsonData[0] as? [String: Any] {
                    // WTC data.. most of the time.
                    level = wtc["level"] as? Double ?? 0.0
                }
                if (jsonData.count > 1) {
                    if var bootcamp = try jsonData[1] as? [String: Any] {
                        // BOOTCAMP data.. most of the time
                        print(bootcamp["level"])
                        if (level == 0.0){
                            level = bootcamp["level"] as? Double ?? 0.0
                        }
                    }
                }

                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.async {
                        self.level.text = String(format:"%.2f",level)
                        // etc
                    }
                })
                
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



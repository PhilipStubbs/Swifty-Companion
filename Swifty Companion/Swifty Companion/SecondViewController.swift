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
        viewWillAppear(true);
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        func run() {
                userName.text = MyVariables.currentDetailedStudent.name
                profilePicture.image = MyVariables.currentDetailedStudent.profilePicture
            print("name:"+MyVariables.currentDetailedStudent.name)
            }
        }
    
//    func loadData() {
//        // code to load data from network, and refresh the interface
//        tableView.reloadData()
//    }
//    static func makeSecondView(detailedStudent: DetailedStudent) -> SecondViewController {
//        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IdentifierOfYouViewController") as! SecondViewController
//
//        newViewController.detailedStudent = detailedStudent
//
//        return newViewController
//    }
  
}



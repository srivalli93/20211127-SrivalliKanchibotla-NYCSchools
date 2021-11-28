//
//  ViewController.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var contentService = ContentService()
    var schoolListData : [SchoolsList]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentService.getContentData(from: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") { result in
            switch result {
            case .success(let contentData):
                self.schoolListData = contentData
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolListData?.count ?? 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolListCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = schoolListData?[indexPath.row].school_name
        
        return cell
    }

}


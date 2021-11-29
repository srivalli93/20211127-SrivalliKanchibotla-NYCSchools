//
//  ViewController.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var contentService = ContentService()
    var schoolListData : [SchoolsList]?
    var satScores : [SATScores]?
    var filteredSchoolList = [SchoolsList]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeSearchController()
        contentService.getSchoolList(from: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") { result in
            switch result {
            case .success(let contentData):
                self.schoolListData = contentData
                self.tableView.reloadData()
                self.getSATScores()
                self.tableView.separatorColor = .clear
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func initializeSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search NYC schools"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let schoolListData = schoolListData else {
            return
        }

        if !isSearchBarEmpty {
            filteredSchoolList = schoolListData.filter({ (school: SchoolsList) -> Bool in
                return school.school_name.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    func getSATScores() {
        contentService.getSatScores(from: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json") { result in
            switch result {
            case .success(let contentData):
                self.satScores = contentData
                self.matchSATScoreWithSchools(self.satScores)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func matchSATScoreWithSchools(_ satScoreData: [SATScores]?) {
        
        guard let satScoreData = satScoreData else {
            return
        }
        
        let schoolsList = self.schoolListData
        self.schoolListData?.removeAll()
        
        for satScore in satScoreData {
            if let dbn = satScore.dbn {
                let matchedSchool = schoolsList?.first(where: { (school) -> Bool in
                    return school.dbn == dbn
                })
                
                guard var matchedSchool = matchedSchool else {
                    continue
                }
                
                matchedSchool.satScores = satScore
                self.schoolListData?.append(matchedSchool)
            }
        }

    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredSchoolList.count
        }
        
        return schoolListData?.count ?? 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolListCell", for: indexPath) as UITableViewCell
              
        
        cell.contentView.layoutMargins.top = 32
        cell.contentView.layoutMargins.bottom = 32
        cell.contentView.layoutMargins.left = 24
        cell.contentView.layoutMargins.right = 24
        
        // TODO: cell design
//        cell.backgroundColor = .clear
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOpacity = 0.20
//        cell.layer.shadowRadius = 4
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.contentView.backgroundColor = .white
//        cell.contentView.layer.cornerRadius = 8
//
//        let radius = cell.contentView.layer.cornerRadius
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        
        
        cell.textLabel?.text = schoolListData?[indexPath.row].school_name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.detailTextLabel?.text = schoolListData?[indexPath.row].location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        let headerView = UIView()
                
        imageView.image = UIImage(named: "NYC_DOE_Logo")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        headerView.backgroundColor = .white
        headerView.addSubview(imageView)

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        
//        headerView.addSubview(searchController.searchBar)
//
//        searchController.searchBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
//        searchController.searchBar.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: imageView.frame.height).isActive = true
//        searchController.searchBar.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
//        searchController.searchBar.heightAnchor.constraint(equalTo: headerView.heightAnchor, constant: -imageView.frame.height).isActive = true
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController?.schoolDescriptionText = schoolListData?[indexPath.row].overview_paragraph
        detailViewController?.schoolNameText = schoolListData?[indexPath.row].school_name
        detailViewController?.satMathScoreText = schoolListData?[indexPath.row].satScores?.sat_math_avg_score
        detailViewController?.satReadingScoreText = schoolListData?[indexPath.row].satScores?.sat_critical_reading_avg_score
        detailViewController?.satWritingScoreText = schoolListData?[indexPath.row].satScores?.sat_writing_avg_score
        navigationController?.pushViewController(detailViewController ?? self, animated: true)
        
    }

}


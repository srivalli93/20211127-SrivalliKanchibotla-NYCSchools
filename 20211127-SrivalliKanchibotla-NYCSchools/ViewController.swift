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
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    var childView = UIView()
    
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
        self.setupLoadingIndicator()
        loadingIndicator.startAnimating()
        contentService.getSchoolList(from: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json") { result in
            switch result {
            case .success(let contentData):
                self.schoolListData = contentData
                self.childView.removeFromSuperview()
                self.loadingIndicator.stopAnimating()
                self.tableView.separatorColor = .clear
                self.getSATScores()
            case .failure(let error):
                print(error)
                let alertVC = UIAlertController(title: "Error", message: "Could not retrieve the school List. Please try again later.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    //Setup loading indicator
    
    func setupLoadingIndicator() {
        loadingIndicator.color = .darkGray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
       
        //to prevent the user from taking any action on screen when there is a loading indicator
        childView.frame = self.view.frame
        self.view.addSubview(childView)
        
        self.view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
    //Search bar setup
    
    func initializeSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search NYC schools"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
            tableView.reloadData()
        }
    }
    
    //Getting SAT scores and matching it with School list data
    
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
        
        //reload tableview after fetching SAT scores in order to avoid mismatched data in DetailVC
        self.tableView.reloadData()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolListCell", for: indexPath) as! SchoolListTableViewCell
        
        guard schoolListData != nil else {
            return cell
        }

        let school: SchoolsList
        
        if isFiltering {
            school = filteredSchoolList[indexPath.row]
        } else {
            school = schoolListData![indexPath.row]
        }
        
        cell.schoolNameCellTitle.text = school.school_name
        
        if let startIndex = school.location!.range(of: "(")?.lowerBound {
            let locationText = String(school.location![..<startIndex])
            cell.schoolAddressCellSubtitle.text = locationText
        }
        cell.colorPickerForView(indexPath.row % 3)
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

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard schoolListData != nil else {
            return
        }

        let school: SchoolsList
        
        if isFiltering {
            school = filteredSchoolList[indexPath.row]
        } else {
            school = schoolListData![indexPath.row]
        }
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController?.schoolDescriptionText = school.overview_paragraph
        detailViewController?.schoolNameText = school.school_name
        detailViewController?.satMathScoreText = school.satScores?.sat_math_avg_score
        detailViewController?.satReadingScoreText = school.satScores?.sat_critical_reading_avg_score
        detailViewController?.satWritingScoreText = school.satScores?.sat_writing_avg_score
        detailViewController?.phoneNumberInfo = school.phone_number
        detailViewController?.locationDetails = school.location
        detailViewController?.schoolWebsiteURL = school.website
        navigationController?.pushViewController(detailViewController ?? self, animated: true)
        
    }

}


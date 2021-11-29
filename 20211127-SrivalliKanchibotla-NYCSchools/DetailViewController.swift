//
//  DetailViewController.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/28/21.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolDescription: UILabel!
    @IBOutlet weak var satReadingScore: UILabel!
    @IBOutlet weak var satWritingScore: UILabel!
    @IBOutlet weak var satMathScore: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var schoolWebsite: UIButton!
    
    var schoolNameText : String?
    var schoolDescriptionText : String?
    var satReadingScoreText : String?
    var satWritingScoreText : String?
    var satMathScoreText : String?
    var phoneNumberInfo: String?
    var locationDetails: String?
    var schoolWebsiteURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolName.text = self.schoolNameText
        self.schoolDescription.text = self.schoolDescriptionText
        self.satMathScore.text = "SAT Math Average Score: \(self.satMathScoreText ?? "")"
        self.satReadingScore.text = "SAT Critical Reading Average Score: \(self.satReadingScoreText ?? "")"
        self.satWritingScore.text = "SAT Writing Average Score: \(self.satWritingScoreText ?? "")"
        
        
        self.phoneNumber.titleLabel?.text = "Phone Number"
        self.location.titleLabel?.text = "View location on Maps"
        
        schoolWebsite.isEnabled = schoolWebsiteURL == nil ? false : true
        phoneNumber.isEnabled = phoneNumberInfo == nil ? false : true
        location.isEnabled = locationDetails == nil ? false : true
        
    }
    
    @IBAction func callPhoneNumber(_ sender: Any) {
        guard let phoneNumberInfo = phoneNumberInfo else {
            return
        }

        if let phoneCallURL = URL(string: "tel://\(phoneNumberInfo)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }        
    }
    
    @IBAction func openLocationOnMaps(_ sender: Any) {
        
        guard let locationDetails = locationDetails else {
            return
        }

        
        //separating coordinates from location string
        if let startIndex = locationDetails.range(of: "(")?.upperBound, let endIndex = locationDetails.range(of: ")")?.lowerBound {
            let coordinateString = String((locationDetails[startIndex..<endIndex]))
            let coordinates = coordinateString.components(separatedBy: ",")
            let latitude: CLLocationDegrees = Double(coordinates.first!) ?? 0.0
            let longitude: CLLocationDegrees = Double(coordinates.last!) ?? 0.0
            let regionDistance: CLLocationDistance = 10000
            let coordinateSet = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinateSet, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            let placeMark = MKPlacemark(coordinate: coordinateSet, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placeMark)
            mapItem.name = schoolNameText
            mapItem.openInMaps(launchOptions: options)
            
            
        }
        
    }
    @IBAction func openSchoolWebsite(_ sender: Any) {
        if let url = URL(string: schoolWebsiteURL!) {
            UIApplication.shared.open(url)
        }
    }
    
}

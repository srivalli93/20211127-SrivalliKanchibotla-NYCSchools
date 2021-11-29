//
//  DetailViewController.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/28/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var schoolDescription: UILabel!
    @IBOutlet weak var satReadingScore: UILabel!
    @IBOutlet weak var satWritingScore: UILabel!
    @IBOutlet weak var satMathScore: UILabel!
    
    var schoolNameText : String?
    var schoolDescriptionText : String?
    var satReadingScoreText : String?
    var satWritingScoreText : String?
    var satMathScoreText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.schoolName.text = self.schoolNameText
        self.schoolDescription.text = self.schoolDescriptionText
        self.satMathScore.text = "SAT Math Average Score: \(self.satMathScoreText ?? "")"
        self.satReadingScore.text = "SAT Critical Reading Average Score: \(self.satReadingScoreText ?? "")"
        self.satWritingScore.text = "SAT Writing Average Score: \(self.satWritingScoreText ?? "")"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SATScores.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import Foundation

struct SATScores : Codable {
    let dbn : String
    let school_name : String
    let num_of_sat_test_takers : String
    let sat_critical_reading_avg_score : String
    let sat_math_avg_score : String
    let sat_writing_avg_score : String
}


//https://data.cityofnewyork.us/resource/f9bf-2cp4.json

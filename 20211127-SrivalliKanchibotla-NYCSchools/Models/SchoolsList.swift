//
//  SchoolsList.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import Foundation

// TODO change it so the struct takes any name that doesnt have to match the API name

struct ListType {
    let schoolsList : SchoolsList
    let satScores : SATScores
}

struct SchoolsList :  Codable {
    let dbn: String
    let school_name: String
    let boro: String
    let overview_paragraph : String
    let school_10th_seats : String?
//    let academicopportunities1 : String?
//    let academicopportunities2 : String?
//    let academicopportunities3 : String?
//    let academicopportunities4 : String?
//    let academicopportunities5 : String?
    let ell_programs : String
    let language_classes : String?
    let advancedplacement_courses : String?
//    let diplomaendorsements : String
//    let neighborhood : String
//    let shared_space : String
    let campus_name : String?
    let building_code : String?
    let location : String?
    let phone_number : String?
    let fax_number : String?
    let school_email : String?
    let website : String?
    let total_students : String?
}

//https://data.cityofnewyork.us/resource/s3k6-pzi2.json

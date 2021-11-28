//
//  ContentService.swift
//  20211127-SrivalliKanchibotla-NYCSchools
//
//  Created by Srivalli Kanchibotla on 11/27/21.
//

import Foundation

struct ContentService {
    //fetches data from a URL
    
    func getContentData(from url: String, completion: @escaping (Result<[SchoolsList],Error>) -> ()) {
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("something went wrong")
                    return
                }
                
                //got the data
                do {
                    let returnData = try JSONDecoder().decode([SchoolsList].self, from: data)
                    completion(.success(returnData))
                    
                } catch {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}

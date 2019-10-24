//
//  GetWikipediaData.swift
//  WikipediaSearch
//
//  Created by Josh Sorokin on 24/10/2019.
//  Copyright © 2019 Josh Sorokin. All rights reserved.
//

import Foundation

class GetWikipediaData {
    
    static let shared = GetWikipediaData()
    
    var isRequestPending = false
    
    private init() {
    }
    
    func getWikipediaData(keyword: String, completed: @escaping (Result) -> ()) -> () {
        
        if isRequestPending { return }
        
        isRequestPending = true
        
        let formattedKeyword = keyword.replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: "http://api.geonames.org/wikipediaSearchJSON?q=\(formattedKeyword)&maxRows=10&username=tingz") else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                let resultData = try decoder.decode(Result.self, from: data)
                
                DispatchQueue.main.async {
                    let vc = SearchViewController()
                    vc.resultData = resultData
                    completed(resultData)
                }
                
                self.isRequestPending = false
                
                return
                
            } catch let err {
                print("Err", err)
            }
            
        }
        
        task.resume()
        
    }
    
}

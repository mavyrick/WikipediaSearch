//
//  ViewController.swift
//  WikipediaSearch
//
//  Created by Josh Sorokin on 24/10/2019.
//  Copyright © 2019 Josh Sorokin. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchSwitch: UISwitch!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var resultData: Result?
    var storedData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        self.searchSwitch.isOn = false
        
    }
    
    @IBAction func searchWeb(_ sender: UIButton) {
        
        self.spinner.isHidden = false
        
        let keyword = self.keyword.text ?? ""
        
        if searchSwitch.isOn == false {
            
            getWikipediaData(keyword: keyword)
            
        } else {
            getStoredData(keyword: keyword)
        }
    }
    
    private func getWikipediaData(keyword: String){
        GetWikipediaData.shared.getWikipediaData(keyword: keyword) { (resultData) -> Void in
            
            self.resultData = resultData
            
            self.resultsTableView.reloadData()
            
            let results = resultData.geonames
            saveResultData(results: results ?? [])
            
            self.spinner.isHidden = true
        }
    }
    
    private func getStoredData(keyword: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ResultData")
        
        let predicate = NSPredicate(format: "summary contains[c] %@", keyword)
        fetchRequest.predicate = predicate
        
        do {
            print(try managedContext.fetch(fetchRequest))
            storedData = try managedContext.fetch(fetchRequest)
            self.resultsTableView.reloadData()
            self.spinner.isHidden = true
        } catch {
            print("error")
        }
    }
    
}

func saveResultData(results: [Geonames]) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    let context = appDelegate.persistentContainer.viewContext
    
    for result in results {
        
        let newResult = NSEntityDescription.insertNewObject(forEntityName: "ResultData", into: context)
        
        newResult.setValue(result.title, forKey: "title")
        newResult.setValue(result.summary, forKey: "summary")
        newResult.setValue(result.thumbnailImg, forKey: "thumbnail")
    }
    do {
        try context.save()
        print("Success")
    } catch {
        print("Error saving: \(error)")
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchSwitch.isOn == false {
            return resultData?.geonames?.count ?? 0
        } else {
            return storedData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        
        cell.result = resultData?.geonames?[indexPath.row]
        cell.resultStored = storedData[indexPath.row]
        
        return cell
        
    }
}


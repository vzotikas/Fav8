//
//  CountryVC.swift
//  Fav8
//
//  Created by Administrator on 2018-05-29.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit

class CountryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    struct Structure: Codable {
        let body: [Body]
        struct Body: Codable {
            let text: String
            let URL: String
        }
    }
    
    var urlString = String()
    var textArray: [String] = []
    var urlArray: [String] = []
    var itemsIndex: Int!
    var jsonsUrl = String()
    
    func customInit(itemsIndex: Int, title: String, url: String) {
        self.itemsIndex = itemsIndex
        self.title = title
        jsonsUrl = url
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (textArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ReusableCell
        
        cell.textLabel?.text = textArray[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.4573513865, green: 0.4083655775, blue: 0.4990750551, alpha: 1)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationVC = StationVC()
        stationVC.customInit(itemsIndex: indexPath.row, title: textArray[indexPath.row], url: urlArray[indexPath.row])
        
        navigationController?.pushViewController(stationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = jsonsUrl
        let data = try! JSONDecoder().decode(Structure.self, from: Data(contentsOf: URL(string: urlString)!))
        
        for body in data.body {
            textArray.append(body.text)
        }
        
        for body in data.body {
            urlArray.append(body.URL + "&partnerId=RadioTime&username=adamchuk2168&render=json")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "ReusableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reusableCell")
    }
}

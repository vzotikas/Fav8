//
//  SecondViewController.swift
//  Dribble
//
//  Created by Administrator on 2018-05-28.
//  Copyright © 2018 Woqomoqo. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    struct Structure: Codable {
        let body: [Body]
        struct Body: Codable {
            let text: String
            let URL: String
        }
    }
    
    var urlString = "http://opml.radiotime.com/Browse.ashx?id=r0&partnerId=RadioTime&username=adamchuk2168&render=json"
    var textArray: [String] = []
    var urlArray: [String] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (textArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = textArray[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.4573513865, green: 0.4083655775, blue: 0.4990750551, alpha: 1)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryVC = CountryVC()
        countryVC.customInit(itemsIndex: indexPath.row, title: textArray[indexPath.row], url: urlArray[indexPath.row])
        navigationController?.pushViewController(countryVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = try! JSONDecoder().decode(Structure.self, from: Data(contentsOf: URL(string: urlString)!))
        
        for body in data.body {
            textArray.append(body.text)
        }
        
        for body in data.body {
            urlArray.append(body.URL + "&partnerId=RadioTime&username=adamchuk2168&render=json")
        }
    }
}

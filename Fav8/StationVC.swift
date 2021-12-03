//
//  StationVC.swift
//  Fav8
//
//  Created by Administrator on 2018-05-29.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit

class StationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    struct Structure: Codable {
        let head: Head
        struct Head: Codable {
            let title: String
            let status: String
        }

        let body: [Body]
        struct Body: Codable {
            let children: [Children]?
            struct Children: Codable {
                let text: String
                let URL: String
                let image: String?
            }
        }
    }
    
    struct LastStructure: Codable {
        let body: [Body]
        struct Body: Codable {
            let url: String
        }
    }
    
    var urlString = String()
    var textArray: [String] = []
    var urlArray: [String] = []
    var itemsIndex: Int!
    var jsonsUrl = String()
    
    var stationName = String()
    var imgArray: [String] = []
    var streamData = String()
    var lastUrlString = String()
    
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
        let secondStationVC = SecondStationVC()
        secondStationVC.customInit(itemsIndex: indexPath.row, title: textArray[indexPath.row], url: urlArray[indexPath.row])
        
        let selectedStationName = textArray[indexPath.row]
        let selectedStationUrl = urlArray[indexPath.row]
        let selectedImageUrl = imgArray[indexPath.row]
        
        lastUrlString = selectedStationUrl
        
        if lastUrlString.contains("Tune") == true {
            let data = try! JSONDecoder().decode(LastStructure.self, from: Data(contentsOf: URL(string: lastUrlString)!))
            
            let streamData = data.body[0]
            let stream = streamData.url
            
            let imageDataDict: [String: String] = ["name": selectedStationName, "streamUrl": stream, "urlImage": selectedImageUrl]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(secondStationVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = jsonsUrl
        
        let data = try! JSONDecoder().decode(Structure.self, from: Data(contentsOf: URL(string: urlString)!))
        
        for body in data.body {
            if let children = body.children {
                for value in children {
                    textArray.append(value.text)
                }
                for value in children {
                    urlArray.append(value.URL + "&render=json")
                }
                for value in children {
                    if let image = value.image {
                        imgArray.append(image)
                    } else {
                        imgArray.append("no image")
                    }
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "ReusableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reusableCell")
    }
}

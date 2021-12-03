//
//  Station.swift
//  Fav8
//
//  Created by Administrator on 2018-05-09.
//  Copyright © 2018 Administrator. All rights reserved.
//

import os.log
import UIKit

class Station: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var url: String
    var photo: UIImage?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stationsArchive")
    
    // MARK: Types
    
    enum PropertyKey {
        static let name = "name"
        static let url = "url"
        static let photo = "photo"
    }
    
    // MARK: Initialization
    
    init?(name: String, url: String, photo: UIImage?) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The url must not be empty
        guard !url.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.url = url
        self.photo = photo
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(url, forKey: PropertyKey.url)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a station.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The url is required. If we cannot decode an url string, the initializer should fail.
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? String else {
            os_log("Unable to decode the url for a station.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Station, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, url: url, photo: photo)
    }
}

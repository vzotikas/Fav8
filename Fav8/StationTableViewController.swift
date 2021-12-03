//
//  StationTableViewController.swift
//  Fav8
//
//  Created by Administrator on 2018-05-09.
//  Copyright © 2018 Administrator. All rights reserved.
//

import os.log
import UIKit

class StationTableViewController: UITableViewController {
    // MARK: Properties
    
    var newStations = [Station]()
    
    var navigationBarAppearace = UINavigationBar.appearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarAppearace.tintColor = #colorLiteral(red: 0.9607843137, green: 0.2392156863, blue: 0.3843137255, alpha: 1)
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.04705882353, blue: 0.2117647059, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved stations, otherwise load sample data.
        if let savedStations = loadStations() {
            newStations += savedStations
        }
        else {
            // Load the sample data.
            loadSampleStations()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newStations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "StationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationTableViewCell else {
            fatalError("The dequeued cell is not an instance of StationTableViewCell.")
        }
        
        // Fetches the appropriate station for the data source layout.
        
        self.tableView.separatorStyle = .none
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 3
        cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.height / 2
        cell.photoImageView.layer.masksToBounds = true
        
        let station = newStations[indexPath.row]
        
        cell.nameLabel.text = station.name
        cell.urlLabel.text = station.url
        cell.photoImageView.image = station.photo
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = newStations[sourceIndexPath.row]
        newStations.remove(at: sourceIndexPath.row)
        newStations.insert(movedObject, at: destinationIndexPath.row)
        saveStations()
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new station.", log: OSLog.default, type: .debug)
            
        case "GoBack":
            os_log("Going back to main screen.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let stationDetailViewController = segue.destination as? StationViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedStationCell = sender as? StationTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedStation = newStations[indexPath.row]
            stationDetailViewController.editStation = selectedStation
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToStationList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? StationViewController, let station = sourceViewController.editStation {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing station.
                newStations[selectedIndexPath.row] = station
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new station.
                let newIndexPath = IndexPath(row: newStations.count, section: 0)
                
                newStations.append(station)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the stations.
            saveStations()
        }
    }
    
    // MARK: Private Methods
    
    private func loadSampleStations() {
        guard let station1 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color1")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station2 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color2")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station3 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color3")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station4 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color4")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station5 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color5")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station6 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color6")) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station7 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color7")) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station8 = Station(name: "Station Name", url: "url", photo: UIImage(named: "Color8")) else {
            fatalError("Unable to instantiate station2")
        }
        
        newStations += [station1, station2, station3, station4, station5, station6, station7, station8]
    }
    
    private func saveStations() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: newStations, requiringSecureCoding: false)
            try data.write(to: URL(fileURLWithPath: Station.ArchiveURL.path))
        }
        catch {
            print("Couldn't save to file")
        }
    }
    
    private func loadStations() -> [Station]? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Station.ArchiveURL.path))
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Station]
        }
        catch {
            print(error)
            return nil
        }
    }
}

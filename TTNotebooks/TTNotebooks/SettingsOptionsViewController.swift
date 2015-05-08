//
//  SettingsOptionsViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 4/13/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class SettingsOptionsViewController: UITableViewController {

    // MARK: - Variables and Constants
    
    private struct tableViewConstants {
        static let cellReuseIdentifier = "SettingsCell"
    }
    
    var settingTitle: String?
    
    var nameOfSetting: String?
    
    var optionNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let setTitle = settingTitle {
            title = setTitle
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let names = optionNames {
            return names.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewConstants.cellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let selectedSettingIndex = NSUserDefaults.standardUserDefaults().integerForKey(nameOfSetting!)
        if let names = optionNames {
            cell.textLabel?.text = names[indexPath.row]
            if selectedSettingIndex == indexPath.row {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let setting = nameOfSetting {
            NSUserDefaults.standardUserDefaults().setValue(indexPath.row, forKey: setting)
            tableView.reloadData()
        }
    }
}

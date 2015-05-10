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
    
    /** List of all of the table view related constants */
    private struct tableViewConstants {
        static let cellReuseIdentifier = "SettingsCell"
    }
    
    /** The title of the setting that is being changed */
    var settingTitle: String?
    
    /** Name of the setting in the NSUserDefaults */
    var nameOfSetting: String?
    
    /** Name of the options for the setting that is being changed */
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

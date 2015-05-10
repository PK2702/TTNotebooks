//
//  SettingsViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 4/12/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    //MARK: - Properties and outlets
    
    /** Option that represents the account with which the user has signed in */
    @IBOutlet weak var appleID: UIButton!
    
    /** Label that informs the user how much storage is left in his iCloud account */
    @IBOutlet weak var avilableStorageLabel: UILabel!
    
    /** Option that represents the default notebook for a created notebook */
    @IBOutlet weak var notebookColorOption: UILabel!
    
    /** Option that represents the default layout for a created page */
    @IBOutlet weak var pagesLayoutTypeOption: UILabel!
    
    /** Option that represents the default color for a created figure */
    @IBOutlet weak var figureColorOption: UILabel!
    
    /** Option that represents the deafult color for the stroke in a created figure */
    @IBOutlet weak var strokeColorOption: UILabel!
    
    /** Option that represents the default line width for a created figure */
    @IBOutlet weak var strokeLineWidthOption: UILabel!
    
    /** Option that represents the default font to take notes */
    @IBOutlet weak var noteTakingFontOption: UILabel!

    //MARK: -Localized Strings
    
    /** List of all the Localized Strings of this class */
    private struct LStrings {
        static let UiBarButtonRestoreDefaultsTitle = NSLocalizedString("Restore Defaults", comment: "Name of the option to restore all the settings to their default value")
        static let TextFontSettingTitle = NSLocalizedString("Text Font", comment: "Name of the title in the settings view that will determine the font for text in the notes")
        static let NotebookColorSettingTitle = NSLocalizedString("Notebook Color", comment: "Name of the title in the settings view that will determine the color for the notebooks that will be created")
        static let PageLayoutSettingTitle = NSLocalizedString("Pages Layout", comment: "Name of the title in the settings view that will determine the layout for a page layout")
        static let FigureColorSettingTitle = NSLocalizedString("Figure Color", comment: "Name of the title in the settings view that will determine the color for the created figure")
        static let StrokeColorSettingTitle = NSLocalizedString("Stroke Color", comment: "Name of the title in the settings view that will determine the color for the stroke of the created figure")
        static let StrokeLineWidthSettingTitle = NSLocalizedString("Stroke Line Width", comment: "Name of the title in the settings view that will determine the line width of the figure's stroke")
    }
    
    //MARK: -Actions
    
    /** Restores the settings to its default values */
    private func restoreDefaults() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(Constants.SettingsVC.NotebookDefaultColorValue, forKey: Constants.SettingsVC.NotebookDefaultColor)
        userDefaults.setValue(Constants.SettingsVC.PagesDefaultLayoutTypeValue, forKey: Constants.SettingsVC.PagesDefaultLayoutType)
        userDefaults.setValue(Constants.SettingsVC.FigureDefaultColorValue, forKey: Constants.SettingsVC.FigureDefaultColor)
        userDefaults.setValue(Constants.SettingsVC.StrokeDefaultColorValue, forKey: Constants.SettingsVC.StrokeDefaultColor)
        userDefaults.setValue(Constants.SettingsVC.FigureDefaultLineWidthValue, forKey: Constants.SettingsVC.FigureDefaultLineWidth)
        userDefaults.setValue(Constants.SettingsVC.DefaultFontValue, forKey: Constants.SettingsVC.DefaultFont)
        updateUI()
    }
    
    /** Update the names fo the values in the options */
    private func updateUI() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let ntbColorOption = userDefaults.integerForKey(Constants.SettingsVC.NotebookDefaultColor) ?? Constants.SettingsVC.NotebookDefaultColorValue
        notebookColorOption.text = Helper.notebookColorNameForNumber(ntbColorOption)
        let pgsLayoutTypeOption = userDefaults.integerForKey(Constants.SettingsVC.PagesDefaultLayoutType) ?? Constants.SettingsVC.PagesDefaultLayoutTypeValue
        pagesLayoutTypeOption.text = Helper.pageLayoutNameForNumber(pgsLayoutTypeOption)
        let fgrColorOption = userDefaults.integerForKey(Constants.SettingsVC.FigureDefaultColor) ?? Constants.SettingsVC.FigureDefaultColorValue
        figureColorOption.text = Helper.figureColorNameForNumber(fgrColorOption)
        let stkColorOption = userDefaults.integerForKey(Constants.SettingsVC.StrokeDefaultColor) ?? Constants.SettingsVC.StrokeDefaultColorValue
        strokeColorOption.text = Helper.figureColorNameForNumber(stkColorOption)
        let ntTakingFontOption = userDefaults.integerForKey(Constants.SettingsVC.DefaultFont) ?? Constants.SettingsVC.DefaultFontValue
        noteTakingFontOption.text = Helper.fontNameForNumber(ntTakingFontOption)
        let stkLineWidht = userDefaults.integerForKey(Constants.SettingsVC.FigureDefaultLineWidth) ?? Constants.SettingsVC.FigureDefaultLineWidthValue
        strokeLineWidthOption.text = "\(Helper.strokeLineWidthForNumber(stkLineWidht))"
    }
    
    //MARK: - Applications Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: LStrings.UiBarButtonRestoreDefaultsTitle, style: UIBarButtonItemStyle.Plain, target: self, action: "restoreDefaults")
    }
    
    override func viewWillAppear(animated: Bool) {
        updateUI()
    }

    // MARK: - Navigation
    
    /** List of all the segue identifiers of this class */
    private struct SegueIdentifiers {
        static let fontOptionsSegueIdentifier = "Show Font Options"
        static let notebookColorOptionsSegueIdentifier = "Show Notebook Color Options"
        static let pageLayoutTypesSegueIdentifier = "Show Page Layout Types"
        static let figureColorOptionsSegueIdentifier = "Show Figure Color Options"
        static let strokeColorOptionsSegueIdentifier = "Show Stroke Color Options"
        static let strokeLineWidthOptionsSegueIdentifier = "Show Stroke Line Width Options"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? SettingsOptionsViewController {
            var names = [String]()
            switch(segue.identifier!) {
            case SegueIdentifiers.fontOptionsSegueIdentifier:
                dvc.settingTitle = LStrings.TextFontSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.DefaultFont
                for num in 0 ..< Helper.numberOfFonts {
                    names.append(Helper.fontNameForNumber(num))
                }
                dvc.optionNames = names
            case SegueIdentifiers.notebookColorOptionsSegueIdentifier:
                dvc.settingTitle = LStrings.NotebookColorSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.NotebookDefaultColor
                for num in 0 ..< Helper.numberOfNotebookColors {
                    names.append(Helper.notebookColorNameForNumber(num))
                }
                dvc.optionNames = names
            case SegueIdentifiers.pageLayoutTypesSegueIdentifier:
                dvc.settingTitle = LStrings.PageLayoutSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.PagesDefaultLayoutType
                for num in 0 ..< Helper.numberOfPageLayouts {
                    names.append(Helper.pageLayoutNameForNumber(num))
                }
                dvc.optionNames = names
            case SegueIdentifiers.figureColorOptionsSegueIdentifier:
                dvc.settingTitle = LStrings.FigureColorSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.FigureDefaultColor
                for num in 0 ..< Helper.numberOfFigureColors {
                    names.append(Helper.figureColorNameForNumber(num))
                }
                dvc.optionNames = names
            case SegueIdentifiers.strokeColorOptionsSegueIdentifier:
                dvc.settingTitle = LStrings.StrokeColorSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.StrokeDefaultColor
                for num in 0 ..< Helper.numberOfFigureColors {
                    names.append(Helper.figureColorNameForNumber(num))
                }
                dvc.optionNames = names
            case SegueIdentifiers.strokeLineWidthOptionsSegueIdentifier:
                dvc.settingTitle = LStrings.StrokeLineWidthSettingTitle
                dvc.nameOfSetting = Constants.SettingsVC.FigureDefaultLineWidth
                for num in 0 ..< Helper.numberOfStrokeLineWidths {
                    names.append("\(Helper.strokeLineWidthForNumber(num))")
                }
                dvc.optionNames = names
            default:
                break
            }
        }
    }

}

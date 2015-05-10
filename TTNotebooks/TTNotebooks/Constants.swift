//
//  Constants.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 3/23/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class Constants {
    
    // MARK: - Global
    
    /** Global constants whose logic don't belong to a particular class */
    struct Global {
        /** Name of the UIManagedDocument that contains the data of the Applicacion */
        static let DocumentName = "TTNotebooks"
    }
    
    // MARK: - NotebooksViewController

    /** Constants for the NotebooksViewController class */
    struct NotebooksVC {
        /** Identifier of the UICollecitonViewCell in the NotebooksViewController class */
        static let NotebookCellIdentifier = "Notebook Cell"
        /** Standard width for the UICollectionViewCell that depicts a Notebook */
        static let NotebookWidth :CGFloat = 160.0
        /** Standard height for the UICollectionViewCell that depicts a Notebook */
        static let NotebookHeight :CGFloat = 200.0
        /** Margins of the UICollectionViewCell that depicts a Notebook */
        static let NotebookEdges :CGFloat = 20
    }
    
    // MARK: - SettingsViewController
    
    /** Constants for the Settings of the application */
    struct SettingsVC {
        /** Name of the setting for the Apple ID in the NSUserDefaults */
        static let AppleIDName = "Settings AppleID"
        /** Name of the setting for the Notebook default color in the NSUserDefaults */
        static let NotebookDefaultColor = "Settings Notebook Default Color"
        /** Name of the setting for the Page default page layout type in the NSUserDefaults */
        static let PagesDefaultLayoutType = "Settings Pages Default Layout Type"
        /** Name of the setting for the Figure default color in the NSUserDefaults */
        static let FigureDefaultColor = "Settings Figure Default Color"
        /** Name of the setting for the Figure default stroke line width in the NSUserDefaults */
        static let FigureDefaultLineWidth = "Settings Figure Default Line Width"
        /** Name of the setting for the Figure default stroke line color in the NSUserDefaults */
        static let StrokeDefaultColor = "Settings Figure Default Stroke Color"
        /** Name of the setting for the Page default font in the NSUserDefaults */
        static let DefaultFont = "Settings Default Font"
        /** Default value for the Notebook color */
        static let NotebookDefaultColorValue = 0
        /** Default value for the Figure color */
        static let FigureDefaultColorValue = 0
        /** Default value for the Figure stroke line */
        static let FigureDefaultLineWidthValue = 2
        /** Default value for the Figure stroke line width */
        static let StrokeDefaultColorValue = 0
        /** Default value for the Page layout type */
        static let PagesDefaultLayoutTypeValue = 0
        /** Default value for the Page font */
        static let DefaultFontValue = 0
    }
        
    // MARK: - NSNotificationsCenter
    
    /** Constants for the NSNotifications that will be sent throughtout the Application */
    struct Notifications {
        /** Notification that indicates that the UIManagedDocument was loaded successfully by the AppDelegate */
        static let UIDocumentReady = "Document Ready"
        /** Key to access the user info containing the context */
        static let UIDocumentReadyContext = "Document Ready Context"
    }
    
}
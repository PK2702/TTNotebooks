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
    
    struct Global {
        static let DocumentName = "TTNotebooks"
    }
    
    // MARK: - NotebooksViewController

    struct NotebooksVC {
        static let NotebookCellIdentifier = "Notebook Cell"
        static let NotebookWidth :CGFloat = 160.0
        static let NotebookHeight :CGFloat = 200.0
        static let NotebookEdges :CGFloat = 20
    }
    
    // MARK: - SettingsViewController
    
    struct SettingsVC {
        static let AppleIDName = "Settings AppleID"
        static let NotebookDefaultColor = "Settings Notebook Default Color"
        static let PagesDefaultLayoutType = "Settings Pages Default Layout Type"
        static let FigureDefaultColor = "Settings Figure Default Color"
        static let FigureDefaultLineWidth = "Settings Figure Default Line Width"
        static let StrokeDefaultColor = "Settings Figure Default Stroke Color"
        static let DefaultFont = "Settings Default Font"
        static let NotebookDefaultColorValue = 0
        static let FigureDefaultColorValue = 0
        static let FigureDefaultLineWidthValue = 2
        static let StrokeDefaultColorValue = 0
        static let PagesDefaultLayoutTypeValue = 0
        static let DefaultFontValue = 0
    }
        
    // MARK: - NSNotificationsCenter
    
    struct Notifications {
        static let UIDocumentReady = "Document Ready"
        static let UIDocumentReadyUIContext = "Documento Ready Context"
    }
    
}
//
//  Utils.swift
//  myBluetoothie
//
//  Created by Jing Wang on 2/1/17.
//  Copyright © 2017 Jing Wang. All rights reserved.
//

//import Foundation
import UIKit

class Utils {
    
    static let sharedInstance = Utils()
    
    func info(message: String, ui: UIViewController, cbOK: @escaping (Void) -> Void) {
        let dialog = UIAlertController(title: "OK", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in cbOK() }
        dialog.addAction(OKAction)
        // Present the dialog
        ui.present(dialog, animated: false, completion: nil)
    }
    
    func error(message: String, ui: UIViewController, cbOK: @escaping (Void) -> Void) {
        let dialog = UIAlertController(title: "ERROR", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in cbOK() }
        
        dialog.addAction(OKAction)
        // Present the dialog
        ui.present(dialog,animated: false, completion: nil)
    }
}

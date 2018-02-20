//
//  Helpers.swift
//  MusicPlayer
//
//  Created by Prethush on 19/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit
import Foundation

internal func LocalString(_ key: String) -> String{
    return NSLocalizedString(key, comment: "nil")
}

internal func format(Duration duration: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    if duration >= 3600 {
        formatter.allowedUnits.insert(.hour)
    }
    return formatter.string(from: duration)!
}

extension UIViewController{
    internal func showAlert(WithTitle title: String? = nil, Message message: String, OKTitle okTitle: String? = "OK", CancelTitle cancelTitle: String? = nil, OKcompletion: (() -> Void)? = nil, CancelCompletion: (() -> Void)? = nil){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let okTitle = okTitle {
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                if let handler = OKcompletion{
                    handler()
                }
            }))
        }
        
        if let cancelTitle = cancelTitle{
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
                if let handler = CancelCompletion{
                    handler()
                }
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

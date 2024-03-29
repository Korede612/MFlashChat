//
//  WelcomeViewController.swift
//  MFlashChat
//
//  Created by Oko-osi Korede on 18/03/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleText = "⚡️FlashChat"
        
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            self.titleLabel.text = ""
            for (index, char) in titleText.enumerated() {
                Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false) { timer in
                    self.titleLabel.text?.append(char)
                }
            }
//        }
        
    }
}

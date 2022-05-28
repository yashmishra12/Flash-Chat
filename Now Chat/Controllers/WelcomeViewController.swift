//
//  WelcomeViewController.swift
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    let titleText: String = "Now Chat"
    var charIndex = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
    }
    

}

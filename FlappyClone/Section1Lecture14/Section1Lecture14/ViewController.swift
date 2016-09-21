//
//  ViewController.swift
//  Section1Lecture14
//
//  Created by Junior Vasquez on 7/2/16.
//  Copyright © 2016 Junior Vasquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blueBalloon: UIImageView!    
    @IBOutlet weak var redBalloon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hideBlue(sender: AnyObject) {
        
        blueBalloon.hidden = true
    }
    @IBAction func hideRed(sender: AnyObject) {
        
        redBalloon.hidden = true
        
    }

    @IBAction func showMeTheBalloons(sender: AnyObject) {
        
        redBalloon.hidden = false
        blueBalloon.hidden = false
    }
}


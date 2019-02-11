//
//  Page2ViewController.swift
//  ProximiioSwiftDemo
//
//  Created by Sandeep Perera on 9/10/18.
//  Copyright © 2018 Proximi.io. All rights reserved.
//

import UIKit
import M13Checkbox

class Page2ViewController: UIViewController {

    @IBOutlet weak var _ButtonAccept: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ButtonAcceptTapped(_ sender: Any) {
        GoToAccept()
    }
    
    
//    let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
//    Page2ViewController.addSubview(checkbox)

    
    
    func GoToAccept()
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let _page2: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(_page2, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

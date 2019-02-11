//
//  Page1ViewController.swift
//  ProximiioSwiftDemo
//
//  Created by Sandeep Perera on 9/10/18.
//  Copyright © 2018 Proximi.io. All rights reserved.
//

import UIKit

class Page1ViewController: UIViewController {
    
    @IBOutlet weak var _NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func GoToNext()
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let _page2: Page2ViewController = storyboard.instantiateViewController(withIdentifier: "Page2ViewController") as! Page2ViewController
        self.present(_page2, animated: true, completion: nil)
    }

    
    @IBAction func NextButtonTapped(_ sender: Any) {
    //        let _vc = self.storyboard?.instantiateViewController(withIdentifier: "Page1ViewController") as! Page1ViewController
//
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = _vc

        GoToNext()
        
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

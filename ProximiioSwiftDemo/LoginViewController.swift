//
//  LoginViewController.swift
//  ProximiioSwiftDemo
//
//  Created by Sandeep Perera on 26/09/18.
//  Copyright © 2018 Proximi.io. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    func Load_Spinner(){
        acitivityIndicator.isHidden = false
        acitivityIndicator.startAnimating()
    }
    
    func Stop_Spinner(){
        acitivityIndicator.isHidden = true
        acitivityIndicator.stopAnimating()
    }
    
    func LoadMe()
    {
        let prefs = UserDefaults.standard
        
        let userName = prefs.string(forKey: "userName");
        let password = prefs.string(forKey: "password");
        
        self.emailTextField.text = userName
        self.passwordTextField.text = password
        
    }
    
    func SaveMe(_ user:String, _ pass:String)
    {
        let preferences = UserDefaults.standard
        preferences.set(user, forKey:"userName")
        preferences.set(pass, forKey:"password")
    }
    
    func SaveProximiMe(_ paramName:String, _ paramValue:String)
    {
        let preferences = UserDefaults.standard
        preferences.set(paramValue, forKey:paramName)
    }

    
   

    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        let username = emailTextField.text
        let password = passwordTextField.text
        
        if(username=="" || password == "")
        {
                let alertController = UIAlertController(title: "", message: "Please enter an email and password.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            
                return
        }

        self.UserLogin(username!, password!)

    }

    func GoToHome()
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavVCMain") as! UINavigationController
        self.present(homeVC, animated: true, completion: nil)
    }

    func UserLogin(_ user:String, _ pass:String)
    {
        self.Load_Spinner()

        let url = URL(string: "https://mydayaut-marketing.azurewebsites.net/token")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "grant_type=password&username="+user+"&password="+pass
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared

        NSLog("UserLogin(1)...")
        
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler:{
                                        (data, response, error) in
                                        
                                        DispatchQueue.main.async {
                                           self.Stop_Spinner()
                                            
                                        }
                                        
                                        
                                        guard error == nil else {
                                            print("error calling POST")
                                            print(error!)
                                            return
                                        }
                                        guard let _:Data = data else
                                        {
                                            print("Did not received data")
                                            return
                                        }
                                        
                                        
                                        //get the json object
                                        let json:Any?
                                        do
                                        {
                                            json = try JSONSerialization.jsonObject(with:data!, options: [])
                                        }
                                        catch
                                        {
                                            print("error parsing response from POST")
                                            return
                                        }
                                        
                                        
                                        
                                        guard let server_response = json as? NSDictionary else
                                        {
                                            return
                                        }
                                        
                                        
                                        
                                        if let _access_token = server_response["access_token"] as? String
                                        {
                                            print(_access_token)
                                            //                    let preferences = UserDefaults.standard
                                            //                    preferences.set(session_data, forKey:"session")
                                            
                                            self.SaveProximiMe("prox_access_token", _access_token)
                                            
                                            if let _userName = server_response["userName"] as? String
                                            {
                                                self.SaveProximiMe("prox_username", _userName)
                                            }
                                            
                                            if let _token_type = server_response["token_type"] as? String
                                            {
                                                self.SaveProximiMe("prox_token_type", _token_type)
                                            }
                                            
                                            self.SaveMe(user, pass)
                                            
                                            DispatchQueue.main.sync (
                                                execute: self.GoToHome
                                            )
                                        }
                                        else
                                        {
                                            //NSLog("Invalid credentials")
                                            DispatchQueue.main.async {
                                                let alertController2 = UIAlertController(title: "", message: "Invalid login credentials.", preferredStyle: .alert)
                                                let defaultAction2 = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                alertController2.addAction(defaultAction2)
                                                self.present(alertController2, animated: true, completion: nil)

                                            }
                                        }
        })
        task.resume()
    }

    
    
//    func UserLogin(_ user:String, _ pass:String)
//    {
////        let url = URL(string: "http://mydayapi20180414.azurewebsites.net/token")
//        let url = URL(string: "https://mydayaut-marketing.azurewebsites.net/token")
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "POST"
//
//        let paramToSend = "grant_type=password&username="+user+"&password="+pass
//        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
//
//        let session = URLSession.shared
//
//        NSLog("UserLogin(1)...")
//
//        let task = session.dataTask(with: request as URLRequest,
//        completionHandler:{
//            (data, response, error) in
//            guard let _:Data = data else
//            {
//                return
//            }
//
//            let json:Any?
//
//            do
//            {
//                json = try JSONSerialization.jsonObject(with:data!, options: [])
//            }
//            catch
//            {
//                return
//            }
//
//            guard let server_response = json as? NSDictionary else
//            {
//                return
//            }
//
//
//            if let _access_token = server_response["access_token"] as? String
//            {
//                print(_access_token)
////                    let preferences = UserDefaults.standard
////                    preferences.set(session_data, forKey:"session")
//
//                self.SaveProximiMe("prox_access_token", _access_token)
//
//                if let _userName = server_response["userName"] as? String
//                {
//                        //print(_userName)
//                    self.SaveProximiMe("prox_username", _userName)
//                }
//
//                if let _token_type = server_response["token_type"] as? String
//                {
//                    self.SaveProximiMe("prox_token_type", _token_type)
//                        //print(_userName)
//                }
//
//                self.SaveMe(user, pass)
//
//                DispatchQueue.main.sync (
//                        execute: self.GoToHome
//                )
//            }
//            else
//            {
//                    //NSLog("Invalid credentials")
//                    //return;
//                //self.showToast(message: "Invalid credentials")
//
//
//                DispatchQueue.main.sync (
//                    execute: self.GotoLogin
//                )
//
//            }
//        })
//        task.resume()
//
//
//
//
//
//    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Stop_Spinner()
        LoadMe()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

//    @IBAction func LoginButtonTapped(_ sender: Any) {
//        let username = emailTextField.text
//        let password = passwordTextField.text
////        let username = "sp@a.com"
////        let password = "Abc@123"
//
//        if(username=="" || password == "") { return }
//        // Set and show Progress bar
//        //UserLogin(username!,password!)
//        UserLogin(username!, password!)
//        self.loginButton.hideLoading()
//
//
////        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////
////        var rootVC = appDelegate.window!.rootViewController
////
////        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////
////        var centerVC = mainStoryBoard.instantiateInitialViewController(withIdentifier:"ViewController") as! ViewController
//
//        //var leftVC = mainStoryBoard.instantiateViewController(withIdentifier: "LeftVC") as! LeftVC
//        //var rightVC = mainStoryBoard.instantiateViewController(withIdentifier: "RightVC") as! RightVC
//
//        //var leftSideNav = UINavigationController(rootVC, leftVC)
//        //var centerSideNav = UINavigationController(rootVC, centerVC)
//        //var leftSideNav = UINavigationController(rootVC, leftVC)
//
////        let centerContainer:MMDrawerController = MMDrawerController(centerVC: centerNav, leftDrawerController:leftNav, rightDrawerController: rightNav)
////
////        centerContainer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
////        centerContainer.closeDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
////
////        window!.rootViewController = centerContainer
////        window!.makeKeyAndVisible()
//
//
////        UserDefaults.standardUserDefaults().setBool(true,forKey: "isUserLoggedIn")
////        UserDefaults.standardUserDefaults().synchronize()
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
  

    
    

}

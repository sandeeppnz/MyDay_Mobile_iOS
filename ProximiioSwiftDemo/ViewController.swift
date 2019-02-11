//
//  ViewController.swift
//  ProximiioSwiftDemo
//
//  Created by Proximi.io DevTeam
//  Copyright © 2018 Proximi.io. All rights reserved.//

import UIKit
import ProximiioMap

class ViewController: UIViewController {
    
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    func Load_Spinner(){
        acitivityIndicator.isHidden = false
        acitivityIndicator.startAnimating()
    }
    
    func Stop_Spinner(){
        acitivityIndicator.isHidden = true
        acitivityIndicator.stopAnimating()
    }


	//Put your token	
	let TOKEN =""
	
    var mapView : ProximiioMap!
    
    let iBeaconImage = UIImage.init(named: "ibeacon_marker")
    let eddyImage = UIImage.init(named: "eddystone_marker")
    
    var usedInputs:Array<ProximiioMarker> = Array()
    var usedGeofences:Array<String> = Array()
    
    var _access_token: String = ""
    var _proxi_visitor_id: String = ""
    var _userName: String = ""
    
//    func discoverDevices() {
//        print("Discovering devices")
//        //manager?.scanForPeripherals(withServices: nil, options: nil)
//        centralManager.scanForPeripheralsWithServices(nil, options: nil)
//    }
//
//
//        func centralManagerDidUpdateState(_ central: CBCentralManager) {
//            print(central.state)
//            switch (central.state) {
//            case CBManagerState.poweredOff:
//                print("CoreBluetooth BLE hardware is powered off")
//                break;
//            case CBManagerState.unauthorized:
//                print("CoreBluetooth BLE state is unauthorized")
//                break
//
//            case CBManagerState.unknown:
//                print("CoreBluetooth BLE state is unknown");
//                break
//
//            case CBManagerState.poweredOn:
//                print("CoreBluetooth BLE hardware is powered on and ready")
//                bluetoothAvailable = true;
//                break;
//
//            case CBManagerState.resetting:
//                print("CoreBluetooth BLE hardware is resetting")
//                break;
//            case CBManagerState.unsupported:
//                print("CoreBluetooth BLE hardware is unsupported on this platform");
//                break
//            }
//            if bluetoothAvailable == true
//            {
//                discoverDevices()
//            }
//
//        }

    
    
    func updateTitle() {
        self.title =  String.init(format: "level: %d", mapView.floor())
        //_proxi_visitor_id = Proximiio.sharedInstance().visitorId!

    }
    
    func Proximi_Data()
    {
        let url = URL(string: "https://mydayaut-marketing.azurewebsites.net/api/ProximiVisitors")

//        let url = URL(string: "http://mydayapi20180414.azurewebsites.net/api/ProximiVisitors")

        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let dt_formatter = DateFormatter()
        dt_formatter.dateFormat = "yyyyMMdd_HHmmss"
        
        
        let currDateTime = Date()
        let soDate = dt_formatter.string(from: currDateTime)
//        let soDate = dt_formatter.date(from:)
        
        
        let paramToSend = "ID=0&password&UserId="+_userName+"&visitorId="+_proxi_visitor_id+"&CreatedDate="+soDate+"&TimeZone=Auckland"
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        NSLog("UserLogin(1)...")

        let task = session.dataTask(with: request as URLRequest, completionHandler:{
            (data, response, error) in
            guard let _:Data = data else
            {
                return
            }
            
            let json:Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with:data!, options: [])
            }
            catch
            {
                return
            }
            
            guard (json as? NSDictionary) != nil else
            {
                return
            }
            
//            if let _access_token = server_response["access_token"] as? String
//            {
//
////                DispatchQueue.main.sync (
////                    execute: self.GoToHome
//                )
//            }
//            else
//            {
//                NSLog("problem sending proximi data")
//
//            }
        })
        task.resume()

        
        
        
    }
    
    func LoadProximiMe()
    {
        let prefs = UserDefaults.standard
        
        let userName = prefs.string(forKey: "prox_username");
        let access_token = prefs.string(forKey: "prox_access_token");
        //let token_type = prefs.string(forKey: "prox_token_type");
        
        _access_token = access_token!
        _userName = userName!
        
//        let alertController = UIAlertController(title: "access_token", message: access_token, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(defaultAction)

        
    }

    // LOG CURRENT PROXIMI.IO POSITION FOR DEBUGGING
    @objc func proximiioPositionUpdated(_ location: ProximiioLocation) {
        NSLog("proximiio lat: %1.8f lng: %1.8f", location.coordinate.latitude, location.coordinate.longitude)
    }
    
    @objc func proximiioFloorChanged(_ floor: ProximiioFloor) {
        updateTitle()
    }
    
    // RENDER GEOFENCES AS CIRCLES
    @objc func proximiioUpdatedGeofences() {
        var geofences:Array<Any> = Array()
        
        // remove previously added
        usedGeofences.forEach{ (uuid) in
            mapView.removeCircle(withIdentifier: uuid)
        }

        // add current
        usedGeofences = Array()
        geofences = Proximiio.sharedInstance().geofences()
        geofences.forEach { (geofence) in
            let _geofence : ProximiioGeofence = geofence as! ProximiioGeofence
            mapView.addCircle(withIdentifier: _geofence.uuid, coordinate: _geofence.area.coordinate, radius: _geofence.radius)
            usedGeofences.append(_geofence.uuid)
        }
        
        _proxi_visitor_id = Proximiio.sharedInstance().visitorId!
        Proximi_Data()

    }
    
    // RENDER INPUTS AS MARKERS
    @objc func proximiioUpdatedInputs() {
        var inputs:Array<Any> = Array()
        
        // remove previously added
        usedInputs.forEach{ (input) in
            mapView.removeMarker(input)
        }
        
        usedInputs = Array()
        
        // add current
        inputs = (ProximiioResourceManager.sharedManager() as! ProximiioResourceManager).inputs.allValues
        inputs.forEach { (input) in
            let _input : ProximiioInput = input as! ProximiioInput
            let image = _input.type == kProximiioInputTypeIBeacon ? iBeaconImage : eddyImage
            let marker : ProximiioMarker = ProximiioMarker.init(coordinate: _input.location.coordinate, identifier: _input.uuid + "-marker", image:image)
            marker.setTitle(_input.name)
            marker.setSubtitle(_input.type == kProximiioInputTypeIBeacon ? "iBeacon" : "Eddystone Beacon")
            mapView.addMarker(marker)
            usedInputs.append(marker)
        }
    }
    
    // BASIC MAP INITIALIZATION
    func initMap() {
        mapView = ProximiioMap.init(frame: self.view.bounds, token: TOKEN, delegate: self)
        mapView.delegate = self;
        mapView.setTrackingMode(kProximiioTrackingModeEnabled);
        mapView.showPointsOfInterest = true;
        mapView.showRasterFloorplans = true;
        mapView.defaultZoomLevel = 16.5;
        
        //centralManagerDidUpdateState()
        
        self.view.addSubview(mapView.view);
        
    }

    // CENTERS VIEW TO CURRENT POSITION
    @objc func logOut() {
        //set flag userLoggedIN to false

        //TODO: stop the bluetooth and reactivate the device
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC

    }

    
    // CENTERS VIEW TO CURRENT POSITION
    @objc func myPosition() {
        //has error
        if Proximiio.sharedInstance().lastLocation() != nil
        {
            mapView.setCenter(Proximiio.sharedInstance().lastLocation().coordinate, animated: true)
        }
        else
        {
            
        }
        
    }
    
    // LEVEL UP (GEOJSON DATA)
    @objc func levelUp() {
        mapView.setFloor(mapView.floor() + 1, alterRouting:false)
        updateTitle()
    }
    
    // LEVEL DOWN (GEOJSON DATA)
    @objc func levelDown() {
        mapView.setFloor(mapView.floor() - 1, alterRouting:false)
        updateTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Load_Spinner()
        
        LoadProximiMe()
        
        let alertController = UIAlertController(title: "access_token", message: _access_token, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        
        if (_access_token.isEmpty == true)
        {
            //
            self.logOut()
            
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "My Position", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.myPosition))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.logOut)),
           UIBarButtonItem.init(title: " - ", style: UIBarButtonItem.Style.plain, target: self, action: #selector(levelDown)),
            UIBarButtonItem.init(title: " + ", style: UIBarButtonItem.Style.plain, target: self, action: #selector(levelUp))
         ]
        
        initMap()
        updateTitle()
        //_proxi_visitor_id = Proximiio.sharedInstance().visitorId!
        
        
        self.Stop_Spinner()


    }

}


//
//  ViewController.swift
//  Tether
//
//  Created by My-Linh Tran on 1/29/19.
//  Copyright © 2019 ChrisLee. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var scene_view : ARSCNView!
    var button : UIButton!
    let location_manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        location_manager.requestWhenInUseAuthorization()
        location_manager.requestAlwaysAuthorization()
        print("request should be made")
        if CLLocationManager.locationServicesEnabled() {
            print("getting location");
            location_manager.delegate = self
            location_manager.desiredAccuracy = kCLLocationAccuracyBest
            location_manager.startUpdatingLocation()
        }
        
        scene_view = ARSCNView()
        scene_view.frame = view.frame
        view.addSubview(scene_view)
        let config = ARWorldTrackingConfiguration()
        scene_view.session.run(config)
        
        //debug
        scene_view.showsStatistics = true
        scene_view.debugOptions = ARSCNDebugOptions.showWorldOrigin
        //scene_view.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        
        //using this tap method vs a tapGesture
        button = UIButton()
        button.frame = view.frame
        button.addTarget(self, action: #selector(addBox), for: .touchUpInside)
        view.addSubview(button)
 
        /*
        let scn = self.view as SCNView
        scn.scene = scene_view
        let tap = UITapGestureRecognizer(target: self, action: Selector(("addBox:")))
        let gestureRecognizer = NSMutableArray()
        gestureRecognizer.add(tap)
        */
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            print("ALTIUDE: ")
            print(location.altitude)
        }
        //location_manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alert = UIAlertController(title: "Location Access Disabled", message: "Need location to place marker on car", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(openAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //@objc func handleTap()
    
    @objc func addBox() {
        if let camera = scene_view.session.currentFrame?.camera {
            let cameraObject = MDLTransform(matrix: camera.transform)
            var position = cameraObject.translation
            //let position = SCNVector3(0, 0, -2)
            //let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
            let capsule = SCNCapsule(capRadius: 0.1, height: 0.3);
            capsule.firstMaterial?.diffuse.contents = UIColor.blue
            let boxNode = SCNNode(geometry: capsule)
            boxNode.position = SCNVector3(position)
            //boxNode.position = position
            scene_view.scene.rootNode.addChildNode(boxNode)
         
            
        }
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


//
//  AddItemViewController.swift
//  To Do List App
//
//  Created by Sebastian Hette on 19.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddItemViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtSub: UITextField!
    @IBOutlet weak var myMapView: MKMapView!
    
    var location = CLLocation()
    
    //Keep tracks of where our user is
    let manager = CLLocationManager()
    
    @IBAction func addItem(_ sender: Any)
    {
        if txtTitle.text != "" && txtSub.text != ""
        {
            saveThis(title: txtTitle.text!, subtitle: txtSub.text!, coordinates: "\(location.coordinate.latitude)$\(location.coordinate.longitude)")
            txtTitle.text = ""
            txtSub.text = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
         let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        longPressGestureRecognizer.minimumPressDuration = 2.0
        myMapView.addGestureRecognizer(longPressGestureRecognizer)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let MyLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(MyLocation, span)
        
        myMapView.setRegion(region, animated: true)
        myMapView.showsUserLocation = true
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            
            let location = press.location(in: myMapView)
            let newCoordinate = myMapView.convert(location, toCoordinateFrom: self.myMapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            
            annotation.title = "This is where I found the pot hole"
            annotation.subtitle = "Shelby county needs to fix this"
                    
            myMapView.addAnnotation(annotation)
        }
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("YES")
        }))

        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
        }))
                
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Saving function
    func saveThis(title:String, subtitle:String, coordinates:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ToDo", into: context)
        
        newItem.setValue(title, forKey: "title")
        newItem.setValue(subtitle, forKey: "subtitle")
        newItem.setValue(coordinates, forKey: "coordinates")
        
        do
        {
            try context.save()
            print("SAVE")
        }
        catch
        {
            print ("ERROR")
        }
    }

}

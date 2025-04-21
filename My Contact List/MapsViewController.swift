//
//  MapsViewController.swift
//  My Contact List
//
//  Created by user272075 on 3/30/25.
//

import UIKit
import MapKit
import CoreData

class MapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    var contacts:[Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
    }
    
    func mapView(_mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.2
        span.longitudeDelta = 0.2
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    @IBAction func findUser(_ sender: Any) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            //Get contacts from Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
            var fetchedObjects:[NSManagedObject] = []
            do {
                fetchedObjects = try context.fetch(request)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            contacts = fetchedObjects as! [Contact]
            //remove all annotations
            self.mapView.removeAnnotations(self.mapView.annotations)
            //go through all contacts
            for contact in contacts { //as! [Contact] {
                let address = "\(contact.streetAddress!), \(contact.city!) \(contact.state!)"
                //geocoding
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address) {(placemarks, error) in
                    self.processAddressResponse(contact, withPlacemarks: placemarks, error: error)
                }
            }
        }
        
        private func processAddressResponse(_ contact: Contact, withPlacemarks placemarks: [CLPlacemark]?,
                                            error: Error?) {
            if let error = error {
                print("Geocode Error: \(error)")
            }
            else {
                var bestMatch: CLLocation?
                if let placemarks = placemarks, placemarks.count > 0 {
                    bestMatch = placemarks.first?.location
                }
                if let coordinate = bestMatch?.coordinate {
                    let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    mp.title = contact.contactName
                    mp.subtitle = contact.streetAddress
                    mapView.addAnnotation(mp)
                }
                else {
                    print("Didn't find any matching locations")
                }
            }
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

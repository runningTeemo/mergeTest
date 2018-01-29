//
//  LocationGetter.swift
//  touzhong
//
//  Created by Richard.q.x on 2016/11/8.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import Foundation
import CoreLocation

class LocationGetter: NSObject, CLLocationManagerDelegate {
    
    static let shareOne: LocationGetter = LocationGetter()
    
    func getLocation(done: ((_ success: Bool, _ location: CLLocation?, _ mark: CLPlacemark?) -> ())?) {
        success = false
        locations.removeAll()
        mgr.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * CGFloat(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.mgr.stopUpdatingLocation()
            if let loc = self.locations.last {
                self.geocode(loc: loc, done: { mark in
                    self.currentMark = mark
                    LocationDataEntry.sharedOne.tryGetCurrentCity()
                    done?(self.success, self.locations.last, mark)
                })
            } else {
                done?(false, nil, nil)
            }
        }
    }
    
    private lazy var mgr: CLLocationManager = {
        let one = CLLocationManager()
        one.delegate = self
        one.requestWhenInUseAuthorization()
        return one
    }()
    private(set) var success: Bool = false
    private(set) var locations: [CLLocation] = [CLLocation]()
    private(set) var currentMark: CLPlacemark?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            success = true
            self.locations.append(loc)
        }
    }
    
    //地理信息反编码
    func geocode(loc: CLLocation, done: ((_ mark: CLPlacemark?) -> ())?){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc, completionHandler: { placemarks, error in
            if let err = error {
                print(err)
                done?(nil)
            } else {
                if let mark = placemarks?.last {
                   // print(mark.addressDictionary)
                    done?(mark)
                } else {
                    done?(nil)
                }
            }
            
        })
        
    }
    
}

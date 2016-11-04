//
//  METARViewController.swift
//  AlmatAirLog
//
//  Created by Tomasz Kawka on 08/08/2016.
//  Copyright © 2016 TransitBox. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import FirebaseAuth
import FBSDKCoreKit

class METARViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtICAO: UITextField!
    @IBOutlet weak var lblMETAR: UILabel!
    @IBOutlet weak var lblResults: UILabel!
    @IBOutlet weak var lblFlightCategory: UILabel!
    @IBOutlet weak var lblObservationTime: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblQNH: UILabel!
    @IBOutlet weak var lblstationName: UILabel!
    @IBOutlet weak var lblElevation: UILabel!
    @IBOutlet weak var lblObservationTimeTxt: UILabel!
    @IBOutlet weak var lblTemperatureTxt: UILabel!
    @IBOutlet weak var lblQNHTxt: UILabel!
    @IBOutlet weak var lblDewpoint: UILabel!
    @IBOutlet weak var lblDewpointTxt: UILabel!
    @IBOutlet weak var windDirTxt: UILabel!
    @IBOutlet weak var lblwindDir: UILabel!
    @IBOutlet weak var lblWindSpeedTxt: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblVisibilityTxt: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblSkyConditionTxt: UILabel!
    @IBOutlet weak var lblSkyCondition: UILabel!
    @IBOutlet weak var lblWeatherTxt: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    
    @IBAction func parseMETAR(sender: AnyObject) {
        
        downloadTags()
        dismissKeyboard()
        
    }
    
    func showMETARLabels(){
        lblElevation.hidden = false
        lblstationName.hidden = false
        lblQNH.hidden = false
        lblTemperature.hidden = false
        lblObservationTime.hidden = false
        lblFlightCategory.hidden = false
        lblDewpoint.hidden = false
        lblwindDir.hidden = false
        lblWindSpeedTxt.hidden = false
        lblVisibilityTxt.hidden = false
        lblSkyConditionTxt.hidden = false
        lblWeatherTxt.hidden = false
        
        lblObservationTimeTxt.hidden = false
        lblTemperatureTxt.hidden = false
        lblQNHTxt.hidden = false
        lblDewpointTxt.hidden = false
        windDirTxt.hidden = false
        lblWindSpeed.hidden = false
        lblVisibility.hidden = false
        lblSkyCondition.hidden = false
        lblWeather.hidden = false
        
        
    //Set METAR label colour to black
        self.lblResults.textColor = UIColor.blackColor()
        
    }
    
    func hideMETARLabels(){
        lblElevation.hidden = true
        lblstationName.hidden = true
        lblQNH.hidden = true
        lblTemperature.hidden = true
        lblObservationTime.hidden = true
        lblFlightCategory.hidden = true
        lblDewpoint.hidden = true
        lblwindDir.hidden = true
        lblWindSpeedTxt.hidden = true
        lblVisibilityTxt.hidden = true
        lblSkyConditionTxt.hidden = true
        lblWeatherTxt.hidden = true
        
        lblObservationTimeTxt.hidden = true
        lblTemperatureTxt.hidden = true
        lblQNHTxt.hidden = true
        lblDewpointTxt.hidden = true
        windDirTxt.hidden = true
        lblWindSpeed.hidden = true
        lblVisibility.hidden = true
        lblSkyCondition.hidden = true
        lblWeather.hidden = true
    }
    
    func getStationInfo() {
        
        Alamofire.request(.GET, "http://www.aviationweather.gov/adds/dataserver_current/httpparam" , parameters:["dataSource":"stations",
            "requestType":"retrieve",
            "stationString":txtICAO.text!,
            "format":"xml"]).response { (request, response, data, error) in
                //                print(data) // if you want to check XML data in debug window.
                
                    let xml = SWXMLHash.parse(data!)
                    let stationName = xml["response"]["data"]["Station"]["site"].element?.text // output the FilmID element.
                    if (stationName != nil){
                    self.lblstationName.text = stationName
                        
                        let stationElevation = Float((xml["response"]["data"]["Station"]["elevation_m"].element?.text)!)
                        let stationElevationInFt = stationElevation! * 3.2808
                        self.lblElevation.text = "Elevation: " + String(format: "%.0f", stationElevationInFt)  + "ft"
                    }
                else{
                    self.lblResults.text = "Not able to load data!"
                    self.lblResults.textColor = UIColor.redColor()
                        
                    self.hideMETARLabels()
                        
                    
                }
        }
        //Parse METAR from XML -- END --
        
        
    }

    
    func downloadTags() {
        
        getStationInfo()
        
        Alamofire.request(.GET, "http://aviationweather.gov/adds/dataserver_current/httpparam" , parameters:["dataSource":"metars",
            "requestType":"retrieve",
            "hoursBeforeNow":"3",
            "mostRecent":"true",
            "stationString":txtICAO.text!,
            "format":"xml"]).response { (request, response, data, error) in
                //                print(data) // if you want to check XML data in debug window.
                let xml = SWXMLHash.parse(data!)
                let rawMetar = xml["response"]["data"]["METAR"]["raw_text"].element?.text // output the FilmID element.
                if (rawMetar != nil){
                self.lblResults.text = rawMetar
                
                //fFlight Category
                let flightCategory: String = (xml["response"]["data"]["METAR"]["flight_category"].element?.text)!
                
                //Change label background depending on the Flight Category
                switch flightCategory{
                case "VFR" : self.lblFlightCategory.backgroundColor = UIColor.greenColor()
                    break
                case "MVFR" : self.lblFlightCategory.backgroundColor = UIColor.yellowColor()
                    break
                case "IFR" : self.lblFlightCategory.backgroundColor = UIColor.redColor()
                    break
                case "LIFR" : self.lblFlightCategory.backgroundColor = UIColor.magentaColor()
                    break
                default: break
                
                }

                self.lblFlightCategory.text = flightCategory
                
                var observationTime: String = (xml["response"]["data"]["METAR"]["observation_time"].element?.text)!
                observationTime = observationTime.stringByReplacingOccurrencesOfString("T", withString: " ")
                
                self.lblObservationTime.text = observationTime
                    
                //Temperature
                let temperature: String = (xml["response"]["data"]["METAR"]["temp_c"].element?.text)!
                
                    self.lblTemperature.text = "\(temperature)°C"
                
                //QNH
                let qnh: String = (xml["response"]["data"]["METAR"]["altim_in_hg"].element?.text)!
                    var qnhConvertedToHgmm: Float = Float(qnh)! * 33.863753
                self.lblQNH.text = String(format: "%.0f",qnhConvertedToHgmm) + "HPa"
                    
                //Dewpoint
                let dewpoint: String = (xml["response"]["data"]["METAR"]["dewpoint_c"].element?.text)!
                    
                self.lblDewpoint.text = "\(dewpoint)°C"
                    
                //Wind Direction
                let windDirection: String = (xml["response"]["data"]["METAR"]["wind_dir_degrees"].element?.text)!
                    
                self.lblwindDir.text = "\(windDirection) deg"

                //Wind Speed
                let windSpeed: String = (xml["response"]["data"]["METAR"]["wind_speed_kt"].element?.text)!
                    
                self.lblWindSpeed.text = "\(windSpeed) kt"
                    
                //Visibility
                let visibility: String = (xml["response"]["data"]["METAR"]["visibility_statute_mi"].element?.text)!
                var visibilityInKm: Float = Float(visibility)! * 1.60934
                    if visibilityInKm >= 9.99{
                    self.lblVisibility.text = "Greater than 10 km"
                    }else{
                        self.lblVisibility.text = String(format: "%.2f",visibilityInKm) + "km"
                    }
                    
                    //Weather
                    if let weather: String = (xml["response"]["data"]["METAR"]["wx_string"].element?.text){
                   
                        self.lblWeather.text = "\(weather)"

                    }

                //Sky Condition
                    self.lblSkyCondition.text = ""
                    var skyConditionTmp : String?
        var i=0
                    for skyCondElem in xml["response"]["data"]["METAR"]["sky_condition"]{
                        i++
        
    var skyConditionTmpSkyCover: String? = xml["response"]["data"]["METAR"]["sky_condition"][i-1].element?.attributes["sky_cover"]
                      
                            
    var skyConditionTmpCloudBase : String? = xml["response"]["data"]["METAR"]["sky_condition"][i-1].element?.attributes["cloud_base_ft_agl"]
                        
                        
                        if skyConditionTmpSkyCover != nil && skyConditionTmpSkyCover != "CAVOK" && skyConditionTmpSkyCover != "CLR"{
                        skyConditionTmp = "\(skyConditionTmpSkyCover) at \(skyConditionTmpCloudBase)"
                        var skyCond = skyConditionTmpSkyCover! + " at " + skyConditionTmpCloudBase!
    self.lblSkyCondition.text = self.lblSkyCondition.text! +  skyCond + "\n"
                        }else if skyConditionTmpSkyCover == "CAVOK"{
                        self.lblSkyCondition.text = "Ceiling and visibility OK"
                        }else if skyConditionTmpSkyCover == "CLR"{
                            
                            self.lblSkyCondition.text = "Clear Sky"//skyConditionTmp! + "\(skyConditionTmpSkyCover)\n"
                        }
                        
                    }
                    

            
                    
                if let index = rawMetar!.characters.indexOf("Q"){
                        print(index)
                    }
                self.showMETARLabels()
                    
                }
                else{
                    self.lblResults.text = "Not able to load data!"
                    self.lblResults.textColor = UIColor.redColor()
                    self.hideMETARLabels()
                    
                }
        }
        //Parse METAR from XML -- END --
        
        
    }


    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        downloadTags()
        return true;
    }
    


    
    @IBAction func flightConditionsButtonClicked(sender: AnyObject) {

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtICAO.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(METARViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogOutTouchedInside(sender: AnyObject) {
        
        //Log out of Fireapp
        try! FIRAuth.auth()!.signOut()
        
        //Log out of Facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        self.performSegueWithIdentifier("ToHomePage", sender: self)
        
        
    }
    
}

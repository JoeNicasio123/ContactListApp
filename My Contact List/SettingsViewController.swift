//
//  SettingsViewController.swift
//  My Contact List
//
//  Created by user272075 on 3/30/25.
//

import UIKit
import CoreMotion

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var settingsView: UIStackView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        self.batteryChanged()
    }
    
    func startMotionDetection(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mManager = appDelegate.motionManager
        if mManager.isAccelerometerAvailable {
            mManager.accelerometerUpdateInterval = 0.05
            mManager.startAccelerometerUpdates(to: OperationQueue.main) {
                (data: CMAccelerometerData?, error: Error?) in
                self.updateLabel(data: data!)
            }
        }
    }
    
    func updateLabel(data: CMAccelerometerData){
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let moveFactor:Double = 15.0
        var rect = lblBattery.frame
        let moveToX = Double(rect.origin.x) + data.acceleration.x * moveFactor
        let moveToY = Double(rect.origin.y + rect.size.height) - (data.acceleration.y * moveFactor)
        let maxX = Double(settingsView.frame.size.width - rect.width)
        let maxY = Double(settingsView.frame.size.height - tabBarHeight!)
        let minY = Double(rect.size.height + statusBarHeight)
        if(moveToX > 0 && moveToX < maxX){
            rect.origin.x += CGFloat(data.acceleration.x * moveFactor)
        }
        if(moveToY > minY && moveToY < maxY){
            rect.origin.y -= CGFloat(data.acceleration.y * moveFactor);
        }
        UIView.animate(withDuration: TimeInterval(0),
                       delay: TimeInterval(0),
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {self.lblBattery.frame = rect},
                       completion: nil)
    }
    
    @objc func batteryChanged() {
        let device = UIDevice.current
        var batteryState: String
        switch(device.batteryState) {
        case .charging:
            batteryState = "+"
        case .full:
            batteryState = "!"
        case .unplugged:
            batteryState = "-"
        case .unknown:
            batteryState = "?"
        }
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStatus = "\(batteryLevel) (\(batteryState))"
        lblBattery.text = batteryStatus
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickeView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return sortOrderItems.count
    }
    
    func pickerView(_ pickeView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIDevice.current.isBatteryMonitoringEnabled = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.motionManager.stopAccelerometerUpdates()
    }
}

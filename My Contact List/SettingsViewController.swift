//
//  SettingsViewController.swift
//  My Contact List
//
//  Created by user272075 on 3/30/25.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
    
    let sortOrderItems: Array<String> = ["ContactName", "City", "Birthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
    }
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
        
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
        print("Chosen item: \(sortOrderItems[row])")
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

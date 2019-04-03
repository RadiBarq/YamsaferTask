//
//  ViewController.swift
//  YamsaferTask
//
//  Created by Radi Barq on 4/3/19.
//  Copyright © 2019 RadiBarq. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  

    @IBAction func onClickDismiss(_ sender: UIButton) {
        

        self.dismiss(animated: true, completion: nil)
        var dateValue = datesArray[dataPicker.selectedRow(inComponent: 0)]
        deleteDateDelegate.releaseDateChange(newDate: String(dateValue))
    
    }
    
    
    var deleteDateDelegate: ReleaseDateDelegate!
    
    
    @IBOutlet weak var dataPicker: UIPickerView!
    
    var datesArray = [Int]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeDates()
        self.dataPicker.delegate = self
        self.dataPicker.dataSource = self
     
    }

    
    func initializeDates()
    {
        for var i in (1899..<2019).reversed()
        {
            datesArray.append(i + 1)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return datesArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return  String(datesArray[row])
        
    }
    

}


protocol ReleaseDateDelegate
{
    
    func releaseDateChange(newDate: String)
    
}


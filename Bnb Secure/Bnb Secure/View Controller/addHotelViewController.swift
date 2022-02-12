//
//  addHotelViewController.swift
//  Bnb Secure
//
//  Created by Tina  Cao on 2/2/22.
//

import UIKit

class addHotelViewController: UIViewController {

    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var gearButton: UIButton!
    
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var roomNum: UITextField!
    @IBOutlet weak var numOfGuests: UITextField!
    @IBOutlet weak var roomType: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func plusButtonTouched(_ sender: UIButton) {
        self.showRefresh()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (t) in
            self.stopRefresh()
        }
    }
    
    func setUpElements()  {
        Utilities.styleGreenButton(addButton)
    }
    
}

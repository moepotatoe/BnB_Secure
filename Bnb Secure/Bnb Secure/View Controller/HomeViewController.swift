//
//  HomeViewController.swift
//  Bnb Secure
//
//  Created by Tina  Cao on 1/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var hotelTable: UITableView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //refresh.hidesWhenStopped = true
        setUpElements()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        self.showRefresh()
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (t) in
            self.stopRefresh()
        }
    }
    //refresh.startAnimating()
    
    func setUpElements() {
        Utilities.styleGreenButton(notificationsButton)
    }


    
}

//
//  PopUpViewController.swift
//  testUserLocation
//
//  Created by Matthias Berjola on 25/11/2020.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var OkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 20
        popUpView.clipsToBounds = true
        
    }
    
    @IBAction func WhenPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

    }



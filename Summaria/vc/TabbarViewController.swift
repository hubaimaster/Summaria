//
//  TabbarViewController.swift
//  Summaria
//
//  Created by Chang Hwan Kim on 27/05/2019.
//  Copyright © 2019 cscp2. All rights reserved.
//

import Foundation
import UIKit

class TabbarViewController: UITabBarController {
    
    var button: UIButton?
    var scannerVC: CameraViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    func setup(){
        setupCenterButton()
        setupTabbar()
    }
    
    func setupCenterButton(){
        if button == nil{
            let button = UIButton()
            button.setImage(UIImage(named: "scan"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageEdgeInsets = UIEdgeInsets(top: 110, left: 95, bottom: 70, right: 95)
            button.frame.size = CGSize(width: 40, height: 40)
            button.imageView?.layer.masksToBounds = true
            tabBar.addSubview(button)
            tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            
            self.button = button
            button.addTarget(self, action: #selector(showScanner), for: UIControl.Event.touchUpInside)
        }
    }
    
    func setupTabbar(){
        self.tabBar.tintColor = UIColor.gray
    }
    
    @objc func showScanner(){
        if scannerVC == nil{
            scannerVC = self.storyboard?.instantiateViewController(withIdentifier: Config.vc.CameraViewController) as? CameraViewController
        }
        self.present(scannerVC, animated: true, completion: nil)
    }
    
}

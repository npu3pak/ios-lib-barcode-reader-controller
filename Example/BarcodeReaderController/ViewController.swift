//
//  ViewController.swift
//  BarcodeReaderController
//
//  Created by npu3pak on 03/26/2017.
//  Copyright (c) 2017 npu3pak. All rights reserved.
//

import UIKit
import BarcodeReaderController

class ViewController: BarcodeReaderController, BarcodeReaderControllerDelegate {
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func onBarcodeDetected(_ value: String, format: BarcodeFormat) {
        let alert = UIAlertController(title: "\(format)", message: value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "retry", style: .default, handler: {_ in self.restartScan()}))
        present(alert, animated: true, completion: nil)
    }
    
    func onBarcodeReaderInitializationSuccess() {
        errorLabel.isHidden = true
    }
    
    func onBarcodeReaderInitializationFailed() {
        errorLabel.isHidden = false
    }
}


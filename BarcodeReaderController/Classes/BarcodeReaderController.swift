//
//  BaseQrScannerController.swift
//  MPAY3
//
//  Created by Evgeniy Safronov on 22.07.16.
//  Copyright © 2016 Rucard LTD. All rights reserved.
//

import UIKit
import AVFoundation

public enum BarcodeFormat {
    case upce
    case code39
    case code39Mod43
    case ean13
    case ean8
    case code93
    case code128
    case pdf417
    case qr
    case aztek
    case interleaved2of5
    case itf14
    case dataMatrix
    case unknown
}

public protocol BarcodeReaderControllerDelegate {
    func onBarcodeDetected(_ value: String, format: BarcodeFormat)
    
    func onBarcodeReaderInitializationSuccess()
    
    func onBarcodeReaderInitializationFailed()
}

open class BarcodeReaderController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    open var delegate: BarcodeReaderControllerDelegate?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) {
            captureSession = AVCaptureSession()
            let metadataOutput = AVCaptureMetadataOutput()
            
            guard (captureSession.canAddInput(videoInput) && captureSession.canAddOutput(metadataOutput)) else {
                delegate?.onBarcodeReaderInitializationFailed()
                return;
            }
            
            captureSession.addInput(videoInput)
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
            previewLayer.frame = view.layer.bounds;
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            view.layer.addSublayer(previewLayer);
            
            captureSession.startRunning();
            delegate?.onBarcodeReaderInitializationSuccess()
        } else {
            delegate?.onBarcodeReaderInitializationFailed()
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onScreenRotated), name: .UIDeviceOrientationDidChange, object: nil)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func onScreenRotated() {
        guard let connection = previewLayer?.connection else {
            return
        }
        
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft: connection.videoOrientation = .landscapeLeft
        case .landscapeRight: connection.videoOrientation = .landscapeRight
        case .portrait: connection.videoOrientation = .portrait
        case .portraitUpsideDown: connection.videoOrientation = .portraitUpsideDown
        case .unknown: break
        }
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let format: BarcodeFormat
            switch readableObject.type! {
            case AVMetadataObjectTypeUPCECode: format = .upce
            case AVMetadataObjectTypeCode39Code: format = .code39
            case AVMetadataObjectTypeCode39Mod43Code: format = .code39Mod43
            case AVMetadataObjectTypeEAN13Code: format = .ean13
            case AVMetadataObjectTypeEAN8Code: format = .ean8
            case AVMetadataObjectTypeCode93Code: format = .code93
            case AVMetadataObjectTypeCode128Code: format = .code128
            case AVMetadataObjectTypePDF417Code: format = .pdf417
            case AVMetadataObjectTypeQRCode: format = .qr
            case AVMetadataObjectTypeAztecCode: format = .aztek
            case AVMetadataObjectTypeInterleaved2of5Code: format = .interleaved2of5
            case AVMetadataObjectTypeITF14Code: format = .itf14
            case AVMetadataObjectTypeDataMatrixCode: format = .dataMatrix
            default: format = .unknown
            }
            
            delegate?.onBarcodeDetected(readableObject.stringValue, format: format)
        } else {
            captureSession.startRunning()
        }
    }
    
    public func restartScan() {
        captureSession.startRunning()
    }
}

//
//  RecordView.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/08.
//

import Foundation
import AVFoundation
import UIKit


final class RecordView: UIViewController {
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized

            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAuthorized()
        settingCamera()
    }
    
    func checkAuthorized()  {
        Task {
            guard await isAuthorized else { return }
        }
    }
    
    func settingCamera() {
        
        guard let captureDevice = captureDevice else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.sessionPreset = .hd1280x720
            session?.addInput(input)
            session?.addOutput(output)
        } catch {
            print(error)
        }
        
        guard let session = session else { return }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        session.startRunning()
        
    }
//    
//    
//    private let controlStackView: UIStackView = {
//        
//    }()
//    
//    private let captureButton: UIButton = {
//        
//    }()
    
    
    
    
}

extension RecordView: AVCapturePhotoCaptureDelegate {
    
}

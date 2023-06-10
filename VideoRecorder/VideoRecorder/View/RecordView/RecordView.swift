//
//  RecordView.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/08.
//

import Foundation
import UIKit

final class RecordView: UIViewController {
    private let recordService = RecordService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePreview()
        configureUI()
        configureLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordService.startSession()
    }
    
    private let controlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .black.withAlphaComponent(0.6)
        stackView.layoutMargins = .init(top: 15, left: 15, bottom: 15, right: 15)
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let thumbnailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = .init(width: 50, height: 50)
        
        return view
    }()

    private let captureButton: CaptureButton = {
        let button = CaptureButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let switchCameraButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: imageConfiguration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        button.addTarget(RecordView.self,
                         action: #selector(switchCamera),
                         for: .touchUpInside)
        
        return button
    }()
    
    
    @objc private func switchCamera() {
        recordService.swapCameraType()
    }
    
    private func configureUI() {
        view.addSubview(controlStackView)
        
        controlStackView.addArrangedSubview(thumbnailView)
        controlStackView.addArrangedSubview(captureButton)
        controlStackView.addArrangedSubview(switchCameraButton)
        
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([

            controlStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            controlStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15),
            controlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            captureButton.heightAnchor.constraint(equalTo: controlStackView.heightAnchor, multiplier: 0.6),
            captureButton.widthAnchor.constraint(equalTo: captureButton.heightAnchor)

        ])
    }
    
    private func configurePreview() {
        guard let previewLayer = recordService.createPreView() else { return }
        previewLayer.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
    }
    
}


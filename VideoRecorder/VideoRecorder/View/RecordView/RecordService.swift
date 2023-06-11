//
//  RecordService.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/09.
//

import AVFoundation

final class RecordService: NSObject {
    let captureSession = AVCaptureSession()
    
    var videoDevice: AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var audioInput: AVCaptureDeviceInput!
    var videoOutput: AVCaptureMovieFileOutput!
    var outputURL: URL?
    
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
    
    private var workQueue: DispatchQueue = .init(
        label: "workQueue",
        qos: .default,
        attributes: .concurrent
    )
    
    override init() {
        super.init()
        checkAuthorized()
        videoDevice = bestDevice(in: .back)
        setupSession()
    }
    
    
    private func checkAuthorized()  {
        Task {
            guard await isAuthorized else { return }
        }
    }
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInDualCamera, .builtInWideAngleCamera]
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        
        return devices.first(where: { device in device.position == position })!
    }
    
    private func setupSession() {
        do {
            captureSession.beginConfiguration()
            
            videoInput = try AVCaptureDeviceInput(device: videoDevice!)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    
    func startRecording() {
       let connection = videoOutput.connection(with: AVMediaType.video)
        
       let device = videoInput.device
       if (device.isSmoothAutoFocusSupported) {
         do {
           try device.lockForConfiguration()
           device.isSmoothAutoFocusEnabled = false
           device.unlockForConfiguration()
         } catch {
           print("Error setting configuration: \(error)")
         }
       }

       outputURL = tempURL()
       videoOutput.startRecording(to: outputURL!, recordingDelegate: self)
     }

    func stopRecording() {
       if videoOutput.isRecording {
         videoOutput.stopRecording()
       }
     }
    
    private func tempURL() -> URL? {
       let directory = NSTemporaryDirectory() as NSString
       
       if directory != "" {
         let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
         return URL(fileURLWithPath: path)
       }
       
       return nil
     }
    
    func swapCameraType() {
        guard let input = captureSession.inputs.first(where: { input in
          guard let input = input as? AVCaptureDeviceInput else { return false }
          return input.device.hasMediaType(.video)
        }) as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
          newDevice = bestDevice(in: .front)
        } else {
          newDevice = bestDevice(in: .back)
        }
        
        do {
          videoInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
          NSLog("\(error), \(error.localizedDescription)")
          return
        }

        captureSession.removeInput(input)
        captureSession.addInput(videoInput!)
      }
    
    
    func createPreView() -> AVCaptureVideoPreviewLayer? {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        return previewLayer
    }
    
    func startSession() {
        workQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        workQueue.async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

extension RecordService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            let videoRecorded = outputURL! as URL
            let asset = AVAsset(url: videoRecorded)
            let duration = asset.duration
            let durationSeconds = CMTimeGetSeconds(duration)
            
            let date = DateManager.shared.today()
            
            let video = Video(
                title: nil,
                url: videoRecorded,
                durationSeconds: durationSeconds,
                date: date
            )
            
         
        }
    }
}

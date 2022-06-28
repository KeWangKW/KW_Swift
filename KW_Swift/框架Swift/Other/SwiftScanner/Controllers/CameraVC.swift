//
//  CameraVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
    
    func didOutput(_ code:String)
    
    func didReceiveError(_ error: Error)
    
}


public class CameraVC: UIViewController {
    
    weak var delegate:CameraViewControllerDelegate?
    
    lazy var animationImage = UIImage()
    
    /// 动画样式
    var animationStyle:ScanAnimationStyle = .default{
        didSet{
            if animationStyle == .default {
                animationImage = imageNamed("ScanLine")
            }else{
                animationImage = imageNamed("ScanNet")
            }
        }
    }
    
    lazy var scannerColor:UIColor = .red
    
    public lazy var flashBtn: UIButton = .init(type: .custom)
    
    private var torchMode:TorchMode = .off {
        didSet{
            guard let captureDevice = captureDevice,
                captureDevice.hasFlash else {
                    return
            }
            guard captureDevice.isTorchModeSupported(torchMode.captureTorchMode) else{
                return
            }
            
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = torchMode.captureTorchMode
                captureDevice.unlockForConfiguration()
            }catch{}
            
            flashBtn.setImage(torchMode.image, for: .normal)
        }
    }
    
    
    
    /// `AVCaptureMetadataOutput` metadata object types.
    var metadata = [AVMetadataObject.ObjectType]()
    
    // MARK: - Video
    
    /// Video preview layer.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    /// Video capture device. This may be nil when running in Simulator.
    private lazy var captureDevice: AVCaptureDevice? = {
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        
        // 自动白平衡
        if captureDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.whiteBalanceMode = .continuousAutoWhiteBalance
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        // 自动对焦
        if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = .continuousAutoFocus
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        // 自动曝光
        if captureDevice.isExposureModeSupported(.continuousAutoExposure) {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.exposureMode = .continuousAutoExposure
                captureDevice.unlockForConfiguration()
            } catch {}
        }
        
        return captureDevice
    }()
    /// Capture session.
    private lazy var captureSession = AVCaptureSession()
    
    lazy var scanView = ScanView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanView.startAnimation()
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        scanView.stopAnimation()
        
    }
    
}



// MARK: - CustomMethod
extension CameraVC {
    
    func setupUI() {
        
        view.backgroundColor = .black
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        videoPreviewLayer?.frame = view.layer.bounds
        
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        
        view.layer.addSublayer(videoPreviewLayer)
        
        scanView.scanAnimationImage = animationImage
        
        scanView.scanAnimationStyle = animationStyle
        
        scanView.cornerColor = scannerColor
        
        view.addSubview(scanView)
        
        setupCamera()
        
        setupTorch()
        
    }
    
    
    /// 创建手电筒按钮
    func setupTorch() {
        
//        let buttonSize:CGFloat = 37
        
//        flashBtn.frame = CGRect(x: screenWidth - 20 - buttonSize, y: statusHeight + 44 + 20, width: buttonSize, height: buttonSize)
        
        flashBtn.addTarget(self, action: #selector(flashBtnClick), for: .touchUpInside)
        
        flashBtn.isHidden = true
        
//        view.addSubview(flashBtn)
//        view.bringSubviewToFront(flashBtn)
        scanView.addSubview(flashBtn)
        flashBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scanView.snp.centerY).offset(KScreenWidth*0.6*0.5+60)
            make.size.equalTo(37)
        }
        
        torchMode = .off
        
        
        
        let photoBtn = UIButton()
//        photoBtn.setImage(UIImage(named: ""), for: .normal)
        photoBtn.setTitle("相册", for: .normal)
        photoBtn.addTarget(self, action: #selector(photoImageDeal), for: .touchUpInside)
        scanView.addSubview(photoBtn)
        photoBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.right.equalTo(-20)
            make.top.equalTo(flashBtn.snp.bottom).offset(35)
        }
    }
    
    
    
    // 设置相机
    func setupCamera() {
        
        setupSessionInput()
        
        setupSessionOutput()
        
    }
    
    
    //捕获设备输入流
    private  func setupSessionInput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        guard let device = captureDevice else {
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: device)
            
            captureSession.beginConfiguration()
            
            if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                captureSession.removeInput(currentInput)
            }
            
            captureSession.addInput(newInput)
            
            captureSession.commitConfiguration()
            
        }catch{
            delegate?.didReceiveError(error)
        }
        
    }
    
    //捕获元数据输出流
    private func setupSessionOutput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        captureSession.addOutput(videoDataOutput)
        
        let output = AVCaptureMetadataOutput()
        
        captureSession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        for type in metadata {
            if !output.availableMetadataObjectTypes.contains(type){
                return
            }
        }
        
        output.metadataObjectTypes = metadata
        
        videoPreviewLayer?.session = captureSession
        
        view.setNeedsLayout()
    }
    
    
    
    /// 开始扫描
    func startCapturing() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        captureSession.startRunning()
        
    }
    
    
    /// 停止扫描
    func stopCapturing() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        captureSession.stopRunning()
        
    }
    
    
}




// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraVC:AVCaptureMetadataOutputObjectsDelegate{
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        stopCapturing()
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        delegate?.didOutput(object.stringValue ?? "")
        
    }
    
    @objc func photoImageDeal() {
        weak var weakSelf = self
//        ImagePickerManager.showPicker(position: .onePhoto) { items in
//            let item = items.first
//            switch item {
//                case .photo(let photo):
//
//                let resultArr:[String] = self.recognitionQRCode(qrCodeImage: photo.image) ?? []
//                if resultArr.count > 0 {
//                    weakSelf?.delegate?.didOutput(resultArr[0])
//                }else{
//                    //weakSelf?.delegate?.didReceiveError(Error as! Error)
//                    weakSelf?.delegate?.didOutput("")
//                }
//
//                    break
//                case .video( _): break
//                case .none: break
//            }
//        }
    }
    
    func recognitionQRCode(qrCodeImage: UIImage) -> [String]? {
        //1. 创建过滤器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        //2. 获取CIImage
        guard let ciImage = CIImage(image: qrCodeImage) else { return nil }
        
        //3. 识别二维码
        guard let features = detector?.features(in: ciImage) else { return nil }
        
        //4. 遍历数组, 获取信息
//        var resultArr = [String]()
//        for feature in features {
//            resultArr.append(feature.type)
//        }
//
//        return resultArr
        if features.count == 0 {
            return nil
        }
        
        let feature = features[0] as! CIQRCodeFeature
        let scannedResult = feature.messageString
        
        return [scannedResult!]
    }
}



// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraVC:AVCaptureVideoDataOutputSampleBufferDelegate{
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let metadataDict = CMCopyDictionaryOfAttachments(allocator: nil,target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        
        guard let metadata = metadataDict as? [String:Any],
            let exifMetadata = metadata[kCGImagePropertyExifDictionary as String] as? [String:Any],
            let brightnessValue = exifMetadata[kCGImagePropertyExifBrightnessValue as String] as? Double else{
                return
        }
        
        // 判断光线强弱
        if brightnessValue < -1.0 {
            
            flashBtn.isHidden = false
            
        }else{
            
            if torchMode == .on{
                flashBtn.isHidden = false
            }else{
                flashBtn.isHidden = true
            }
            
        }
        
    }
}



// MARK: - Click
extension CameraVC{
    
    @objc func flashBtnClick(sender:UIButton) {
        
        torchMode = torchMode.next
        
    }
    
}

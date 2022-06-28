//
//  ImagePicker.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/11.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import AVFoundation

private let PhotoTitle = "从手机相册选择"
private let CameraTitle = "拍照"
private let CancelTitle = "取消"
private let CameraAlertTitle = "相机权限未开启"
private let CameraAlertMessage = "是否前往设置去开启相机权限？"

class ImagePicker: NSObject {
    
    private static var imagePicker: ImagePicker? = nil
    
    deinit {
        if ImagePicker.imagePicker != nil {
            ImagePicker.imagePicker = nil
        }
        debugPrint(#file)
    }
    
    typealias SelectImageClosure = ((UIImage) -> ())?
    
    weak private var controller: UIViewController?
    private let allowsEditing: Bool
    private let closure: SelectImageClosure
    
    static func showPicker(in controller: UIViewController, allowsEditing: Bool, closure: SelectImageClosure) {
        if imagePicker == nil {
            imagePicker = ImagePicker(controller: controller, allowsEditing: allowsEditing, closure: closure)
        }
        imagePicker!.showActionSheet()
    }
    
    init(controller: UIViewController, allowsEditing: Bool, closure: SelectImageClosure) {
        self.controller = controller
        self.allowsEditing = allowsEditing
        self.closure = closure
    }
    
    private func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: PhotoTitle, style: .default) { (_) in
            self.imagePicker(with: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: CameraTitle, style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                ImagePicker.imagePicker = nil
                return
            }
            guard self.canOpenCamera() else {
                ImagePicker.imagePicker = nil
                return
            }
            self.imagePicker(with: .camera)
        }
        let cancelAction = UIAlertAction(title: CancelTitle, style: .cancel) { (_) in
            ImagePicker.imagePicker = nil
        }
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        controller!.present(sheet, animated: true, completion: nil)
    }
    
    private func canOpenCamera() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        guard status == .denied || status == .restricted else { return true }
        showOpenSettingAlert()
        return false
    }
    
    private func showOpenSettingAlert() {
        let alert = UIAlertController(title: CameraAlertTitle, message: CameraAlertMessage, preferredStyle: .alert)
        let openAction = UIAlertAction(title: "打开", style: .default) { (_) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        controller!.present(alert, animated: true, completion: nil)
    }
    
    private func imagePicker(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        controller!.present(picker, animated: true, completion: nil)
    }
    
}

extension ImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            ImagePicker.imagePicker = nil
        }
        var image: UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        picker.dismiss(animated: true) {
            self.closure?(image!)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            ImagePicker.imagePicker = nil
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

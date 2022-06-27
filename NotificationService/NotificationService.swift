//
//  NotificationService.swift
//  NotificationService
//
//  Created by 渴望 on 2021/5/21.
//  Copyright © 2021 guan. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension  {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            
            //bestAttemptContent.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "test.mp3"))
            
            print("|||||||||||||||||||||||")
            
            
            let audio:String = bestAttemptContent.userInfo["audio"] as? String ?? ""
            if audio.count > 0 {
                self.loadSoundsWithUserInfo(bestAttemptContent.userInfo)
            }else{
                self.dealShowImgWithUserInfo(bestAttemptContent.userInfo)
            }
            
        }
    }
    
    
    
    //获取语音播报处理
    func loadSoundsWithUserInfo(_ userInfo:[AnyHashable : Any]) {
        if let urlStr = userInfo["audio"] as? String, let url = URL(string: urlStr) {
        
//        if let urlStr = "https://downsc.chinaz.net/Files/DownLoad/sound1/202110/14869.wav" as? String , let url = URL(string: urlStr) {
            
            
            let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
                if (error == nil) {
                    if let result = result {
                        
                        let groupUrl:URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kw.swift")!
                        let groupPath:String = groupUrl.path
                        
                        let filePath = groupPath + "/Library/Sounds"
                        print("文件路径=" + filePath)
                        
                        if !FileManager.default.fileExists(atPath: filePath) {
                            do {
                                print("无此文件夹-创建文件夹")
                                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                            } catch  {
                                self.contentHandler!(self.bestAttemptContent!)
                            }
                        }
                        
                        let fileName = "/wkw.wav"//"\(arc4random()%50000)" + ".wav"
                        print("文件名=" + fileName)
                        
                        let savePath = filePath + fileName
                        print("文件存储路径=" + savePath)
                        if FileManager.default.fileExists(atPath: savePath) {
                            do {
                                print("删除重名文件")
                                try FileManager.default.removeItem(atPath: savePath)
                            }catch {
                                self.contentHandler!(self.bestAttemptContent!)
                            }
                        }
                        
                        let saveUrl:URL = URL(fileURLWithPath: savePath)
                        do {
                            print("保存文件")
                            try FileManager.default.moveItem(at: result, to: saveUrl)
                            self.bestAttemptContent?.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "wkw.wav")) //fileName
                            self.contentHandler!(self.bestAttemptContent!)
                        } catch{
                            self.contentHandler!(self.bestAttemptContent!)
                        }
                        
                    }
                }else{
                    self.contentHandler!(self.bestAttemptContent!)
                }
            }
            task.resume()
        }else{
            self.contentHandler!(self.bestAttemptContent!)
        }
        
    }
    
    //通知展示图片处理
    func dealShowImgWithUserInfo(_ userInfo:[AnyHashable : Any]) {
        
        if let urlStr = userInfo["thumb"] as? String, let url = URL(string: urlStr) {
            
            let pathExtension = url.pathExtension

            let task = URLSession.shared.downloadTask(with: url) { (result, response, error) in
                if let result = result {

                    let identifier = ProcessInfo.processInfo.globallyUniqueString
                    let target = FileManager.default.temporaryDirectory.appendingPathComponent(identifier).appendingPathExtension(pathExtension)

                    do {
                        try FileManager.default.moveItem(at: result, to: target)

                        let attachment = try UNNotificationAttachment(identifier: identifier, url: target, options: nil)
                        
                        self.bestAttemptContent?.attachments = [attachment]
                        self.contentHandler!(self.bestAttemptContent!)
                    }
                    catch {
                        print(error.localizedDescription)
                        self.contentHandler!(self.bestAttemptContent!)
                    }
                }
            }
            task.resume()
        }else{
            self.contentHandler!(self.bestAttemptContent!)
        }
        
    }
    
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    //MARK: 文字转语音，系统方法
    func playVoice(content: String, finshBlock: @escaping PlayVoiceBlock) {
        if content.count == 0 {
            return
        }
        
        self.finshBlock = finshBlock
//        if let finshBlock = finshBlock {
//            self.finshBlock = finshBlock
//        }
        
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        try? session.setActive(true, options: [])
        try? session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        // 创建嗓音
        let voice = AVSpeechSynthesisVoice.init(language: "zh-CN")
        
        // 创建语音合成器
        self.synthesizer = AVSpeechSynthesizer.init()
        self.synthesizer?.delegate = self
        
        // 实例化发声的对象
        let utterance = AVSpeechUtterance.init(string: content)
        utterance.voice = voice
        utterance.rate = 0.5 // 语速
        
        self.synthesizer?.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("start")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("end")
        self.finshBlock!()
    }
    
    */
    
}

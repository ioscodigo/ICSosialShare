//
//  ShareExtension.swift
//  ShareTEST
//
//  Created by Fajar on 5/29/17.
//  Copyright © 2017 Fajar AW. All rights reserved.
//

import UIKit

let ICShare = ICSosialShare()

internal class ICSosialShare: NSObject {
    
    var documentInteractionController:UIDocumentInteractionController!
    private struct SHARE {
        struct WA {
            private static let BASE = "whatsapp://"
            static let APP = WA.BASE + "app"
            static let SEND = WA.BASE + "send?text="
        }
        struct LINE {
            private static let BASE = "line://"
            static let SEND = LINE.BASE + "msg/text/"
        }
        struct FB {
            private static let BASE = "fb://"
            
        }
    }
    
    public var isWhatsAppAvailable:Bool {
        let url = URL(string: SHARE.WA.APP)!
        return UIApplication.shared.canOpenURL(url)
    }
    
    public var isLineAvailable:Bool {
        let url = URL(string: SHARE.LINE.SEND + "test")!
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func shareTextLine(_ text:String) {
        shareText(SHARE.LINE.SEND + text)
    }
    
    public func shareTextWhatsApp(_ text:String) {
        shareText(SHARE.WA.SEND + text)
    }
    
    private func shareText(_ text:String){
        let url = URL(string: text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
        UIApplication.shared.openURL(url)
    }
    
    public func shareImageWhatsApp(image:UIImage,vc:UIViewController) {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")!
            do {
                try imageData.write(to: tempFile, options: .atomicWrite)
                self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                self.documentInteractionController.uti = "net.whatsapp.image"
                self.documentInteractionController.presentOpenInMenu(from: .zero, in: vc.view, animated: true)
            } catch {
                print(error)
            }
        }
    }
    
    public func shareActivity(items:[Any],vc:UIViewController) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        var excluded:[UIActivityType] = [.addToReadingList,.assignToContact,.print,.saveToCameraRoll]
        if #available(iOS 9.0, *) {
            excluded.append(.openInIBooks)
        }
        activity.excludedActivityTypes = excluded
        vc.present(activity, animated: true, completion: nil)
    }
}

extension String {
    func shareToWhatsApp(){
        ICShare.shareTextWhatsApp(self)
    }
    
    func shareToLine(){
        ICShare.shareTextLine(self)
    }
}

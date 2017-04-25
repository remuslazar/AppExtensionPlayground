//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Remus Lazar on 25.04.17.
//  Copyright © 2017 Remus Lazar. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
            let attachments = item.attachments {
            for attachment in attachments {
                if let attachment = attachment as? NSItemProvider {
                    let identifier = attachment.registeredTypeIdentifiers.first as! String
                    print(identifier)
                    attachment.loadItem(forTypeIdentifier: identifier,
                                        options: nil,
                                        completionHandler: {
                                            print("loaded data for identifier: \(identifier)..")
                                            guard let data = $0.0 as? Data else {
                                                print($0.0!)
                                                return
                                            }
                                            let string = String(data: data, encoding: .utf8)!
                                            print(string)
                    })
                }
            }
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}

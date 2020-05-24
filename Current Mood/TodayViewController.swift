//
//  TodayViewController.swift
//  mood-ext
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftUI

class TodayViewController: UIViewController, NCWidgetProviding {
	@IBSegueAction func embedSwiftUI(_ coder: NSCoder) -> UIViewController? {
		let host = UIHostingController(coder: coder, rootView: TodayView())
		host!.view.backgroundColor = UIColor.clear

		return host
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		// Perform any setup necessary in order to update the view.

		// If an error is encountered, use NCUpdateResult.Failed
		// If there's no update required, use NCUpdateResult.NoData
		// If there's an update, use NCUpdateResult.NewData

		completionHandler(NCUpdateResult.newData)
	}
    
}

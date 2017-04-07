//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by Justin Storm on 4/7/17.
//  Copyright © 2017 Mic Pringle. All rights reserved.
//

import WatchKit
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController {
  @IBOutlet var originLabel: WKInterfaceLabel!
  @IBOutlet var destinationLabel: WKInterfaceLabel!
  @IBOutlet var boardingPassImage: WKInterfaceImage!
  
  var flight: Flight? {
    didSet {
      if let flight = flight {
        originLabel.setText(flight.origin)
        destinationLabel.setText(flight.destination)
        if let _ = flight.boardingPass {
          showBoardingPass()
        }
      }
    }
  }
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    if let flight = context as? Flight {
      self.flight = flight
    }
  }
  
  override func didAppear() {
    super.didAppear()
    // 1
    if let flight = flight, flight.boardingPass == nil && WCSession.isSupported() {
      // 2
      WatchSessionManager.sharedManager.sendMessage(message: ["reference": flight.reference], replyHandler: { (response) -> Void in
        // 3
        if let boardingPassData = response["boardingPassData"] as? NSData, let boardingPass = UIImage(data: boardingPassData as Data) {
          // 4
          flight.boardingPass = boardingPass
          DispatchQueue.main.async(execute: { () -> Void in
            self.showBoardingPass()
          })
        }
      }, errorHandler: { (error) -> Void in
        // 5
        print(error)
      })
    }
  }
  
  private func showBoardingPass() {
    boardingPassImage.stopAnimating()
    boardingPassImage.setWidth(120)
    boardingPassImage.setHeight(120)
    boardingPassImage.setImage(flight?.boardingPass)
  }
}

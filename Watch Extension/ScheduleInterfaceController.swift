//
//  ScheduleInterfaceController.swift
//  AirAber
//
//  Created by Justin Storm on 4/7/17.
//  Copyright © 2017 Mic Pringle. All rights reserved.
//

import WatchKit

class ScheduleInterfaceController: WKInterfaceController {

  @IBOutlet var flightsTable: WKInterfaceTable!

  var flights = Flight.allFlights()

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")

    for index in 0 ..< flightsTable.numberOfRows {
      guard let controller = flightsTable.rowController(at: index) as? FlightRowController else {
        continue
      }
      
      controller.flight = flights[index]
    }
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    let flight = flights[rowIndex]
    presentController(withName: "Flight", context: flight)
  }
  
}

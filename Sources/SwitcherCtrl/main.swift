//
//  SwitcherCtrl.swift
//  SerialTools
//
//  Created by Kyle Meredith on 6/8/17.
//
//

import Foundation
import SwiftSerial
import SerialUtils

var switcher: SerialPort?
print("yo")

func startSwitcher() -> Void {
    let portName: String = "/dev/cu.usbserial"
    switcher = openPort(portName: portName)
}

func turnOn(portNum: Int) -> Void {
    do {
        let command: String = "\(0x81808101 + (portNum << 16))"
        var bytesWritten: Int        // # of bytes written by writeData
        var commandReceived: String      // result of readLine
        
        print("Writing test num <\(command)> to serial port")
        
        bytesWritten = try switcher!.writeString(command)
        
        print("Successfully wrote \(bytesWritten) bytes")
        print("Waiting to receive what was written...")
        
        commandReceived = try switcher!.readString(ofLength: bytesWritten)
        if command == commandReceived {
            print("Received string is the same as transmitted string. Test successful!")
        } else {
            print("Uh oh! Received string is not the same as what was transmitted. This was what we received,")
            print("<\(commandReceived)>")
        }
    } catch {
        print("Error: \(error)")
    }
}

startSwitcher()
turnOn(portNum: 1)




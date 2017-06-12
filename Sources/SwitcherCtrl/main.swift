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

func startSwitcher() -> Void {
    let portName: String = "/dev/cu.usbserial"
    switcher = openPort(portName: portName)
}

func turnOn(portNum: Int) -> Void {
    do {
        var commandInt: Int = 0x81808101 + (portNum << 16)
        print(commandInt)
        let commandBytes = NSData(bytes: &commandInt, length: 8)
        var bytesWritten: Int               // # of bytes written by writeData
        var commandReceived: Data      // result of readLine
        
        print("Writing test num <\(commandBytes)> to serial port")
        
        bytesWritten = try switcher!.writeData(commandBytes as Data)
        
        print("Successfully wrote \(bytesWritten) bytes")
        print("Waiting to receive what was written...")
        
        commandReceived = try switcher!.readData(ofLength: bytesWritten)
        if commandBytes as Data == commandReceived {
            print("Received command is the same as transmitted command. Test successful!")
        } else {
            print("Uh oh! Received string is not the same as what was transmitted. This was what we received,")
            print("<\(commandReceived)>")
        }
    } catch {
        print("Error: \(error)")
    }
}

func turnOnTest() -> Void {
    do {
        //var cmd: UInt = 0x81808101 + (3 << 16)
        
        var cmd: UInt32 = 0x81808101
        let data = NSData(bytes: &cmd, length: 4)
        
        var bytesWritten: Int
        var commandReceived: Data
        
        print("Writing <\(data)> to serial port")
        
        bytesWritten = try switcher!.writeData(data as Data)
        commandReceived = try switcher!.readData(ofLength: bytesWritten)
        
        print("sent \(bytesWritten) of \(data)")
//        print("received \(commandReceived)")
        
        
        } catch {
        print("Error: \(error)")
    }
}


func closePort(port: SerialPort) -> Void {
    // return true if CloseHandle returns nonzero
    closePort(serialPort: port);
}

startSwitcher()
turnOnTest()




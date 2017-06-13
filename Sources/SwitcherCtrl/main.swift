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

// Initializes the video switcher using openPort from serialUtils
func startSwitcher() -> Void {
    let portName: String = "/dev/cu.usbserial"
    switcher = openPort(portName: portName)
}


// The following functions use the pattern of hex commands supplied by the Kramer manual:
// https://k.kramerav.com/downloads/protocols/protocol_2000_rev0_51.pdf

// Turns on the video output specified by outNum on the switcher box
func turnOn(_ outNum: Int) -> Void {
    var cmd: Int = 0x81808101 + (outNum << 16)
    sendCmd(cmd: &cmd, serialPort: switcher!)
}

// Turns off the video output specified by outNum on the switcher box
func turnOff(_ outNum: Int) -> Void {
    var cmd: Int = 0x81808001 + (outNum << 16)
    sendCmd(cmd: &cmd, serialPort: switcher!)
}



startSwitcher()

var run = true
var input: String

// This loop will take user input until the exit key ("l" for "leave") is entered
// The number keys turn on their respective output, while the letters below each key turn off that output. "0" and "p" turn on/off all outputs
while run {
    input = readLine()!
    
    switch input {
    case "0":
        turnOn(0)
    case "1":
        turnOn(1)
    case "2":
        turnOn(2)
    case "3":
        turnOn(3)
    case "4":
        turnOn(4)
    case "5":
        turnOn(5)
    case "6":
        turnOn(6)
    case "7":
        turnOn(7)
    case "8":
        turnOn(8)

    case "p":
        turnOff(0)
    case "q":
        turnOff(1)
    case "w":
        turnOff(2)
    case "e":
        turnOff(3)
    case "r":
        turnOff(4)
    case "t":
        turnOff(5)
    case "y":
        turnOff(6)
    case "u":
        turnOff(7)
    case "i":
        turnOff(8)
        
    case "l":
        run = false
        
    default:
        print("instructions")
}
}
    
closePort(switcher!)



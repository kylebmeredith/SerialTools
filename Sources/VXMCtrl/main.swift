//
//  VXMCCtrl.swift
//  SerialTools
//
//  Created by Kyle Meredith on 6/9/17.
//  Largely copied from INSERT THE NAME HERE
//  MAYBE REMOVE ALL THE CHECKS FOR =1 AND MAKE CLEAR AND WAIT FUNCTIONS AND REMOVE BOOL RETURNS

import Foundation
import SwiftSerial
import SerialUtils

var VXM: SerialPort?

// see the VXM manual for more details on the commands:
// http://www.velmex.com/Downloads/User_Manuals/vxm_user_manl.pdf

// Initializes the VXM controller using openPort from serialUtils
// and finds the negative limit.
// returns false if there is a problem
func startVXM() -> Bool {
    do {
        let portName: String = "/dev/cu.usbserial"
        VXM = openPort(portName: portName)
        
        // "F" initializes the motor with echo off
        // "V" gets the status to confirm the connection
        // writeString returns the number of bytes written to, which isn't relevant
        // this return value will be ignored throughout (it can be reinstantiated for debugging)
        _ = try VXM!.writeString("FV")
        
        // readChar() returns the result of the status check
        // status is "x" if it doesn't respond, "R" if it's ready;
        var response: UnicodeScalar = "x"
        response = try VXM!.readChar()
        if (response != "R") {
            closePort(VXM!)                 // close the port to free it up
            return false
        }
        
        // clear any commands that might have been stored in the controller
        _ = try VXM!.writeString("C")
        
        // set the motor type to Vekta PK266
        // see Manual pg 25 for details
        _ = try VXM!.writeString("setM1M4")
        
        // set the motor speed to 4000 steps/sec
        // "." finishes the speed command, then "R" executes it
        _ = try VXM!.writeString("S1M4000.R")
        
        // wait until a "^" is received, meaning the command is done executing
        while (response != "^") {
            response = try VXM!.readChar()
        }
        
        // clear command memory
        _ = try VXM!.writeString("C")
    } catch {
        print("Error: \(error)")
    }
    return true;
}


// Moves the motor to the zero position (negative limit) and sets that index to absolute zero
func zero() {
    do {
        // clear command memory, just in case
        _ = try VXM!.writeString("C")
        
        // move to the negative limit
        _ = try VXM!.writeString("I1M-0.")       //must end with . after a number
        
        // set this position index to absolute zero
        _ = try VXM!.writeString("IA1M-0.R")
        
        // wait until a "^" is received, meaning the command is done executing
        var response: UnicodeScalar = " "
        while (response != "^") {
            response = try VXM!.readChar()
        }
        
        // clear command memory
        _ = try VXM!.writeString("C")
    } catch {
        print("Error: \(error)")
    }
}

// moves to dist millimeters from absolute zero.  dist should be
// positive, since we set absolute zero to be the negative limit.
// note: 1 millimeter = 200 steps
func moveTo(dist: Int) -> Void {
    do {
        // clear command memory, just in case
        _ = try VXM!.writeString("C")
        
        // check the status to ready the box for the next program
        _ = try VXM!.writeString("V")
        
        // write the move command
        _ = try VXM!.writeString("IA1M\(dist*200).R")
        
        // wait until a '^' is received, meaning the command is done executing
        var response: UnicodeScalar = " "
        while (response != "^") {
            response = try VXM!.readChar()
        }
        
        // clear command memory
        _ = try VXM!.writeString("C")
    } catch {
        print("Error: \(error)")
    }
}

func stop() {
    do {
        // quit the controller (put it back in local mode)
        _ = try VXM!.writeString("Q")
        
        // close the file handle
        closePort(VXM!);
    } catch {
        print("Error: \(error)")
    }
}


_ = startVXM()
zero()
moveTo(dist: 10)




//var run = true
//var input: String
//
//// This loop will take user input until the exit key ("l" for "leave") is entered
//// The number keys turn on their respective output, while the letters below each key turn off that output. "0" and "p" turn on/off all outputs
//while run {
//    input = readLine()!
//    
//    switch input {
//    case "0":
//        turnOn(0)
//    case "1":
//        turnOn(1)
//    case "2":
//        turnOn(2)
//    case "3":
//        turnOn(3)
//    case "4":
//        turnOn(4)
//    case "5":
//        turnOn(5)
//    case "6":
//        turnOn(6)
//    case "7":
//        turnOn(7)
//    case "8":
//        turnOn(8)
//        
//    case "p":
//        turnOff(0)
//    case "q":
//        turnOff(1)
//    case "w":
//        turnOff(2)
//    case "e":
//        turnOff(3)
//    case "r":
//        turnOff(4)
//    case "t":
//        turnOff(5)
//    case "y":
//        turnOff(6)
//    case "u":
//        turnOff(7)
//    case "i":
//        turnOff(8)
//        
//    case "l":
//        run = false
//        
//    default:
//        print("instructions")
//    }
//}
//
//closePort(switcher!)
//
//

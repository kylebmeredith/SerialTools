//
//  VXMCCtrl.swift
//  SerialTools
//
//  Largely adapted from previous C# code:
//  http://www.cs.middlebury.edu/~schar/research/summer05/jeff/Active%20Lighting/ActiveLighting%203.3.1/VXMCtrl.cpp

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

// Moves the motor to dist millimeters from absolute zero. dist should be
// positive, since we set absolute zero to be the negative limit.
// note: 1 millimeter = 200 steps
func moveTo(dist: Int) -> Void {
    do {
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

//
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

var run = true
var input: String

// This loop will take user input until the exit key ("l" for "leave") is entered
// "0" triggers the zero() funcion, while all other numbers move the motor to that index
while run {
    input = readLine()!
    if input == "l" {
        run = false
        break
    }
    var num = Int(input)
    
    switch num! {
    case 0:
        zero()
    case nil:
        print("Enter 0 to zero, int to moveTo(int in mm), l to leave")
    default:
        moveTo(dist: num!)
    }
}

// After the input is finished, close the port
stop()



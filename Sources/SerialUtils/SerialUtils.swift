// SeriualUtils.swift
//
// Controls opening and closing of serial ports

import SwiftSerial

public func openPort(portName: String) -> SerialPort {
    let serialPort: SerialPort = SerialPort(path: portName)
    
    do {
        print("Attempting to open port: \(portName)")
        try serialPort.openPort()
        print("Serial port \(portName) opened successfully.")
        
        serialPort.setSettings(receiveRate: .baud9600,
                               transmitRate: .baud9600,
                               minimumBytesToRead: 8)
    } catch {
        print("Error: \(error)")
    }
    return serialPort
}


public func closePort(serialPort: SerialPort) -> Void {
    serialPort.closePort()
    print("Port Closed")
}

// SeriualUtils.swift
//
// Controls opening and closing of serial ports

import Foundation
import SwiftSerial

public func openPort(portName: String) -> SerialPort {
    let serialPort: SerialPort = SerialPort(path: portName)
    
    do {
        print("Attempting to open port: \(portName)")
        try serialPort.openPort()
        print("Serial port \(portName) opened successfully.")
        
        serialPort.setSettings(receiveRate: .baud9600,
                               transmitRate: .baud9600,
                               minimumBytesToRead: 1,
                               timeout: 1,
                               useHardwareFlowControl: true,
                               useSoftwareFlowControl: true,
                               processOutput: true)
    } catch {
        print("Error: \(error)")
    }
    return serialPort
}


public func closePort(serialPort: SerialPort) -> Void {
    serialPort.closePort()
    print("Port Closed")
}


extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    public func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

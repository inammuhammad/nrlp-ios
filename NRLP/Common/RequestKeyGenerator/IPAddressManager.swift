//
//  IPAddressManager.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

final class IPAddressManager {
    static func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                     let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return  formatIPAddress(address)
    }
    
    static func formatIPAddress (_ address: String?) -> String {
        let address1 = address ?? "0000.0000.0000.0000"
        let splits = address1.split(separator: ".")
        var outputSplits = ["0000", "0000", "0000", "0000"]
        
        for (index, split) in splits.enumerated() {
            if index > 3 {
                break
            }
            
            let ssplit = String(split)
            let count = ssplit.count
            if count >= 4 {
                outputSplits[index] = String(ssplit.prefix(4))
            } else {
                outputSplits[index] = ssplit + String(repeating: "0", count: 4 - count)
            }
        }
        return  outputSplits.joined(separator: ".")
    }

}

//
//  Untitled.swift
//  medium_weather_app
//
//  Created by Artur Harutyunyan on 09.03.25.
//

import SwiftUI
import Network
import Foundation

func checkInternetConnection(completion: @escaping (Bool) -> Void) {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionQueue")
    
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    monitor.start(queue: queue)
}

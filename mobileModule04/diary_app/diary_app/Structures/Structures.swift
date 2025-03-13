//
//  Structures.swift
//  diary_app
//
//  Created by Artur Harutyunyan on 13.03.25.
//

import Foundation


struct Notes : Codable {
    var date: String
    var feeling: String
    var text: String
    var title: String
    var usermail: String
}

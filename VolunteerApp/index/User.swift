//
//  User.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

//8.index
import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let npoName: String
    let npo: Npo


    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case npoName = "npo_name"
        case npo

    }
}

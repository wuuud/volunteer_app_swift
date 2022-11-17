//
//  Application.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

import Foundation


struct Application: Codable {
    let id: Int
    let career: String
    let volunteerName: String
    let volunteerImageUrl: String
    
    
    enum CodingKeys:  String, CodingKey {
        case id
        case career
        case volunteerName = "user_name"
        case volunteerImageUrl = "image_url"
        //case status
    }
}

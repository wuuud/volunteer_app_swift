//
//  VolunteerOffer.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//


//8.index
import Foundation

struct VolunteerOffer: Codable {
    let id: Int
    let title: String
    let description: String
    let startDate: String
    let npoName: String
    let npoImageUrl: String
    
    enum CodingKeys:  String, CodingKey {
        case id
        case title
        case description
        case startDate = "start_date"
        case npoName = "npo_name"
        case npoImageUrl = "image_url"
    }
}

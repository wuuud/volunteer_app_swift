//
//  Propose.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//
import Foundation

//Index.swiftに定義
struct Propose: Codable {
    let id: Int
//    let results : [Propose]?
    let volunteerName: String
    //let volunteerImageUrl: String
    //let status: String
    
    
    enum CodingKeys:  String, CodingKey {
        case id
        case volunteerName = "user_name"
        //case volunteerImageUrl = "image_url"
        //case status
    }
}

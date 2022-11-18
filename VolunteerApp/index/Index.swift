//
//  Index.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/13.
//

import Foundation


struct Index: Codable {
    let data: [VolunteerOffer]?  //nilをチェック  ？
}

struct ApplicationIndex: Codable {
    let data: [Application]?  //nilをチェック  ？
}

struct ProposeIndex: Codable {
    let data: [Propose]?  //nilをチェック  ？
}

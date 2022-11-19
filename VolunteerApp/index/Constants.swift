//
//  Constants.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/13.
//


import Foundation


struct Constants {
    static let shared = Constants()
    private init() {}
    /* localhost */
    let baseUrl = ProcessInfo.processInfo.environment["BASE_URL"]!
    let oauthUrl  = ProcessInfo.processInfo.environment["BASE_URL"]! + "/oauth/authorize"
    let clientId = ProcessInfo.processInfo.environment["CLIENT_ID"]! //自分のクライアントのID
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"]! //クライアントIDに対応したシークレット
    let callbackUrlScheme = "volunteer-match-oauth"
    let service = "volunteer-match-oauth"
    let redirectUri = "volunteer-match-oauth://callback"
}

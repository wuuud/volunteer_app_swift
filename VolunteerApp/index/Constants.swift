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
        let baseUrl = "https://volunteer-match-22.herokuapp.com"
        let oauthUrl  = "https://volunteer-match-22.herokuapp.com/oauth/authorize"
        let clientId = "11" //自分のクライアントのID
        let clientSecret = "JDQmkezPcSkMEiB5QsI3kuZZiLHgkzhRDMgt4ApQ" //クライアントIDに対応したシークレット
        let callbackUrlScheme = "volunteer_match_oauth"
        let service = "volunteer_match_oauth"
        let redirectUri = "volunteer_match_oauth://callback"
}

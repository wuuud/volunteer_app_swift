//
//  GetToken.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/13.
//

import Foundation

//APIへのリクエストに対するレスポンス例
//{
//  "access_token" : "eyJ0eXAiOi #中略# OiJSUzI1NiDTY",
//  "expires_in" : 31536000,
//  "token_type" : "Bearer"   ← 欲しいのはaccess_token!
//}

struct GetToken: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

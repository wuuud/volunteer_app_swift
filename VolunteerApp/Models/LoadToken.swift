//
//  LoadToken.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

//8.index
//アクセストークンの読み込みはどの画面でも必要になるので、処理をまとめて使いやすく
import Foundation
import KeychainAccess

struct LoadToken {
//KeychainAccessのライブラリを使って、アクセストークンが保存されているときは読み込んできて、アクセストークンを返すという処理をloadAccessToken()
    func loadAccessToken() -> String {
        var token = ""
        let keychain = Keychain(service: Constants.shared.service)
        guard let accessToken = keychain["access_token"] else {
            print("NO TOKEN")
            return ""
        }
        token = accessToken

        // heroku-volunteer
//        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMCIsImp0aSI6IjcxYmViNWY1ZTdhOTA4NDc5ZTE2YWI5ZDVkMjUwMTNlM2JhMjdmZmY3MGY4OTlhODE2NmM2ZmM2ZmQ1ZDcxY2Q2MDUxM2I2OGQ5NzE4NWU2IiwiaWF0IjoxNjY4NjQ4MjU4LjUzMTc2MiwibmJmIjoxNjY4NjQ4MjU4LjUzMTc2MywiZXhwIjoxNzAwMTg0MjU4LjUyNDE1OSwic3ViIjoiMjEiLCJzY29wZXMiOltdfQ.rYu4cMC4YLMeemXWvYM5uphL5RRQjqWJON44WrnMSQCfg8KyNDZtfgqSqkQjlpMm_VblBP0vPzR0J4MuDvpVd3MXE7C5mKOsBKm6i5DjIjAD94uwXDw8KSRx4AbVBokd6j9qP4QJmcn04l5qf3WgwhRX767kG13c3jNsqR1NoBCdhFBkz0dTLftGQBJbRx0BCkZkVa-dcY9P_SDFDc-dxHjiiqZ1ELdhnkkAJyFGQQ5Oy293O97C-79xYaQrC4jGoqX_lfmr6gXwQvfB95Y__lrZTQAiqGEmro1OTYhrg1ichMa3u48ebfdwda2b5Y0m-FfZ0J-RR0Z-kStxK6KQicjs-SkxLiQUon01OAvhBKLp-HBM-10CxPhvzHnywfKhHo4s-suYRotNGvAYBoDf97vbUYM1NFKfZ_V-z8YGyEuvwv7MEe4JS3zCdb6Gdb_qBvnXtmRfoMBL19rRZuFDsrj2CVDUxZFQjl04GO1q0EXCipLvhDCEUumLiCnbqhAuccrbPq5ckVqd7_x7lZZAbD1CAtycwnJch-RqXJlBH3YIO1Jlch1uHbHj-Xw43i8uxhWGQJ7us7agE3O9A8IFGhU69QTRs1hPKnccnW-iOBAUStng1ySz4WXsxfvluKeeFblqI8spWOJhugGd60XDvntbmAgygU3E4xcC5wkBUAk"
        
        // heroku-npo
        token =  "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5IiwianRpIjoiOWU3ODA2NGY5MGNkODUyMjhlZDAxMThjYThiODYxYTljOTcyZTRhZjI2MjZkODYzMGUzZjE2NTQxZDg4OTQ3YjA3MTc2MGM4ZGIzMGJmNjIiLCJpYXQiOjE2Njg2NTAzOTQuMzkwNjQ0LCJuYmYiOjE2Njg2NTAzOTQuMzkwNjQ3LCJleHAiOjE3MDAxODYzOTQuMzgzMTczLCJzdWIiOiIxMSIsInNjb3BlcyI6W119.Kj564uRr5NEOzUxCEbqkDeLbiB-JPLXKsIZ6x0ipqHQonUlSQxOUcGrPeUR72cRXkV0TO2l8BeC-RF28ONTQMpYE87z9G21o9RG-EJ30E2uFoDx5avitZq73DKuJdpfrM33nAD8FMMuveG_hJUn59FfoXnwi6Hueo4O0nPy4Z24TwpXLY_HFpVwH3zR__7TYgXkISMPcvjRkymHfpCLhGl28FvOg6rUac8zHMRKm_mke0JtZYdjbjfrtkee8khDJyyvvjGkIIRf4UCBexQQ7YYqcydFd2K3BibZfVKUt3UP1ItkRvYlxD9yUpVXCclj4dYbNZzVoMzjOC0ZZe4o0yn_5a2qtIerd-Z6n5wk4gkRZV-b060-vzX_f6oYTmZP-3wFshMt-srNELqnuFRG7QnRhD3_61HzWWu9SZXofnnAX72z46nQ_AYUAIxgL-76Ma3v6GKMFO3A36kY9Ihq6n8Gcrw-nhR1IhtjGVtBmvsoU_fzOT_bibsuhdZvgJaP93YCPHjZHPmd6f1Cdb8eseXMnOvoiC-vxxr5Rl7d3d7EQvXMPE4oR0fhTDu-Zg-ojG8pNsQj2SE9DxhClWuapYT9V5ed_HDFlIu5XrgJuE31LKfPyBlRqYNPuIdlgWzQPk3o-UolB9WCmTRydw02UvS7qWTO07Jw99jOzKVEp8Nk"
        
        return token
    }
}

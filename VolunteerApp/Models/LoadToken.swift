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
        guard let accessToken = keychain["token"] else {
            print("NO TOKEN")
            return ""
        }
        token = accessToken
//
//        // heroku-volunteer
//        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMCIsImp0aSI6IjcxYmViNWY1ZTdhOTA4NDc5ZTE2YWI5ZDVkMjUwMTNlM2JhMjdmZmY3MGY4OTlhODE2NmM2ZmM2ZmQ1ZDcxY2Q2MDUxM2I2OGQ5NzE4NWU2IiwiaWF0IjoxNjY4NjQ4MjU4LjUzMTc2MiwibmJmIjoxNjY4NjQ4MjU4LjUzMTc2MywiZXhwIjoxNzAwMTg0MjU4LjUyNDE1OSwic3ViIjoiMjEiLCJzY29wZXMiOltdfQ.rYu4cMC4YLMeemXWvYM5uphL5RRQjqWJON44WrnMSQCfg8KyNDZtfgqSqkQjlpMm_VblBP0vPzR0J4MuDvpVd3MXE7C5mKOsBKm6i5DjIjAD94uwXDw8KSRx4AbVBokd6j9qP4QJmcn04l5qf3WgwhRX767kG13c3jNsqR1NoBCdhFBkz0dTLftGQBJbRx0BCkZkVa-dcY9P_SDFDc-dxHjiiqZ1ELdhnkkAJyFGQQ5Oy293O97C-79xYaQrC4jGoqX_lfmr6gXwQvfB95Y__lrZTQAiqGEmro1OTYhrg1ichMa3u48ebfdwda2b5Y0m-FfZ0J-RR0Z-kStxK6KQicjs-SkxLiQUon01OAvhBKLp-HBM-10CxPhvzHnywfKhHo4s-suYRotNGvAYBoDf97vbUYM1NFKfZ_V-z8YGyEuvwv7MEe4JS3zCdb6Gdb_qBvnXtmRfoMBL19rRZuFDsrj2CVDUxZFQjl04GO1q0EXCipLvhDCEUumLiCnbqhAuccrbPq5ckVqd7_x7lZZAbD1CAtycwnJch-RqXJlBH3YIO1Jlch1uHbHj-Xw43i8uxhWGQJ7us7agE3O9A8IFGhU69QTRs1hPKnccnW-iOBAUStng1ySz4WXsxfvluKeeFblqI8spWOJhugGd60XDvntbmAgygU3E4xcC5wkBUAk"
        
        // heroku-npo
//        token =  "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMSIsImp0aSI6ImQ1NTg2NmE2YTA0YWMzN2YwMTI2OTQ3ZWU2NGY2YWFmYThjZDdkODU2ZTliYzhkMWJmZGFhOWUyNTkzZmEzN2ZhODYzYjViYzVjNTRjZmRmIiwiaWF0IjoxNjY4NzMyNzg3Ljc1OTI5OCwibmJmIjoxNjY4NzMyNzg3Ljc1OTMwMSwiZXhwIjoxNzAwMjY4Nzg3Ljc0MzIyMywic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.MyZrj1eLLdPaqODHVg57R4OCKNO-ZecyZ2q8JvZvl8JHlpd71cYjr-4yjwqeT-wAi1ZmpkQ6irehjwdnQ-JpvZNFWmCu6kZF1uJ1jQlx9a0oWMUIrVSLKtwsfdsoDTJ4oMiDhk4H1BqYvntOJOUxS3pxO6iQTtcignGw473mF2Na_9bny9eaM7EHHiHwf24ig8pG1KVtNZ20aiMtWeXmqrKrzdcN4tJbK6tkvcI9lE6Dp3nNt-9CZsW5TOBUjsDcX4tf9jSgqRA40PtfttgPzfZ4_m2_Z9f0wYbDimUg0IqSaiF-T7Nh-uUsyPm3m0dHXc14lgNi5mwY3UlkuA-w3s__gTE-EIuzaIQ5U_L--NoHvBqhG6weUm6ejxbF4W2KNkxXHYdRG1MJgpqOUtjCyfVvFHapy9y7fO1adQR2pvTZk0yEYKiJUs8EHz4VRhRG2tWXQFKV4B2KP9M54MZtDxl7MUMsHqfMe8YkCq5De-W58cXs1nIPpud4TUqaW3aa_aBxe95yadG0Pbiw0l9ky_MR4EAe0h9fASZUC7kQbPUAMXI7ls9lac8lJyzmnK0FrkDpFi5OounJPGmMq2A-OMx9rKav7rEIRh56scrbEm4TXD53-CeVY1LCVUMwEW7_0j5oLhZUOhXOqbwhXLYChiNTwutoJWpZ8bA_VloyIJo"
        
        return token
    }
    static func loadAccessToken() -> String {
        var token = ""
        let keychain = Keychain(service: Constants.shared.service)
        guard let accessToken = keychain["token"] else {
            print("NO TOKEN")
            return ""
        }
        token = accessToken
//
//        // heroku-volunteer
//        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMCIsImp0aSI6IjcxYmViNWY1ZTdhOTA4NDc5ZTE2YWI5ZDVkMjUwMTNlM2JhMjdmZmY3MGY4OTlhODE2NmM2ZmM2ZmQ1ZDcxY2Q2MDUxM2I2OGQ5NzE4NWU2IiwiaWF0IjoxNjY4NjQ4MjU4LjUzMTc2MiwibmJmIjoxNjY4NjQ4MjU4LjUzMTc2MywiZXhwIjoxNzAwMTg0MjU4LjUyNDE1OSwic3ViIjoiMjEiLCJzY29wZXMiOltdfQ.rYu4cMC4YLMeemXWvYM5uphL5RRQjqWJON44WrnMSQCfg8KyNDZtfgqSqkQjlpMm_VblBP0vPzR0J4MuDvpVd3MXE7C5mKOsBKm6i5DjIjAD94uwXDw8KSRx4AbVBokd6j9qP4QJmcn04l5qf3WgwhRX767kG13c3jNsqR1NoBCdhFBkz0dTLftGQBJbRx0BCkZkVa-dcY9P_SDFDc-dxHjiiqZ1ELdhnkkAJyFGQQ5Oy293O97C-79xYaQrC4jGoqX_lfmr6gXwQvfB95Y__lrZTQAiqGEmro1OTYhrg1ichMa3u48ebfdwda2b5Y0m-FfZ0J-RR0Z-kStxK6KQicjs-SkxLiQUon01OAvhBKLp-HBM-10CxPhvzHnywfKhHo4s-suYRotNGvAYBoDf97vbUYM1NFKfZ_V-z8YGyEuvwv7MEe4JS3zCdb6Gdb_qBvnXtmRfoMBL19rRZuFDsrj2CVDUxZFQjl04GO1q0EXCipLvhDCEUumLiCnbqhAuccrbPq5ckVqd7_x7lZZAbD1CAtycwnJch-RqXJlBH3YIO1Jlch1uHbHj-Xw43i8uxhWGQJ7us7agE3O9A8IFGhU69QTRs1hPKnccnW-iOBAUStng1ySz4WXsxfvluKeeFblqI8spWOJhugGd60XDvntbmAgygU3E4xcC5wkBUAk"
        
        // heroku-npo
//        token =  "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMSIsImp0aSI6ImQ1NTg2NmE2YTA0YWMzN2YwMTI2OTQ3ZWU2NGY2YWFmYThjZDdkODU2ZTliYzhkMWJmZGFhOWUyNTkzZmEzN2ZhODYzYjViYzVjNTRjZmRmIiwiaWF0IjoxNjY4NzMyNzg3Ljc1OTI5OCwibmJmIjoxNjY4NzMyNzg3Ljc1OTMwMSwiZXhwIjoxNzAwMjY4Nzg3Ljc0MzIyMywic3ViIjoiMTEiLCJzY29wZXMiOltdfQ.MyZrj1eLLdPaqODHVg57R4OCKNO-ZecyZ2q8JvZvl8JHlpd71cYjr-4yjwqeT-wAi1ZmpkQ6irehjwdnQ-JpvZNFWmCu6kZF1uJ1jQlx9a0oWMUIrVSLKtwsfdsoDTJ4oMiDhk4H1BqYvntOJOUxS3pxO6iQTtcignGw473mF2Na_9bny9eaM7EHHiHwf24ig8pG1KVtNZ20aiMtWeXmqrKrzdcN4tJbK6tkvcI9lE6Dp3nNt-9CZsW5TOBUjsDcX4tf9jSgqRA40PtfttgPzfZ4_m2_Z9f0wYbDimUg0IqSaiF-T7Nh-uUsyPm3m0dHXc14lgNi5mwY3UlkuA-w3s__gTE-EIuzaIQ5U_L--NoHvBqhG6weUm6ejxbF4W2KNkxXHYdRG1MJgpqOUtjCyfVvFHapy9y7fO1adQR2pvTZk0yEYKiJUs8EHz4VRhRG2tWXQFKV4B2KP9M54MZtDxl7MUMsHqfMe8YkCq5De-W58cXs1nIPpud4TUqaW3aa_aBxe95yadG0Pbiw0l9ky_MR4EAe0h9fASZUC7kQbPUAMXI7ls9lac8lJyzmnK0FrkDpFi5OounJPGmMq2A-OMx9rKav7rEIRh56scrbEm4TXD53-CeVY1LCVUMwEW7_0j5oLhZUOhXOqbwhXLYChiNTwutoJWpZ8bA_VloyIJo"
        
        return token
    }
}


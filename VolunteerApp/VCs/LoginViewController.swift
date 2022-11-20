//
//  LoginViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/13.
//

import UIKit
//7.oauth認証
import AuthenticationServices
import Alamofire
import KeychainAccess


class LoginViewController: UIViewController {
    //7.oauth認証
    let consts = Constants.shared
    var session: ASWebAuthenticationSession? //Webの認証セッションを入れておく変数
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        アプリ起動時にキーチェーンに保存したアクセストークンを削除したい。認証の確認等)にコメントアウトを解除。
        let keychain = Keychain(service: consts.service)
        //if keychain["access_token"] != nil {
        keychain["access_token"] = nil //keychainに保存されたtokenを削除
        //}
    }
    
    //7.oauth認証
    //取得したcodeを使ってアクセストークンを発行
    func getAccessToken(code: String) {
        //オプショナルバインディングでアンラップ
        guard let url = URL(string: consts.baseUrl + "/oauth/token") else { return }
        //トークン発行に必要なパラメータを追加
        let parameters: Parameters = [
            "grant_type": "authorization_code",
            "client_id": consts.clientId,
            "client_secret": consts.clientSecret,
            "code": code,
            // "redirect_uri": consts.redirectUri
        ]
        //Alamofireでリクエスト
        AF.request(
            url,
            method: .post,
            parameters: parameters
        ).responseDecodable(of: GetToken.self) { response in //swiftで使える値に修正
            switch response.result {
            case .success(let value):
                let token = value.accessToken
                //７.oauth認証
                Task .detached { @MainActor in
                    print("🤫transitionToIndex")
                    self.transitionToIndex() //func transitionToIndex()
                }
                let keychain = Keychain(service: self.consts.service) //このアプリ用のキーチェーンを生成
                keychain["token"] = token //トークンをキーチェーンに保存 キーは"access_token"
                print("🙏🙏toekn🙏")
                print(token)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //QiitaとURL以外は同じ
    @IBAction func login(_ sender: UIButton) {
        //７.oauth認証
        //KeychainAccessにアクセストークンがある場合
        let keychain = Keychain(service: consts.service)
        if keychain["access_token"] != nil {
            transitionToIndex() //func transitionToIndex()
            //KeychainAccessにアクセストークンがない場合
        } else {
            //7.oauth認証
            //認証セッション用(code取得)のためのURLを作成   { return }でここでfunc終了
            guard let url = URL(string: consts.oauthUrl + "?client_id=\(consts.clientId)&response_type=code&scope=") else { return }
            //認証セッション格納用の変数sessionの用意
            session = ASWebAuthenticationSession(url: url, callbackURLScheme: consts.callbackUrlScheme) {(callback, error) in
                guard error == nil, let successURL = callback else { return }
                let queryItems = URLComponents(string: successURL.absoluteString)?.queryItems
                guard let code = queryItems?.filter({ $0.name == "code" }).first?.value else { return }
                print("✨✨✨✨✨code✨✨✨✨✨")
                print(code)
                self.getAccessToken(code: code)
                print("✨✨✨✨✨token✨✨✨✨✨")
                print((LoadToken()).loadAccessToken())
//                Task .detached{@MainActor in
//                    self.transitionToIndex()
//                }
            }
        }
        //7.oauth認証
        //web認証の画面を同一画面で開くためのデリゲートの設定とデリゲートメソッドを追加。
        session?.presentationContextProvider = self
        //認証セッションと通常のブラウザで閲覧情報やCookieを共有しないように設定。デフォルトだとfalse
        session?.prefersEphemeralWebBrowserSession = true
        session?.start()  //セッションの開始(これがないと認証できない)
    }
    
    //次の画面に遷移する処理 ナビゲーションバーが自動で付き、ナビゲーションバーに戻るためのボタンも自動についた一覧画面(IndexViewController)を表示
    //アクセストークンを取得して保存までできた時や、アクセストークンをすでに持っていた時
    func transitionToIndex() {
        Task .detached{@MainActor in
            let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }
    }
}
//7.oauth認証
//ほぼ決り文句 ログインボタンを押したとき認証の画面に遷移できる
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}











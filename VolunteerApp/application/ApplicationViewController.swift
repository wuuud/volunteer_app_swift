//
//  ApplicationViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

import UIKit
import Alamofire
import Kingfisher
import KeychainAccess


class ApplicationViewController: UIViewController {
    let consts = Constants.shared
    let sectionTitle = ["スカウト候補者一覧"]
    private var token = ""
    //APIのレスポンスから取り出した値を入れておく変数を追加
    var applications: [Application] = []
    var user: User!
    
    @IBAction func proposeButton(_ sender: UIButton) {
      
    }
    
    @IBOutlet weak var applicationTableView: UITableView!
//    @IBAction func pressedCreateButtton(_ sender: UIBarButtonItem) {
//        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateViewController
//        guard user != nil else { return }
//        //createVC.user = user  //createViewControllerに記載する必要がある
//        navigationController?.pushViewController(createVC, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()  //ユーザー情報(idとname)の取得は1回でいいからここに記載。下で定義。
        applicationTableView.dataSource = self  //テーブルビューに一覧表示。extensinに記載。
//        applicationTableView.delegate = self    //記事がタップされたら詳細画面へ。下に定義
        //TextViewとImageViewに枠線をつける
        let viewCustomize = ViewCustomize()
//        CareerTextView = viewCustomize.addBoundsTextView(textView: CareerTextView)
//        VolunteerImageView = viewCustomize.addBoundsImageView(imageView: VolunteerImageView)
//        volunteerLabel = viewCustomize.addBoundsLabel(label: volunteerLabel)
    }
    override func viewWillAppear(_ animated: Bool) {
        requestIndex()  //この画面に戻る度に表示できるように。下で定義。
    }
    
    //一覧画面を取得するリクエストをAPIに送信する関数 大体決り文句
    //responseの中に記事のデータがあるかをチェックして、ある場合は定義しておいたapplicationsの変数に格納して、applicationTableViewの表示を更新
    func requestIndex(){
        //URL、トークン、ヘッダーを用意
        let url = URL(string: consts.baseUrl + "/api/applications")!
        let token = LoadToken().loadAccessToken()  //LoadToken.swiftで定義 トークンがKeychainkら読み込まれる
        /* ヘッダーはこの書き方でもOK  文字列””が多いとミスしやすい。互換が効くほうが良い。
         let headers: HTTPHeaders = [
         "Content-Type": "application/json",
         "Accept": "application/json",
         "Authorization": "Bearer \(token)",
         ]
         */
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json"),
            //その中身がトークンだよ
            .authorization(bearerToken: token)
        ]
        //Alamofireでリクエスト
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: ApplicationIndex.self) { response in
            switch response.result {
            case .success(let applications):
                print("🔥success from Index🔥")
                if let atcls = applications.data {
                    self.applications = atcls
                    self.applicationTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    //自分の情報取得(idとname)
    func getUser() {
        let url = URL(string: consts.baseUrl + "/api/user")!
        let token = LoadToken().loadAccessToken()
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request(
            url,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: User.self){ response in
            switch response.result {
            case .success(let user):
                self.user = user
            case .failure(let err):
                print(err)
            }
        }
    }
}

//tableViewへの表示用
extension ApplicationViewController: UITableViewDataSource {
    //セクションのタイトルlet sectionTitle = ["投稿一覧"] 上で定義。section: Int 1つ目は"投稿一覧"
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    //セクションの数 (= セクションのタイトルの数)
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    //行の数(= 記事の数)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        applications.count
    }
    
    
    //applicationsに合わせて修正
    //セル1つの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath) as! ApplicationTableViewCell
        cell.volunteerLabel.text = applications[indexPath.row].volunteerName
        cell.careerTextView.text = applications[indexPath.row].career
        cell.volunteerImageView.kf.setImage(with: URL(string: applications[indexPath.row].volunteerImageUrl)!)
        return cell
    }
}

//記事がタップされたら propose list詳細画面へ
extension ApplicationViewController: UITableViewDelegate {
    //didSelectRowAt  セルが選択された後に呼ばれる関数
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //押された行の番号から、その記事を取ってくる
        let application = applications[indexPath.row]
        //詳細画面のviewをインスタンス化 instantiateViewController
        let proposeVC = storyboard?.instantiateViewController(withIdentifier: "Propose") as! ProposeViewController
        //getUser()でuserが取れてきてるか確認
//        guard let user = user else { return }
        //①記事固有ID 詳細画面の変数に渡す.DetailViewControllerにも定義。
//        proposeVC.applicationId = application.id
        //②ユーザー情報 詳細画面の変数に渡す.DetailViewControllerにも定義。
//        proposeVC.myUser = user
        //画面の遷移 navigationController?.pushViewController
        navigationController?.pushViewController(proposeVC, animated: true)
    }
}


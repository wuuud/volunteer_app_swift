//
//  DetailViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/14.
//

import UIKit
//9.detail
import Alamofire
import KeychainAccess

class DetailViewController: UIViewController {
    //８.index終盤　詳細画面を表示するために選択された記事の固有のIDが必要なのでdetailVC.volunteerOfferId = volunteerOffer.idとしてIDの値を渡す
    //Indexの画面から受け取る indexControllerの最下部に記載。
    var volunteerOfferId: Int!
    //Indexの画面から受け取る indexControllerの最下部に記載
    var myUser: User!
    //9.detail
    let consts = Constants.shared
    //let messageSectionName = ["メッセージ一覧"] //セクションのタイトル
    private var token = ""
    //var messages: [Message] = []
    
    
    //descriptionも追加
    @IBOutlet weak var npoNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var npoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    //@IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var editAndDeleteButtonState: UIBarButtonItem!
    //編集削除画面へのボタンが押されたときの処理を先に書く
    @IBAction func editOrDeleteButton(_ sender: UIBarButtonItem) {
        guard let volunteerOfferId = volunteerOfferId else { return }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditViewController
        editVC.volunteerOfferId = volunteerOfferId
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    //要確認
    //    確認のためにviewDidLoad内の次の2行をコメントアウトして遷移できるか確認してみましょう!
    
    //    editAndDeleteButtonState.isEnabled = false
    //    editAndDeleteButtonState.tintColor = UIColor.clear
    //
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンを使えなくして、色を透明にする(見えなくする)
        editAndDeleteButtonState.isEnabled = false
        editAndDeleteButtonState.tintColor = UIColor.clear
        token = LoadToken().loadAccessToken() //トークン読み込み　リクエストの関数を適切なところで実行
        //        commentTableView.dataSource = self //取得したコメントをテーブルビューに表示
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        //IDが渡ってきているかをチェックしてから実行
    //        if let id = volunteerOfferId {
    //            //override func viewWillAppear　IDが渡ってきているかをチェックしてから実行
    //            if let id = volunteerOfferId {
    //                getvolunteerOfferWithComments(id: id)
    //            }
    //        }
    //        getvolunteerOfferWithComments(id: id)
    //    }
    
    
    
    //APIへのリクエストとレスポンスをチェック
    //idから記事と一緒にコメントを取得
    func getVolunteerOfferWithComments(id: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers/\(id)") else { return }
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: volunteerOffer.self) { response in
            switch response.result {
            case .success(let volunteerOffer):
                print("🌟success from Detail🌟")
                
                //それぞれのラベルやイメージビューに受け取ったものを入れる
                self.npoNameLabel.text = volunteerOffer.npoName
                self.titleLabel.text = volunteerOffer.title
                self.descriptionTextView.text = volunteerOffer.description
                self.npoImageView.kf.setImage(with: URL(string: volunteerOffer.npoImageUrl)!)
                
                //コメントがあったら定義しておいた変数に入れる
                //guard let comments = volunteerOffer.comments else { return }
                //self.comments = comments
                //self.commentTableView.reloadData()
                
                //投稿者と自分のnameが一致したとき…
                if let user = self.myUser {
                    if user.name == volunteerOffer.npoName {
                        //編集削除のボタンを見えるようにして押せる状態にする
                        self.editAndDeleteButtonState.isEnabled = true
                        self.editAndDeleteButtonState.tintColor = UIColor.systemBlue
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
//取得したコメントをテーブルビューに表示
//extension DetailViewController: UITableViewDataSource {
//    
//    //セクションの数
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return commentSectionName.count
//    }
//    //セクションのタイトル
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return commentSectionName[section]
//    }
//    
//    //セクション内の行(セル)の数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//    //行(セル)の内容
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
//        cell.commentLabel.text = comments[indexPath.row].body
//        cell.commentAuthorLabel.text = comments[indexPath.row].userName
//        return cell
//    }
//}


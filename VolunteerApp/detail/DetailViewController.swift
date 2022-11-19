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
    let messageSectionName = ["ボランティア詳細"] //セクションのタイトル
    private var token = ""
    
    
    @IBOutlet weak var npoNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var npoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editAndDeleteButtonState: UIBarButtonItem!
    //編集削除画面へのボタンが押されたときの処理を先に書く
    @IBAction func editOrDeleteButton(_ sender: UIBarButtonItem) {
        print("aaaR")
        guard let volunteerOfferId = volunteerOfferId else { return }
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "Edit") as! EditViewController
        editVC.volunteerOfferId = volunteerOfferId
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    //要確認
    //    確認のためにviewDidLoad内の次の2行をコメントアウトして遷移できるか確認してみましょう!
    //            editAndDeleteButtonState.isEnabled = false
    //            editAndDeleteButtonState.tintColor = UIColor.clear
    //
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンを使えなくして、色を透明にする(見えなくする)
//        editAndDeleteButtonState.isEnabled = false
//        editAndDeleteButtonState.isHidden = false
//        editAndDeleteButtonState.tintColor = UIColor.clear
        
        token = LoadToken().loadAccessToken() //トークン読み込み　リクエストの関数を適切なところで実行
        
        //        枠線
        let viewCustomize = ViewCustomize()
        titleLabel = viewCustomize.addBoundsLabel(label: titleLabel)
        descriptionLabel = viewCustomize.addBoundsLabel(label: descriptionLabel)
        npoImageView = viewCustomize.addBoundsImageView(imageView: npoImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //IDが渡ってきているかをチェックしてから実行
        if let id = volunteerOfferId {
            getVolunteerOffer(id: id)
        }
    }
    
    //APIへのリクエストとレスポンスをチェック
    //idから記事と一緒にコメントを取得
    func getVolunteerOffer(id: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers/\(id)") else { return }
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: VolunteerOffer.self) { [self] response in
            switch response.result {
            case .success(let volunteerOffer):
                print("🌟success from Detail🌟")
                
                //それぞれのラベルやイメージビューに受け取ったものを入れる
                self.npoNameLabel.text = volunteerOffer.npoName
                self.titleLabel.text = volunteerOffer.title
                self.descriptionLabel.text = volunteerOffer.description
                self.npoImageView.kf.setImage(with: URL(string: volunteerOffer.npoImageUrl)!)
                
                //投稿者と自分のnameが一致したとき
                print(self.myUser.npoName)
                print(volunteerOffer.npoName)
                print(self.myUser.npoName == volunteerOffer.npoName)
                
                self.editAndDeleteButtonState.isEnabled = false
                self.editAndDeleteButtonState.isHidden = true
                
                if let user = self.myUser {
                    if user.npoName == volunteerOffer.npoName {
                        //編集削除のボタンを見えるようにして押せる状態にする
                        self.editAndDeleteButtonState.isEnabled = true   //ボタン有効
                        self.editAndDeleteButtonState.isHidden = false   //ボタン表示
                        self.editAndDeleteButtonState.tintColor = UIColor.systemGreen
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

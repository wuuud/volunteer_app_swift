//
//  ProposeViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

import UIKit
import Alamofire
import Kingfisher
import KeychainAccess

class ProposeViewController: UITableViewController {
       
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    let consts = Constants.shared
    let sectionTitle = ["スカウト済一覧"]
    private var token = ""
    var proposes : [Propose] = []
    var searchedProposes: [Propose] = []
    @IBOutlet weak var proposeTableView: UITableView!
    @IBOutlet weak var proposeSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        proposeTableView.dataSource = self
        proposeTableView.delegate = self
        proposeSearchBar.delegate = self   //search bar
    }
    
        override func viewWillAppear(_ animated: Bool) {
            requestProposeIndex()  //この画面に戻る度に表示できるように。下で定義。
        }
    
    //一覧画面を取得するリクエストをAPIに送信する関数 大体決り文句
    //responseの中に記事のデータがあるかをチェックして、ある場合は定義しておいたapplicationsの変数に格納して、applicationTableViewの表示を更新
    func requestProposeIndex(){
        //URL、トークン、ヘッダーを用意
        let url = URL(string: consts.baseUrl + "/api/proposes")!
        let token = LoadToken().loadAccessToken()  //LoadToken.swiftで定義 トークンがKeychainkら読み込まれる
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json"),
            .authorization(bearerToken: token)
        ]
        //Alamofireでリクエスト
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: ProposeIndex.self) { response in
            switch response.result {
            case .success(let proposes):
                print("🔥success from Index🔥")
                if let props = proposes.data {
                    self.proposes = props
                    self.proposeTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedProposes.isEmpty ? proposes.count : searchedProposes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProposeCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        if searchedProposes.isEmpty {
            content.text = proposes[indexPath.row].volunteerName
        } else {
            content.text = searchedProposes[indexPath.row].volunteerName
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}

//search bar
//extension ProposeViewController: UITableViewDataSource {
//
//}

extension ProposeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            searchedProposes = proposes
            //                proposeTableView.reloadData()
            return
        }
        searchedProposes = proposes.filter({ item -> Bool in
            item.volunteerName.contains(searchBar.text!)
        })
        proposeTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

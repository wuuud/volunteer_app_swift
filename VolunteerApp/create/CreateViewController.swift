//
//  CreateViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/14.
//

import UIKit
//10.create
import Alamofire
import KeychainAccess

class CreateViewController: UIViewController {
    private var token = ""
    var user: User?
    //定数を読み込んできて使うためのインスタンスを入れておく変数
    let consts = Constants.shared
    let okAlert = OkAlert()
    let messageSectionName = ["ボランティア新規作成"]
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        selectionAlert()
    }
    //公開ボタン
    @IBAction func postVolunteerOffer(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextView.text != "" && npoImageView.image != nil && startDateTextField.text != nil {
            createRequest(token: token, image: npoImageView.image!)
        } else {
            okAlert.showOkAlert(title: "未入力欄があります", message: "全ての欄を入力してください", viewController: self)
        }
    }
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var npoImageView: UIImageView!
    //viewDidLoad()に一度だけ実行したい処理を書く
    override func viewDidLoad() {
        super.viewDidLoad()
        //token読み込み
        token = LoadToken().loadAccessToken()
        //TextViewとImageViewに枠線をつける
        let viewCustomize = ViewCustomize()
        descriptionTextView = viewCustomize.addBoundsTextView(textView: descriptionTextView)
        npoImageView = viewCustomize.addBoundsImageView(imageView: npoImageView)
    }
    //カメラがあったら起動
    func checkCamera() {
        let sourceType:UIImagePickerController.SourceType = .camera
        let cameraPicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true,completion: nil)
        }
    }
    //フォトライブラリがあったら起動
    func checkAlbum() {
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        let cameraPicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true,completion: nil)
        }
    }
    //カメラかアルバムか、選択されたほうを表示して画像を選択
    func selectionAlert(){
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.checkCamera()
        }
        let albamAction = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.checkAlbum()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(albamAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true,completion: nil)
    }
    //投稿のリクエスト
    func createRequest(token: String, image: UIImage) {
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers") else { return }
        
        //画像データを圧縮してデータ型に変換
        guard let imageData = image.jpegData(compressionQuality: 0.01) else {return}
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json"),
            .contentType("multipart/form-data")
        ]
        
        //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
        AF.upload(
            //multipartFormDataにappendで送信したいデータを追加していく
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "file.jpg")
                
                guard let titleText = self.titleTextField.text, let titleTextData = titleText.data(using: .utf8) else {return}
                multipartFormData.append(titleTextData, withName: "title")

                guard let descriptionTextView = self.descriptionTextView.text, let descriptionTextData = descriptionTextView.data(using: .utf8) else {return}
                multipartFormData.append(descriptionTextData, withName: "description")

                guard let startDateText = self.startDateTextField.text, let startDateTextData =  startDateText.data(using: .utf8) else {return}
                multipartFormData.append(startDateTextData, withName: "start_date")
                
//
//                let titleText = self.titleTextField.text?.data(using: .utf8)
//                multipartFormData.append(titleText!, withName: "title")
//
//                let descriptionTextData = self.descriptionTextView.text.data(using: .utf8)
//                multipartFormData.append(descriptionTextData!, withName: "description")
//
//                let startDateText = self.startDateTextField.text?.data(using: .utf8)
//                multipartFormData.append(startDateText!, withName: "start_date")
                
                //鳥山さんguard let titleTextData = self.titleTextField.text?.data(using: .utf8) else {return}
                //multipartFormData.append(“\(time).jpg”.data(using: .utf8)!, withName: “title”)
                //multipartFormData.append(“Swiftのplace”.data(using: .utf8)!, withName: “place”)
                //multipartFormData.append(“Swiftのbody”.data(using: .utf8)!, withName: “body”)
                //                                multipartFormData.append(“7”.data(using: .utf8)!, withName: “tag_id”)
                
                //高橋先生 multipartFormData.append(imageData, withName: "image", fileName: "file.jpg")
                //guard let titleText = self.titleTextField.text, let titleTextData = titleText.data(using: .utf8) else {return}
                //multipartFormData.append(titleTextData, withName: "title")
                //guard let descriptionTextView = self.descriptionTextView.text, let descriptionTextData = descriptionTextView.data(using: .utf8) else {return}
                //multipartFormData.append(descriptionTextData, withName: "description")
                //guard let startDateText = self.startDateTextField.text, let startDateTextData =  startDateText.data(using: .utf8) else {return}
                //multipartFormData.append(startDateTextData, withName: "startDate")
                //print("PARAMETERS:", self.titleTextField.text, self.descriptionTextView.text, self.startDateTextField.text)
                
                
            },
            to: url,
            method: .post, //uploadはデフォルトがPOSTメソッドなので省略可能
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                print("🍏success from Create🍏")
                //alert
                self.createAlart(title: "公開完了!", message: "ボランティア情報を公開しました")
            case .failure(let err):
                print(err)
                self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
            }
        }
    }
    //OKが押されたら一覧画面に戻るアラートのメソッド
    func createAlart(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    //テキストビューとテキストフィールド以外がタッチされたときにキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //画像の選択完了後の処理　その画像をimageViewに表示して画像の選択画面を終了させる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            npoImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //画像の選択をキャンセルしたときの処理　元の画面(投稿画面)に戻る
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

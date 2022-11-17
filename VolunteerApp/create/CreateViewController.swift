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
    //定数を読み込んできて使うためのインスタンスを入れておく変数
    let consts = Constants.shared
    let okAlert = OkAlert()
    
    // タップしたときの画像
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
    }
    //公開ボタン
    @IBAction func postVolunteerOffer(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextView.text != "" && imageView.image != nil {
            createRequest(token: token, image: imageView.image!)
        } else {
            okAlert.showOkAlert(title: "未入力欄があります", message: "全ての欄を入力してください", viewController: self)
        }
    }
    //削除ボタン
    //    @IBAction func deleteVolunteerOffer(_ sender: Any) {
    //        if titleTextField.text != "" && descriptionTextView.text != "" && imageView.image != nil {
    //            createRequest(token: token, image: imageView.image!)
    //        } else {
    //            okAlert.showOkAlert(title: "未入力欄があります", message: "全ての欄を入力してください", viewController: self)
    //    }
    
    
    
    
    //要修正
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    //viewDidLoad()に一度だけ実行したい処理を書く
    override func viewDidLoad() {
        super.viewDidLoad()
        //token読み込み
        token = LoadToken().loadAccessToken()
        //TextViewとImageViewに枠線をつける
        let viewCustomize = ViewCustomize()
        descriptionTextView = viewCustomize.addBoundsTextView(textView: descriptionTextView)
        imageView = viewCustomize.addBoundsImageView(imageView: imageView)
        titleTextField = viewCustomize.addBoundsLabel(label: titleTextField)
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
                
                guard let titleTextData = self.titleTextField.text?.data(using: .utf8) else {return}
                multipartFormData.append(titleTextData, withName: "title")
                
                guard let descriptionTextView = self.descriptionTextView.text?.data(using: .utf8) else {return}
                multipartFormData.append(descriptionTextView, withName: "description")
                
            },
            to: url,
            method: .post, //uploadはデフォルトがPOSTメソッドなので省略可能
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                print("🍏success from Create🍏")
                //alert
                self.createAlart(title: "投稿完了!", message: "作成した記事を投稿しました")
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
            imageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //画像の選択をキャンセルしたときの処理　元の画面(投稿画面)に戻る
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

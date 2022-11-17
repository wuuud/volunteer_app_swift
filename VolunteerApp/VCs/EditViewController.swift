//
//  EditViewController.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/14.
//

import UIKit
//10.create & edit
import Alamofire
import KeychainAccess
import Kingfisher



class EditViewController: UIViewController {
    //9.deatil
    //今の記事のIDを渡したい　🖊or🗑のボタンを押したら編集と削除の画面に遷移
    var volunteerOfferId: Int!
    //10.create & edit
    private var token = ""
    let consts = Constants.shared
    let okAlert = OkAlert()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var npoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    //ImageViewがタップされたときの処理
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
    }
    
    //Update(更新)ボタン
    @IBAction func updateButton(_ sender: Any) {
        if titleLabel.text != "" && descriptionTextView.text != "" && npoImageView.image != nil {
            guard let id = volunteerOfferId else { return }
            updateAlert(token: token, image: npoImageView.image!, volunteerOfferId: id)
        } else {
            okAlert.showOkAlert(title: "未入力欄があります", message: "全ての欄を入力してください", viewController: self)
        }
    }
    
    //    //Delete(削除)ボタン
    //    @IBAction func deleteButton(_ sender: Any) {
    //        //下部で定義
    //        guard let volunteerOfferId = volunteerOfferId else { return }
    //        deleteAlert(token: token, volunteerOfferId: volunteerOfferId)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //記事のIDがnilじゃなければ記事を読み込む
        guard let id = volunteerOfferId else { return }
        loadVolunteerOffer(volunteerOfferId: id)
        
        //token読み込み
        token = LoadToken().loadAccessToken()
        //TextViewとImageViewに枠線をつける
        let viewCustomize = ViewCustomize()
        descriptionTextView = viewCustomize.addBoundsTextView(textView: descriptionTextView)
        npoImageView = viewCustomize.addBoundsImageView(imageView: npoImageView)
        
    }
    //createと似てる処理
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
    //編集したい記事の情報をapiでリクエストして読み込む
    func loadVolunteerOffer(volunteerOfferId: Int) {
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers/\(volunteerOfferId)") else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(
            url,
            headers: headers
        ).responseDecodable(of: volunteerOffer.self) { response in
            switch response.result {
            case .success(let volunteerOffer):
                self.titleLabel.text = volunteerOffer.title
                self.descriptionTextView.text = volunteerOffer.description
                self.npoImageView.kf.setImage(with: URL(string: volunteerOffer.npoImageUrl)!)
            case .failure(let error):
                print(error)
            }
        }
    }
    //更新のリクエスト
    func updateRequest(token: String, image: UIImage, volunteerOfferId: Int) {
        
        //URLに記事のIDを含めることを忘れずに!
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers/\(volunteerOfferId)") else { return }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json"),
            .contentType("multipart/form-data")
        ]
        
        //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
        AF.upload(
            multipartFormData: { multipartFormData in
                
                guard let imageData = image.jpegData(compressionQuality: 0.01) else {return}
                multipartFormData.append(imageData, withName: "image", fileName: "file.jpg")
                
                guard let titleLabel = self.titleLabel.text?.data(using: .utf8) else {return}
                multipartFormData.append(titleLabel, withName: "title")
                
                guard let descriptionTextView = self.descriptionTextView.text?.data(using: .utf8) else {return}
                multipartFormData.append(descriptionTextView, withName: "description")
                
                //「PATCH」のHTTPメソッドをmultipartFormDataに追加
                guard let method = "patch".data(using: .utf8) else { return }
                multipartFormData.append(method, withName: "_method")
            },
            to: url,
            method: .post,
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                /*  ここに更新成功のときの処理  下で定義*/
                self.completionAlart(title: "更新完了!", message: "記事を更新しました")
            case .failure(let err):
                print(err)
                self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
            }
        }
    }
    //更新または削除処理完了の際に表示するアラート。OKを押すと、前の画面に戻る
    func completionAlart(title: String, message: String) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    //削除リクエスト(DELETE)
    func deleteRequest(token: String, volunteerOfferId: Int){
        guard let url = URL(string: consts.baseUrl + "/api/volunteer_offers/\(volunteerOfferId)") else { return }
        let headers :HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(
            url,
            method: .delete,
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                self.completionAlart(title: "削除完了", message: "記事を削除しました")
            case .failure(let err):
                print(err)
            }
        }
    }
    //更新する時に確認をするアラート
    func updateAlert(token: String, image: UIImage, volunteerOfferId: Int) {
        let alert = UIAlertController(title: "更新しますか?", message: "この記事を更新してもよろしいですか?", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "更新", style: .destructive) { action in
            self.updateRequest(token: token, image: image, volunteerOfferId: volunteerOfferId)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //削除する時に確認をするアラート
    func deleteAlert(token: String, volunteerOfferId: Int) {
        let alert = UIAlertController(title: "削除しますか?", message: "この記事を削除します", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { action in
            self.deleteRequest(token: token, volunteerOfferId: volunteerOfferId)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    //    キーボードを下げる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleLabel.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}
extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //画像の選択完了後の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as? UIImage != nil{
            let selectedImage = info[.originalImage] as! UIImage
            npoImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //画像の選択をキャンセルしたときの処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

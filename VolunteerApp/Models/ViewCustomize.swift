//
//  ViewCustomize.swift
//  VolunteerApp
//
//  Created by H M on 2022/11/15.
//

import UIKit



//10.create Viewに枠線をつける処理を実装
struct ViewCustomize {
    //ImageViewに枠線をつけたい
    func addBoundsImageView(imageView: UIImageView) -> UIImageView {
        imageView.layer.borderColor =  UIColor.placeholderText.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        return imageView
    }
    // TextViewに枠線をつけたい
    func addBoundsTextView(textView: UITextView) -> UITextView {
        textView.layer.borderColor =  UIColor.placeholderText.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        return textView
    }
    // Labelに枠線をつけたい
        func addBoundsLabel(label: UILabel) -> UILabel {
            label.layer.borderColor =  UIColor.placeholderText.cgColor
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 5.0
            label.layer.masksToBounds = true
            return label
        }
}

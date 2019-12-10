//
//  NextViewController.swift
//  MyPhotoViewer
//
//  Created by Takuma Yabe on 2019/09/05.
//  Copyright © 2019 Takuma Yabe. All rights reserved.
//

import UIKit
import Photos


class NextViewController: UIViewController {
    
    var phasset = PHAsset() // 選択された写真のPHAsset(segueによって渡される)
    
    var nextmanager = PHImageManager() // 画像データを取得するためのプロパティ
    
    @IBOutlet weak var SelectedImage: UIImageView! // 表示するためのUIImageView
    
    @IBOutlet weak var deleteButton: UIBarButtonItem! // デリート用ボタン
    
    @IBOutlet weak var backButton: UIButton! // 戻るボタン
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 選択された画像を表示する
        nextmanager.requestImage(for: phasset, targetSize: CGSize(width: 300, height: 200), contentMode: .aspectFill, options: nil, resultHandler: { result, info -> Void in // ここで画像データの取得
                if let image = result { // 画像データの取得に完了した後に取得した画像データ(result)をimage代入
                    self.SelectedImage.image = image
                }
        })
        
        deleteButton.isEnabled = true // 削除ボタンを有効に
        
    }
    
    
    
    @IBAction func deleteSelectedImage(_ sender: Any) {  // 削除処理
        
        let delTargetAsset = phasset
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(NSArray(array: [delTargetAsset]))
        }, completionHandler: { (success, error) -> Void in
            if success{ // 削除成功
                let okalert = UIAlertController(title: "写真を削除しました。",
                                                message: nil, preferredStyle: .alert) // 削除完了のアラートを作成
                okalert.addAction(UIAlertAction( // okボタンをアラートにつける
                    title: "ok",
                    style: .default,
                    handler: {(action) -> Void in self.afterDelete()}
                    ))
                self.present(okalert, animated: true) // 削除完了のアラートを表示
            }
            else{ // 削除失敗
                print("削除に失敗しました")
            }
        })
    }
    
    func afterDelete(){  // 削除後に呼ばれるメソッド
        
        //無理やり表示画像を変えて消去した風にする
        let rect:CGRect = CGRect(x:0, y:0, width:100, height:100)
        SelectedImage.frame = rect
        let noImage = UIImage(named: "noImage")
        self.SelectedImage.image = noImage
        
        deleteButton.isEnabled = false // 削除ボタンを無効に
        //self.SelectedImage.image = nil // 見せる画像をなくす
        
       //self.dismiss(animated: true, completion: nil) // これだと前の画面に戻るだけなので消去が反映されない
        

    }
    
    
    
    


}

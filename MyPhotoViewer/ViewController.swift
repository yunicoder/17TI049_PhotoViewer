//
//  ViewController.swift
//  MyPhotoViewer
//
//  Created by Takuma Yabe on 2019/09/04.
//  Copyright © 2019 Takuma Yabe. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photos: [PHAsset] = [] // メディア情報の保持(ここには写真データは入っていない)
    
    @IBOutlet weak var cameraIconButton: UIBarButtonItem! // ヘッダーにあるカメラアイコンのボタン
    
    
    var manager = PHImageManager() // 画像データを取得するためのプロパティ

    
    @IBOutlet weak var collectionView: UICollectionView! // ストーリーボード内のコレクションビュー
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraIconButton.image = UIImage(named: "cameraIcon")  // カメラアイコンをセット
        
        collectionView.delegate = self    // サイズやマージンなどレイアウトに関する処理の委譲
        collectionView.dataSource = self  // 要素の数やセル、クラスなどデータの元となる処理の委譲
        
        PHPhotoLibrary.requestAuthorization({status in if status == .authorized{ // ユーザーに対して写真の取得許可をリクエストして許可されているのかチェック
                self.loadPhotos()  // 許可が出たのでメディア情報を取得(selfが必ず必要)
            }
        })
    }
    
    func loadPhotos() { // メディア情報を取得
        let result = PHAsset.fetchAssets(with: .image, options: nil) // メディア情報を取得(ここには写真データは入っていない)
        let indexSet = IndexSet(integersIn: 0 ..< result.count)  // インテックスの最初から最後までをセットに
        photos = result.objects(at: indexSet) // グローバル変数であるphotosに取得したメディア情報を入れる
        DispatchQueue.main.sync(execute: {  // ユーザーインターフェースに即時反映
            collectionView.reloadData() // 再読み込みを行う
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {  // 1つのセクションに含まれているセルの数を返す
        return photos.count  // 画面上に表示するセルの数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // 対象のインデックスに対応するUICollectionViewCellインスタンスを返す

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) // あらかじめストーリーボードで定義されていたUICollectionViewCell(identifier:ImageCell)
        let asset = photos[indexPath.item] // 表示したいインデックスのPHAssetのインスタンス（写真を管理）
        //temp = photos[indexPath.item]
        let w = collectionView.bounds.size.width / 4 // 4等分（正方形なので高さも同じ）
        manager.requestImage(for: asset, targetSize: CGSize(width: w, height: w), contentMode: .aspectFill, options: nil, resultHandler: { result, info -> Void in // ここで画像データの取得
            if let image = result { // 画像データの取得に完了した後に取得した画像データ(result)をいimageに代入
                let imageView = cell.viewWithTag(1) as! UIImageView  // 指定したタグ(今回だと"ImageCell")が設定されたビューのインスタンスを探す
                imageView.image = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 対象のインデックス番号に対応するセルの大きさを返す
        let width = collectionView.bounds.size.width / 4 -  1.5   // 横は4列
        return CGSize(width: width, height: width)         // 縦横情報をまとめる
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { // 横のマージン値を返す
        return 0.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // 縦のマージン値を返す
        return 0.5
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // セグエによる画面遷移が行われる前に呼ばれるメソッド
        if (segue.identifier == "toNext") {
            let nextVC: NextViewController = (segue.destination as? NextViewController)!
            let selectedRow = collectionView.indexPathsForSelectedItems! // 選ばれた
            
            nextVC.phasset = photos[selectedRow[0].row]  // NextViewController のselectedImgに選択された画像を設定する
            //print("***\(nextVC.phasset)***")
        }
    }


}


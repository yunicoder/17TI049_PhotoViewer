//
//  ExtensionViewController.swift
//  MyPhotoViewer
//
//  Created by Takuma Yabe on 2019/09/06.
//  Copyright © 2019 Takuma Yabe. All rights reserved.
//

//import Photos
import PhotosUI

// デリゲート部分を拡張する
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    // 映像をキャプチャする
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        // Dataを取り出す
        guard let photoData = photo.fileDataRepresentation() else {
            return
        }
        // Dataから写真イメージを作る
        if let stillImage = UIImage(data: photoData) {
            // アルバムに追加する
            UIImageWriteToSavedPhotosAlbum(stillImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        }
    }
    
    // アルバム追加にエラーがあったかどうか
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // エラー表示
            let alert = UIAlertController(title: "アルバムへの追加エラー",
                                          message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            //print("アルバムへの追加 OK")
            let okalert = UIAlertController(title: "カメラロールに保存しました。",
                                          message: nil, preferredStyle: .alert)
            okalert.addAction(UIAlertAction(title: "OK", style: .default))
            present(okalert, animated: true)
        }
    }
    
}

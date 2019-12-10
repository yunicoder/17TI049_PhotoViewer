//
//  ARkitViewController.swift
//  MyPhotoViewer
//
//  Created by Takuma Yabe on 2019/09/08.
//  Copyright © 2019 Takuma Yabe. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARkitViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    //@IBOutlet var sceneView: ARSCNView!
    
    var photoOutputObj = AVCapturePhotoOutput() // 出力先の作成

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self // デリゲートになる
        sceneView.scene = SCNScene() // シーンを作る
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause() // セッションを止める
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()// コンフィグを作る
        // Assets.xcassetsの"AR Resources"グループの画像を参照する
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            return
        }
        configuration.detectionImages = referenceImages // 参照画像を設定する
        sceneView.session.run(configuration)// セッションを開始する
    }
    
    // 画像認識
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 画像認識したアンカーを取り出す
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage // 認識した画像の情報
        // 認識画像をハイライトする
        let plane = SCNPlane(width: referenceImage.physicalSize.width,
                             height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2 // 90度回転
        planeNode.opacity = 0.25  // 半透明
        node.addChildNode(planeNode)
        // ネームを表示する
        let name = referenceImage.name!
        let nameNode = TextNode(str:name)
        nameNode.eulerAngles.x = -.pi/2 // 90度回転
        node.addChildNode(nameNode)
    }
    
    
}

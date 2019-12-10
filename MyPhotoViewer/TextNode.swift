//
//  TextNode.swift
//  MyPhotoViewer
//
//  Created by Takuma Yabe on 2019/09/08.
//  Copyright © 2019 Takuma Yabe. All rights reserved.
//

import SceneKit
import ARKit

class TextNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(str:String) {
        super.init()
        // 文字のジオメトリを作る
        let text = SCNText(string: str, extrusionDepth: 0.01)
        text.font = UIFont(name:"Futura-Bold",size:1)
        text.firstMaterial?.diffuse.contents = UIColor.red// 塗り
        // テキストノードを作る
        let textNode = SCNNode(geometry: text)
        self.addChildNode(textNode)// 子ノードとして追加する
        let (max, min) = textNode.boundingBox // ノードを囲む領域
        let w = abs(CGFloat(max.x - min.x))
        let h = abs(CGFloat(max.y - min.y))
        textNode.position = SCNVector3(-w/2, -h*1.2, 0) // 位置決め
        // 全体を縮小する
        self.scale =  SCNVector3(0.04, 0.04, 0.04)
    }
}

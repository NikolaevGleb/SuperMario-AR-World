//
//  ViewController.swift
//  ARSurfacesHomework
//
//  Created by Глеб Николаев on 18.09.2018.
//  Copyright © 2018 Глеб Николаев. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var powLabel: UILabel!
    @IBOutlet weak var questionBoxLabel: UILabel!

    let objects: [String] = ["art.scnassets/mariobox.png",
                             "art.scnassets/Brick_Block.png",
                             "art.scnassets/pow.png"]
    
    var powCount = 0
    var questionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
        
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        //Создаем константу ширины куда присваиваем ширину обнаруженной плоскости
        let width = CGFloat(planeAnchor.extent.x)
        //Создаем константу высоты куда присваиваем высоту обнаруженной плоскости
        let height = CGFloat(planeAnchor.extent.z)
        
        let geometry = SCNPlane(width: width, height: height)
        let node = SCNNode()
        
        //Присваиваем ноде нашу геометрию
        node.geometry = geometry
        node.opacity = 0.25
        node.eulerAngles.x = -Float.pi / 2
        
        return node
    }
    
    func generateObject(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.y)
        
        let geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        guard let customImage = objects.randomElement() else { return SCNNode() }
        
        if customImage == "art.scnassets/pow.png" {
            powCount += 1
            if let powLabelText = powLabel.text {
                powLabel.text = ("\(powLabelText) \(powCount)")
            }
        } else if customImage == "art.scnassets/mariobox.png" {
            questionCount += 1
            if let questionLabelText = questionBoxLabel.text {
                questionBoxLabel.text = ("\(questionLabelText) \(questionCount)")
            }
        }
        
        material.diffuse.contents = UIImage(named: customImage)
        geometry.materials = [material]
        
        let node = SCNNode()
        node.geometry = geometry
        
        return node
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        //let floor = createFloor(planeAnchor: planeAnchor)
        let cover = generateObject(planeAnchor: planeAnchor)
        
        node.addChildNode(cover)
        //node.addChildNode(floor)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor,
        let cover = node.childNodes.first,
        let geometry = cover.geometry as? SCNPlane else { return }

        geometry.width = CGFloat(planeAnchor.extent.x)
        geometry.height = CGFloat(planeAnchor.extent.z)

        cover.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)

    }
    
}

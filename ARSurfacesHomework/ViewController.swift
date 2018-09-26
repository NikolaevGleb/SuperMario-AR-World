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
    
    @IBOutlet weak var firstHeart: UIImageView!
    @IBOutlet weak var secondHeart: UIImageView!
    @IBOutlet weak var thirdHeart: UIImageView!
    
    let objects: [String] = ["art.scnassets/mariobox.png",
                             "art.scnassets/Brick_Block.png",
                             "art.scnassets/pow.png"]
    
    var powCount = 0
    var questionCount = 0
    var lives = 3
    
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
    
    func generateObject(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let objectNode = SCNNode()
        let geometry = SCNBox(width: 0.15, height: 0.15, length: 0.15, chamferRadius: 0)
        let material = SCNMaterial()
        guard let customImage = objects.randomElement() else { return SCNNode() }
        
        switch customImage {
        case "art.scnassets/pow.png":
            powCount += 1
            guard let _ = powLabel.text else { break }
            powLabel.text = ("POW Count:\(powCount)")
        case "art.scnassets/mariobox.png":
            questionCount += 1
            guard let _ = questionBoxLabel.text else { break }
            questionBoxLabel.text = ("'? BOX' Count:\(questionCount)")
        case "art.scnassets/Brick_Block.png":
            if lives >= 3 {
                lives -= 1
                firstHeart.isHidden = true
            } else if lives == 2 {
                lives -= 1
                secondHeart.isHidden = true
            } else if lives == 1 {
                lives -= 1
                thirdHeart.isHidden = true
                gameOver()
            }
        default:
            break
        }
        
        material.diffuse.contents = UIImage(named: customImage)
        geometry.materials = [material]
        objectNode.geometry = geometry
        return objectNode
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let object = generateObject(planeAnchor: planeAnchor)
        node.addChildNode(object)
        pointsChecker()
        
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//
//        guard let planeAnchor = anchor as? ARPlaneAnchor,
//            let cover = node.childNodes.first,
//            let geometry = cover.geometry as? SCNPlane else { return }
//        geometry.width = CGFloat(planeAnchor.extent.x)
//        geometry.height = CGFloat(planeAnchor.extent.z)
//        cover.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//
//    }
    
    func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Continue ?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.reset()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func сongratulations() {
        let alert = UIAlertController(title: "Congratulations!\nYou Win", message: "Play again ?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.reset()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func reset() {
        self.lives = 3
        self.powCount = 0
        self.questionCount = 0
        self.powLabel.text = "POW Count:"
        self.questionBoxLabel.text = "'? BOX Count:'"
        self.firstHeart.isHidden = false
        self.secondHeart.isHidden = false
        self.thirdHeart.isHidden = false
        self.sceneView.scene.rootNode.enumerateHierarchy{ node, _ in
            node.removeFromParentNode()
        }
    }
    
    func pointsChecker() {
        if powCount >= 10 || questionCount >= 3 {
            сongratulations()
        }
    }
    
}

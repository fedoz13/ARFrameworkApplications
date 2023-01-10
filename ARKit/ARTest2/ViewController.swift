//
//  ViewController.swift
//  ARTest2
//
//  Created by Kevin on 01.12.22.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var carScene: SCNScene!
    var scaleFactors = ["Volkswagen" : Float(0.00015), "Toyota" : Float(0.0001), "BMW" : Float(0.00005), "Porsche" : Float(0.000065), "Audi" : Float(0.00015)]
    var brands = [String: Brand]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        loadBrandFile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "brands", bundle: nil) else {
            fatalError("Bilder konnten nicht geladen werden!")
        }

        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        guard let imageName = imageAnchor.referenceImage.name else { return nil}
        guard let brand = brands[imageName] else { return nil}
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        let brandNameNode = textNode(brand.name, font: UIFont.boldSystemFont(ofSize: 8))
        brandNameNode.position.x -= Float(plane.width / 2)
        brandNameNode.position.y += Float(plane.height / 2) + 0.002
        
        brandNameNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        let infoString = "Gründung: " + brand.year + "\n" + "Sitz: " + brand.country + "\n" + "Auto-Modell: " + brand.car
        
        let infoNode = textNode(infoString, font: UIFont.systemFont(ofSize: 4), maxWidth:30)
        infoNode.position.x = plane.boundingBox.max.x + 0.002
        infoNode.position.y = plane.boundingBox.max.y - 0.025
        
        
        planeNode.addChildNode(brandNameNode)
        planeNode.addChildNode(infoNode)
        
        let carNode = showCar(x: planeNode.position.x, y: planeNode.position.y, z: planeNode.position.z, name: brand.name, scale: scaleFactors[brand.name]!)
        node.addChildNode(carNode)
        
        return node
    }
    
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        text.flatness = 0.1
        text.font = font
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(x: 0.0015, y: 0.0015, z: 0.0015)
        
        return textNode
    }
    
    func showCar(x: Float, y: Float, z: Float, name: String, scale: Float) -> SCNNode {
        
        let carNode = SCNNode()
        
        DispatchQueue.main.async {
            self.carScene = SCNScene(named: name+".usdz")
            let carSceneChildNodes = self.carScene.rootNode.childNodes
            
            for childNode in carSceneChildNodes {
                carNode.addChildNode(childNode)
            }
            
            carNode.position = SCNVector3(x, y, z)
            carNode.scale = SCNVector3(scale, scale, scale)

            let animation = CAKeyframeAnimation(keyPath: "eulerAngles")
            animation.values = [NSValue(scnVector3: SCNVector3(0, 0, 0)), NSValue(scnVector3: SCNVector3(0, 360, 0))]
            animation.duration = 720
            animation.repeatCount = .infinity
            carNode.addAnimation(animation, forKey: "eulerAngles")
            carNode.isPaused = false
        }
        
        return carNode
    }
    
    func loadBrandFile() {
        guard let url = Bundle.main.url(forResource: "automarken", withExtension: "json") else {fatalError("json-Datei wurde nicht gefunden")}
        guard let data = try? Data(contentsOf: url) else {fatalError("Automarken konnten nicht geladen werden")}
        
        let decoder = JSONDecoder()
        
        guard let loadedBrands = try? decoder.decode([String: Brand].self, from: data) else {fatalError("Automarken konnten nicht geparst werden")}
        
        brands = loadedBrands
    }
}

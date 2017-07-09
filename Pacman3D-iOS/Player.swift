//
//  Player.swift
//  Pacman3D-iOS
//
//  Created by Tobias on 19.06.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation
import SceneKit

class Player {
    
    var points: Int = 0
    var life: Int = 3
    
    private let level: Level
    
    private let node: SCNNode
    
    var direction: Direction = .north
    var position: SCNVector3
    
    init(node: SCNNode, scene: SCNScene, level: Level) {
        self.node = node
        self.position = node.position
        self.level = level
        
        let pacmanBox = SCNBox(width: 5, height: 2, length: 5, chamferRadius: 0)
        pacmanBox.firstMaterial?.diffuse.contents = UIColor.clear
        let boxNode = SCNNode(geometry: pacmanBox)
        node.addChildNode(boxNode)
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: pacmanBox, options: nil))
        node.physicsBody?.categoryBitMask = GameViewController.pacmanCollision
        node.physicsBody?.contactTestBitMask = GameViewController.wallCollision
        node.physicsBody?.isAffectedByGravity = false
    }
    
    func move() {
        print("\(direction)\t\(findFreeSpaces())")
        if !findFreeSpaces().contains(direction) {
            return
        }
        
        if direction == .north {
            position.x += 5
        } else if direction == .east {
            position.z += 5
        } else if direction == .south {
            position.x -= 5
        } else if direction == .west {
            position.z -= 5
        }
        let action = SCNAction.move(to: position, duration: 0.25)
        node.runAction(action, completionHandler: nil)
    }
    
    private func findFreeSpaces() -> [Direction] {
        var directions: [Direction] = []
        
        let x: Int = Int(position.x / 5)
        let z: Int = Int(position.z / 5)
        
        print("\(x) \(z)")
        
        if level.data[x - 1][z] == .blank {
            directions.append(.south)
        }
        if level.data[x][z - 1] == .blank {
            directions.append(.west)
        }
        if level.data[x + 1][z] == .blank {
            directions.append(.north)
        }
        if level.data[x][z + 1] == .blank {
            directions.append(.east)
        }
        
        return directions
    }
}

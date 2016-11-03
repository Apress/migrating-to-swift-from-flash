//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Hristo Lesev on 5/5/16.
//  Copyright (c) 2016 DiaDraw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playerSprite = SKSpriteNode(imageNamed:"Spaceship")
    
    override func didMoveToView(view: SKView) {
        
        //Scale down the sprite to 30%
        playerSprite.xScale = 0.3
        playerSprite.yScale = 0.3
        
        //Add the playerSprite to the scene
        self.addChild(playerSprite)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //Get the scene coordinates of the touch event
        let location = touches.first!.locationInNode(self)
        
        //To rotate the node to face the moving direction
        //we have to calculate the angle between the sprite and the destination point
        let angle = atan2(location.y - playerSprite.position.y, location.x - playerSprite.position.x ) - 1.56
        
        //Create an action to move the sprite to the touch location coordinates
        let moveAction = SKAction.moveTo(location, duration: 0.5)
        //Create an action to rotate the sprite to face the direction of movement
        let rotateAction = SKAction.rotateToAngle(angle, duration: 0.1)
        
        //Animate the sprite executing actions sequentially
        playerSprite.runAction(SKAction.sequence([rotateAction, moveAction]))
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}

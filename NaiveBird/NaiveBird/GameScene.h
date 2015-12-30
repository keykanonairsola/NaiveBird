//
//  GameScene.h
//  NaiveBird
//

//  Copyright (c) 2015年 nju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

//SKNode and picture of the pipes
@property SKNode* pipes;
@property SKTexture* pipe_up;
@property SKTexture* pipe_down;

//the action pipe move left and remove
@property SKAction* moveAndRemovePipes;

//the sprite of the bird
@property SKSpriteNode* bird;

//the color of the sky
@property SKColor* skyColor;

// the speed of the bird fly
@property double flySpeed;

//whether the game is moving
@property SKNode* moving;

//whether touch to restart
@property BOOL restart;

//to record life
@property long life;

@property SKLabelNode* lifeLabel;


//to show the score
@property SKLabelNode* scoreLabel;

//to record the score
@property long score;

//
@property SKSpriteNode* drugSpriteNode;

@end

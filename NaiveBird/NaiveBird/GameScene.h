//
//  GameScene.h
//  NaiveBird
//

//  Copyright (c) 2015年 nju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property SKTexture* pipe_up;
@property SKTexture* pipe_down;
@property SKAction* movePipes;
@property SKSpriteNode* bird;
@property SKColor* skyColor;

@end

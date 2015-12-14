//
//  GameScene.m
//  NaiveBird
//
//  Created by nju on 15/11/17.
//  Copyright (c) 2015年 nju. All rights reserved.
//

#import "GameScene.h"



@implementation GameScene

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static NSInteger const pipGap = 100;

/*


-(id)initWithSize:(CGSize)size {
 
    
    //game scene
    if(self = [super initWithSize:size]){
        // setup scene here
        
        // sky color
        self.skyColor = [SKColor colorWithRed:113.0/255.0 green:197.0/255.0 blue:207.0/255.0 alpha:1.0];
        [self setBackgroundColor:self.skyColor];
        
        
        //  background
        SKTexture* background = [SKTexture textureWithImageNamed:@"bg_day"];
        background.filteringMode = SKTextureFilteringNearest;
        
        SKAction* moveBgSprite = [SKAction moveByX:-background.size.width*2 y:0 duration:0.02 * background.size.width*2];
        SKAction* resetBgSprite = [SKAction moveByX:background.size.width y:0 duration:0];
        SKAction* moveBgSpritesForever = [SKAction repeatActionForever:@[moveBgSprite, resetBgSprite]];
        
        
        for(int i = 0; i < 2 + self.frame.size.width / ( background.size.width * 2); i ++){
            //create the sprite
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:background];
            [sprite setScale: 2.0];
            sprite.position = CGPointMake(i* sprite.size.width, sprite.size.height);
            [sprite runAction:moveBgSpritesForever];
            [self addChild:sprite];
            
        }
        
        //bird part
        SKTexture* birdTexture0 = [SKTexture textureWithImageNamed: @"bird0_0"];
        birdTexture0.filteringMode = SKTextureFilteringNearest;
        SKTexture* birdTexture1 = [SKTexture textureWithImageNamed: @"bird0_1"];
        birdTexture1.filteringMode = SKTextureFilteringNearest;
        
        SKAction* flap = [SKAction repeatActionForever:[SKAction animateWithNormalTextures:@[birdTexture0, birdTexture1] timePerFrame:0.5]];
        
        //set the bird birdTexture
        self.bird = [SKSpriteNode spriteNodeWithTexture:birdTexture0];
        [self.bird setScale:2.0];
        self.bird.position = CGPointMake(self.frame.size.width / 4, 0);
        [self.bird runAction: flap];
        
        self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.height/2];
        self.bird.physicsBody.dynamic = YES;
        self.bird.physicsBody.allowsRotation = NO;
        
        
        [self addChild:self.bird];
        
        //create ground physics container
        SKNode* dummy = [SKNode node];
        dummy.position = CGPointMake(0,  background.size.height/3);
        dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, background.size.height*2)];
        dummy.physicsBody.dynamic = NO;
        [self addChild:dummy];
        
    }
    
    return self;
}
*/

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //set the gravity
    self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
    
    /* sky color  */
    self.skyColor = [SKColor colorWithRed:113.0/255.0 green:197.0/255.0 blue:207.0/255.0 alpha:1.0];
    [self setBackgroundColor:self.skyColor];
        
    
    /*  ground  */
    SKTexture* ground = [SKTexture textureWithImageNamed:@"ground"];
    ground.filteringMode = SKTextureFilteringNearest;
        
    SKAction* moveGroundSprite = [SKAction moveByX:-ground.size.width*2 y:0 duration:0.02 * ground.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:ground.size.width*2 y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
        
    
    for(int i = 0; i < 2 + self.frame.size.width / ( ground.size.width * 2); i ++){
        //create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:ground];
        [sprite setScale: 2.0];
        sprite.position = CGPointMake(i* sprite.size.width, sprite.size.height/2);
        [sprite runAction:moveGroundSpritesForever];
        [self addChild:sprite];
            
    }
       
    /*bird part*/
    SKTexture* birdTexture0 = [SKTexture textureWithImageNamed:@"bird0"];
    birdTexture0.filteringMode = SKTextureFilteringNearest;
    SKTexture* birdTexture1 = [SKTexture textureWithImageNamed:@"bird1"];
    birdTexture1.filteringMode = SKTextureFilteringNearest;
    SKTexture* birdTexture2 = [SKTexture textureWithImageNamed:@"bird2"];
    birdTexture2.filteringMode = SKTextureFilteringNearest;
    
    SKAction* flap = [SKAction repeatActionForever:[SKAction animateWithTextures:@[birdTexture0, birdTexture1, birdTexture2] timePerFrame:0.2]];
        
    //set the bird birdTexture
    self.bird = [SKSpriteNode spriteNodeWithTexture:birdTexture0];
    [self.bird setScale:2.0];
    self.bird.position = CGPointMake(self.frame.size.width / 2, CGRectGetMidY(self.frame)+10);
    [self.bird runAction: flap];
        
    self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.height/2];
    self.bird.physicsBody.dynamic = YES;
    self.bird.physicsBody.allowsRotation = NO;
        
    [self addChild:self.bird];
        
    //create ground physics container
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0,  ground.size.height);
    dummy.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, ground.size.height*2)];
    dummy.physicsBody.dynamic = NO;
    [self addChild:dummy];
    
    
    //create pipes
    //pipe down
    self.pipe_down = [SKTexture textureWithImageNamed:@"pipe_down"];
    self.pipe_down.filteringMode = SKTextureFilteringNearest;
    //pipe up
    self.pipe_up = [SKTexture textureWithImageNamed: @"pipe_up"];
    self.pipe_up.filteringMode = SKTextureFilteringNearest;;
    
    SKNode* pipePair = [SKNode node];
    pipePair.position = CGPointMake(self.frame.size.width + self.pipe_down.size.width*2, 0);
    pipePair.zPosition = -10;
    
    //get a random float
    CGFloat y = arc4random() %(NSInteger) (self.frame.size.height/3);
    
    SKSpriteNode* sprite_pipe_up = [SKSpriteNode spriteNodeWithTexture: self.pipe_down];
    [sprite_pipe_up setScale: 2];
    sprite_pipe_up.position = CGPointMake(0, y);
    
    
}

//set the bird head toward max and min
CGFloat setBirdHead(CGFloat min, CGFloat max, CGFloat value){
    if(value > max){
        return max;
    }
    else if(value < min){
        return min;
    }
    else{
        return value;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //when touch, bird fly
    self.bird.physicsBody.velocity = CGVectorMake(0, 0);
    [self.bird.physicsBody applyImpulse:CGVectorMake(0.0 , 20.0)];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //set the bird head toward
    self.bird.zRotation = setBirdHead( -1,  0.5, self.bird.physicsBody.velocity.dy *
                                (self.bird.physicsBody.velocity.dy < 0? 0.003:0.001));
}

@end

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

#define PIPEGAP 400

static const uint32_t birdCategory = 1 << 0;
static const uint32_t worldCategory = 1 << 1;
static const uint32_t pipeCategory = 1 << 2;
static const uint32_t scoreCategory = 1 << 3;
static const uint32_t drugCategory = 1 << 4;
static const uint32_t medicineCategory = 1 << 5;
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
    //initial restart
    self.restart = NO;
    
    //initial life
    self.life = 3;
    
    //life texture
    SKTexture* lifeTexture = [SKTexture textureWithImageNamed:@"heart"];
    SKSpriteNode* lifeNodes = [SKSpriteNode spriteNodeWithTexture:lifeTexture];
    [lifeNodes setScale:2.0];
    lifeNodes.position = CGPointMake(lifeNodes.size.width+300, self.frame.size.height - lifeNodes.size.height);
        
    [self addChild:lifeNodes];
    
    self.lifeLabel = [SKLabelNode labelNodeWithFontNamed: @"MarkerFelt-Wide"];
    self.lifeLabel.position = CGPointMake( lifeNodes.position.x + 50, self.frame.size.height - lifeNodes.size.height);
    self.lifeLabel.zPosition = 100;
    self.lifeLabel.text = [NSString stringWithFormat:@"%ld",self.life];
    [self addChild: self.lifeLabel];

    
    
    
    //initial moving
    self.moving = [SKNode node];
    [self addChild: self.moving];
    
    //initial pipes
    self.pipes = [SKNode node];
    [self.moving addChild:self.pipes];
    
    //set the fly speed
    self.flySpeed = 0.008;
    
    //set the gravity
    self.physicsWorld.gravity = CGVectorMake(0.0, -8.0);
    
    self.physicsWorld.contactDelegate = self;
    
    /* sky color  */
    self.skyColor = [SKColor colorWithRed:113.0/255.0 green:197.0/255.0 blue:207.0/255.0 alpha:1.0];
    [self setBackgroundColor:self.skyColor];
        
    
    //score part
    self.score = 0;
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"MarkerFelt-Wide"];
    self.scoreLabel.position = CGPointMake( CGRectGetMidX(self.frame), 3* self.frame.size.height / 4);
    self.scoreLabel.zPosition = 100;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld",self.score];
    [self addChild: self.scoreLabel];
    
    
    
    /*  ground  */
    SKTexture* ground = [SKTexture textureWithImageNamed:@"ground"];
    ground.filteringMode = SKTextureFilteringNearest;
        
    SKAction* moveGroundSprite = [SKAction moveByX:-ground.size.width*2 y:0 duration:self.flySpeed * ground.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:ground.size.width*2 y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
        
    
    for(int i = 0; i < 2 + self.frame.size.width / ( ground.size.width * 2); i ++){
        //create the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:ground];
        [sprite setScale: 2.0];
        sprite.position = CGPointMake(i* sprite.size.width, sprite.size.height/2);
        [sprite runAction:moveGroundSpritesForever];
        [self.moving addChild:sprite];
            
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
    
    //set the bird's physics body
    self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.height/2];
    self.bird.physicsBody.dynamic = YES;
    self.bird.physicsBody.allowsRotation = NO;
    
    self.bird.physicsBody.categoryBitMask = birdCategory;
    self.bird.physicsBody.collisionBitMask = worldCategory | pipeCategory;
    self.bird.physicsBody.contactTestBitMask = worldCategory | pipeCategory;
    
    [self addChild:self.bird];
        
    //create ground physics container
    SKNode* dummy = [SKNode node];
    dummy.position = CGPointMake(0,  ground.size.height);
    dummy.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, ground.size.height+25)];
    dummy.physicsBody.dynamic = NO;
    
    dummy.physicsBody.categoryBitMask = worldCategory;
    
    
    [self addChild:dummy];
    
    
    //create pipes
    SKAction* createPipes = [SKAction performSelector:@selector(createNewPipes) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:2.0];
    SKAction* CreatePipesForever = [SKAction repeatActionForever:[SKAction sequence:@[createPipes,delay]]];
    
    [self runAction:CreatePipesForever];

    
}




//this function is used to create pipe
-(void)createNewPipes{
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
    CGFloat y = arc4random() % (NSInteger) (self.frame.size.height/3);
    
    //pipe up sprite
    SKSpriteNode* sprite_pipe_up = [SKSpriteNode spriteNodeWithTexture: self.pipe_up];
    [sprite_pipe_up setScale: 2.0];
    sprite_pipe_up.position = CGPointMake(0,  y);
    
    //pipe up physics
    sprite_pipe_up.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                                  CGSizeMake(self.pipe_up.size.width,self.pipe_up.size.height+190)];
    sprite_pipe_up.physicsBody.dynamic = NO;
    
    sprite_pipe_up.physicsBody.categoryBitMask = pipeCategory;
    sprite_pipe_up.physicsBody.contactTestBitMask = birdCategory;
    
    [pipePair addChild:sprite_pipe_up];
    
    //pipe action
    SKAction* pipePairMoveLeft = [SKAction repeatActionForever:[SKAction moveByX:-1 y:0 duration: self.flySpeed]];
    SKAction* pipePairMoveLeftAndUp = [SKAction repeatActionForever:[SKAction moveByX:-1 y:0.2 duration: self.flySpeed]];
    SKAction* pipePairMoveLeftAndDown = [SKAction repeatActionForever:[SKAction moveByX:-1 y:-0.2 duration:self.flySpeed]];
    SKAction* pipeMove;
    
    int drugTag = 2;
    switch (arc4random() % 3) {
        case 0:
            pipeMove = pipePairMoveLeft;
            drugTag = 1;
            break;
        case 1:
            pipeMove = pipePairMoveLeftAndUp;
            break;
        case 2:
            pipeMove = pipePairMoveLeftAndDown;
            break;
        default:
            break;
    }

    
    //pipe down sprite
    SKSpriteNode* sprite_pipe_down = [SKSpriteNode spriteNodeWithTexture: self.pipe_down];
    [sprite_pipe_down setScale:2.0];
    if(drugTag == 1){
        sprite_pipe_down.position = CGPointMake(0, y + self.pipe_up.size.height + PIPEGAP);
    }else{
        sprite_pipe_down.position = CGPointMake(0, y + self.pipe_up.size.height + PIPEGAP + 10);
    }
    
    //pipe down physics body
    sprite_pipe_down.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                                    CGSizeMake(self.pipe_down.size.width,self.pipe_down.size.height+190)];
    sprite_pipe_down.physicsBody.dynamic = NO;
    
    sprite_pipe_down.physicsBody.categoryBitMask = pipeCategory;
    sprite_pipe_down.physicsBody.contactTestBitMask = birdCategory;
    
    [pipePair addChild:sprite_pipe_down];
    
    
    SKAction* pipeRemove = [SKAction removeFromParent];
    
    self.moveAndRemovePipes = [SKAction sequence:@[pipeMove,pipeRemove]];

    
    [pipePair runAction:self.moveAndRemovePipes];
    
    
    //add medicine or drug
    if(drugTag == 1){
        switch(arc4random()% 6){
            case 0:
                drugTag = 0;
                break;
            case 1:
            case 2:
                drugTag = 1;
                break;
            default:
                drugTag = 2;
                break;
                
        }
    }
    
    if(drugTag != 2){
        SKTexture* drugTexture = [SKTexture textureWithImageNamed:@"heart"];
        drugTexture.filteringMode = SKTextureFilteringNearest;
  
        self.drugSpriteNode = [SKSpriteNode spriteNodeWithTexture:drugTexture];
        [self.drugSpriteNode setScale:2.0];
    
        //get a random float
        CGFloat drugy = arc4random() % (NSInteger) (self.frame.size.height/2);
        self.drugSpriteNode.position = CGPointMake(-100, 3*self.frame.size.height/4 - drugy);
    
        self.drugSpriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                                  CGSizeMake(drugTexture.size.width,drugTexture.size.height)] ;
    
        
        self.drugSpriteNode.physicsBody.dynamic = NO;
    
        self.drugSpriteNode.physicsBody.contactTestBitMask = birdCategory;
        if(drugTag == 0){
            self.drugSpriteNode.physicsBody.categoryBitMask = drugCategory;
        }
        else{
            self.drugSpriteNode.physicsBody.categoryBitMask = medicineCategory;
        }
        
        
        [pipePair addChild:self.drugSpriteNode];
    }
    
    //contactNode
    SKNode* contactNode = [SKNode node];
    contactNode.position = CGPointMake( sprite_pipe_up.size.width + self.bird.size.width / 2 ,
                                       CGRectGetMidY(self.frame));
    contactNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                               CGSizeMake(sprite_pipe_down.size.width, self.frame.size.height)];
    contactNode.physicsBody.dynamic = NO;
    contactNode.physicsBody.categoryBitMask = scoreCategory;
    contactNode.physicsBody.contactTestBitMask = birdCategory;
    [pipePair addChild:contactNode];
    
    
    
    [self.pipes addChild:pipePair];
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

//when physics body touch
-(void)didBeginContact:(SKPhysicsContact* )contact {
    if((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory ||
       ((contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory)){
        self.score ++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];
    }
    else if((contact.bodyA.categoryBitMask & medicineCategory) == medicineCategory ||
            (contact.bodyB.categoryBitMask & medicineCategory) == medicineCategory){
        [self.drugSpriteNode removeFromParent];
        self.life ++;
        self.lifeLabel.text = [NSString stringWithFormat:@"%ld", self.life];
    }
    else if((contact.bodyA.categoryBitMask & drugCategory) == drugCategory ||
            (contact.bodyB.categoryBitMask & drugCategory) == drugCategory){
        [self.drugSpriteNode removeFromParent];
        self.life = 0;
        self.lifeLabel.text = [NSString stringWithFormat:@"%ld", self.life];
        self.moving.speed = 0;
        self.restart = YES;
    }
    else{
        //self.life --;
        //self.lifeLabel.text = [NSString stringWithFormat:@"%ld", self.life];
       // [self.lifeNodesArr removeObjectAtIndex:self.life];
    
        self.moving.speed = 0;
        self.restart = YES;
        
    }
    
    
}

-(void)resetScene{
    //Move bird to original position
    self.bird.position = CGPointMake(self.frame.size.width/2, CGRectGetMidY(self.frame));
    //reset vector
    self.bird.physicsBody.velocity = CGVectorMake(0, 0 );
    
    //remove all existing pipes
    [self.pipes removeAllChildren];
    
    //reset life
    self.life --;
    if(self.life <= 0){
        self.life = 3;
        //reset score
        self.score = 0;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.score];

    }
    self.lifeLabel.text = [NSString stringWithFormat:@"%ld",self.life];

    //reset the restart flag
        self.restart = NO;
    
        self.moving.speed = 1;
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //when touch, bird fly
    if(self.moving.speed > 0){
        self.bird.physicsBody.velocity = CGVectorMake(0, 0);
        [self.bird.physicsBody applyImpulse:CGVectorMake(0.0 , 150.0)];
    }else if(self.restart){

        [self resetScene];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //set the bird head toward
    self.bird.zRotation = setBirdHead( -1,  0.5, self.bird.physicsBody.velocity.dy *
                                (self.bird.physicsBody.velocity.dy < 0? 0.003:0.001));
}

@end

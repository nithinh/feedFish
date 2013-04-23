//
//  HelloWorldLayer.m
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Fish.h"
#import "Ball.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        _characterObjects = [[NSMutableArray alloc] init];
        _touchObjects = [[NSMutableArray alloc] init];
        Fish * fish;
        Ball * ball;
        ccColor3B colors[] = {
            ccGREEN,
            ccWHITE,
            ccORANGE,
            ccMAGENTA
        };
        
        for (int i =0 ; i< 2; i++) {
            fish = [[Fish alloc] init: ccp(0, winSize.height/4 + (i * 100)) lifeSpan:i + 5.0 color:colors[i] tag:i];
            
            [self addChild:fish];
            
            [_characterObjects addObject:fish];
            
            ball = [[Ball alloc] init:ccp(winSize.width/4 + (i * 100),20) color:colors[i] tag:i];
            [self addChild:ball];
            
            [_touchObjects addObject:ball];
        }
//        NSString *backgroundImg = @"GameBackground.png";
//        
//        CCSprite *background = [CCSprite spriteWithFile:backgroundImg];
//        background.position = ccp(winSize.width/2, winSize.height/2 + 50);
//        [self addChild:background z:-10];

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        UIPanGestureRecognizer * pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:pgr];
        
        [self schedule:@selector(tick:) interval:0.1f];
    }
	return self;
}

- (void) tick : (ccTime) dt {
    CGSize winSize =[CCDirector sharedDirector].winSize;
    for (Fish *fish in _characterObjects) {
        //Check if a ball is in the vicinity
        if(_selectedBall && CGRectContainsPoint(fish.sprite.boundingBox, _selectedBall.sprite.position)) {
           //selected ball is near a fish
            [self handleBall:_selectedBall nearFish:fish];
        }
        
        //If the fish has reached the right most end, reset its position and a trigger a move
        if(fish.sprite.position.x >= winSize.width) {
            [fish reset];
        }
    }
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    for (Ball  *ball in _touchObjects) {
        if (!ball.sprite) {
            continue;
        }
        if (CGRectContainsPoint(ball.sprite.boundingBox, location)) {
            if (_selectedBall) {
                [_selectedBall resetPosition];
            }
            _selectedBall = ball;
        }
    }
    return YES;
}

- (void) handlePan : (UIPanGestureRecognizer *) pgr {
    CGPoint translation = [pgr translationInView:pgr.view];
    // If you have  a touch on the ball, find the translation and move the ball there
    if (pgr.state == UIGestureRecognizerStateChanged) {
        if(_selectedBall) {
            translation = ccp(translation.x, -translation.y);
            _selectedBall.sprite.position = ccpAdd(_selectedBall.sprite.position, translation);
            [pgr setTranslation:CGPointZero inView:pgr.view];
        }
        
    }
    if (pgr.state == UIGestureRecognizerStateEnded) {
        if(_selectedBall) {
            CGPoint velocity = [pgr velocityInView:pgr.view];
            [_selectedBall resetPosition:velocity];
        }
        
        
    }
}

- (void) handleBall : (Ball *) ball nearFish: (Fish*) fish{
    
    if ([ball getTag] == [fish getTag]) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Yummy!!" fontName:@"Marker Felt" fontSize:30];
        label.position = ccpAdd(fish.sprite.position, ccp(10,10));
        [self addChild:label];
        _selectedBall = nil;
        [ball setInvisible];
        [fish stopMove];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7f],
                         [CCCallBlock actionWithBlock:^{
            [fish raceToEnd];
            }],[CCDelayTime actionWithDuration:0.3f],
               [CCCallBlock actionWithBlock:^{
            [_touchObjects removeObject:ball];
            [_characterObjects removeObject:fish];
            [fish reset];
            [_characterObjects addObject:fish];
            [ball reset];
            [_touchObjects addObject:ball];
            [self removeChild:label cleanup:YES];
            
            
        }],nil]];    
    } else {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Yuck!!" fontName:@"Marker Felt" fontSize:30];
        label.position = ccpAdd(fish.sprite.position, ccp(10,10));
        [self addChild:label];
        _selectedBall = nil;
        [ball setInvisible];
        [fish stopMove];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f],
                         [CCCallBlock actionWithBlock:^{
            [_touchObjects removeObject:ball];
            [ball reset];
            [_touchObjects addObject:ball];
            [self removeChild:label cleanup:YES];
            [fish resumeMove];
            
        }],nil]];
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end

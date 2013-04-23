
//
//  Fish.m
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//
//

#import "Fish.h"

@implementation Fish

- (id) init : (CGPoint) position lifeSpan:(float)lifeSpan color: (ccColor3B) color tag:(NSInteger)tag{
    if (self = [super init]) {
        
        _initPosition = position;
        _lifeSpan = lifeSpan;
        _color = color;
        _tag = tag;
        [self commonInit];
    }
    return self;
}
- (void) commonInit {
    _sprite = [CCSprite spriteWithFile:@"Mandarinfish.png"];
    _sprite.position = ccp(_initPosition.x,_initPosition.y);
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCAction * moveAction = [CCMoveTo actionWithDuration:_lifeSpan position:ccp(winSize.width, _initPosition.y)];
    moveAction.tag = 1;
    [_sprite runAction:moveAction];
    [_sprite setColor:_color];
    [self addChild:_sprite z:1 tag:1];
}
- (void) move {
    
}
- (void) reset{
    if([self getChildByTag:1]) {
        [self removeChild:_sprite cleanup:YES];
    }
    [self commonInit];
}
- (void) setInvisible {
    [self removeChild:_sprite cleanup:NO];
}
- (NSInteger) getTag {
    return _tag;
}
- (void) stopMove {
    [_sprite stopActionByTag:1];
}
- (void) resumeMove {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float remLifeSpan = _lifeSpan * ((winSize.width - _sprite.position.x)/(winSize.width));
    CCAction * moveAction = [CCMoveTo actionWithDuration:remLifeSpan position:ccp(winSize.width, _initPosition.y)];
    moveAction.tag = 1;
    [_sprite runAction:moveAction];
}
- (void) raceToEnd {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    float remLifeSpan = 0.02f;
    CCFiniteTimeAction * moveAction = [CCMoveTo actionWithDuration:remLifeSpan position:ccp(winSize.width, _initPosition.y)];
    moveAction.tag = 1;
    [_sprite runAction:[CCSequence actions:[CCCallBlock actionWithBlock:^{
        [_sprite setScale:2];
    }],moveAction, nil]];
}

@end

//
//  Ball.m
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//
//

#import "Ball.h"

@implementation Ball


- (id) init : (CGPoint) position color:(ccColor3B)color tag:(NSInteger)tag{
    if(self = [super init]) {
        _initialPosition = ccp(position.x, position.y);
        _color = color;
        _tag = tag;
        [self commonInit];
    }
    return self;
}
- (void) commonInit {
    _sprite = [CCSprite spriteWithFile:@"indigoball.png"];
    _sprite.position = _initialPosition;
    [_sprite setColor:_color];
    [self addChild:_sprite z:2 tag:2];
}
- (void) resetPosition {
    [_sprite runAction:[CCMoveTo actionWithDuration:1.0 position:_initialPosition]];
}
- (void) resetPosition:(CGPoint)velocity {
    float duration = 4000/ sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
    float flickAngle = atan2f(-velocity.y, velocity.x);
    
    CGPoint distance = ccp(cosf(flickAngle) * 384, sinf(flickAngle) * 384);
    CGPoint finalLocation = ccpAdd(_sprite.position, distance);
    float returnDuration = ccpDistance(finalLocation, _initialPosition) / 300;
    [_sprite runAction:[CCSequence actions:[CCMoveTo actionWithDuration:duration position:finalLocation],
                                            [CCMoveTo actionWithDuration:returnDuration position:_initialPosition], nil]];
}
- (void) reset {
    [self setInvisible];
    [self commonInit];
}
- (void) setInvisible {
    if ([self getChildByTag:2]) {
        [self removeChild:_sprite cleanup:YES];
    }
}
- (NSInteger) getTag {
    return _tag;
}
@end

//
//  Ball.h
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//
//
#import "cocos2d.h"
#import "CCNode.h"

@interface Ball : CCNode {
    CGPoint _initialPosition;
    ccColor3B _color;
    NSInteger _tag;
}
@property (nonatomic,assign) CCSprite * sprite;

- (id) init : (CGPoint) position color: (ccColor3B) color tag: (NSInteger) tag;
- (void) resetPosition;
- (void) resetPosition: (CGPoint) velocity;
- (void) reset;
- (void) setInvisible;
- (NSInteger) getTag ;
@end

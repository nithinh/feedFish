//
//  Fish.h
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Fish : CCNode {
    CGPoint _initPosition;
    float _lifeSpan;
    ccColor3B _color;
    NSInteger _tag;
}
@property (nonatomic,assign) CCSprite * sprite;
- (id) init : (CGPoint) position lifeSpan : (float) lifeSpan color: (ccColor3B) color tag: (NSInteger) tag;
- (void) move;
- (void) setInvisible;
- (void) reset;
- (NSInteger) getTag;
- (void) stopMove;
- (void) resumeMove;
- (void) raceToEnd;

@end

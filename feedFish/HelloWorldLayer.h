//
//  HelloWorldLayer.h
//  feedFish
//
//  Created by Nithin Haridas on 4/19/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Ball.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    BOOL _ballTouched;
    Ball * _selectedBall;
    NSMutableArray * _touchObjects, * _characterObjects ;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end

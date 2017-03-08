//
//  MazeSquare.m
//  OpenGL-Assign2
//
//  Created by Jaegar Sarauer on 2017-03-03.
//  Copyright © 2017 Jaegar Sarauer. All rights reserved.
//
#import "MazeSquare.h"


@implementation MazeSquare

- (id)init:(bool)r left:(bool)l up:(bool)u down:(bool)d
{
    self = [super init];
    self->left = l;
    self->up = u;
    self->right = r;
    self->down = d;
    self->floor = true;
    
    upTex = (TEXTURE_TYPE)NO_SIDES;
    downTex = (TEXTURE_TYPE)NO_SIDES;
    rightTex = (TEXTURE_TYPE)NO_SIDES;
    leftTex = (TEXTURE_TYPE)NO_SIDES;
    
    floorTex = (TEXTURE_TYPE)FLOOR_SIDE;
    
    if (l) {
        upTex++;
        downTex += 2;
    }
    if (r) {
        upTex += 2;
        downTex++;
    }
    if (u) {
        leftTex += 2;
        rightTex ++;
    }
    if (d) {
        leftTex ++;
        rightTex += 2;
    }
    
    
    
    return self;
}

/*- (GLKMatrix4)getVerteciesOfSide:(enum SIDE)side {
    switch(side) {
        case LEFT:
        case RIGHT:
        case UP:
        case DOWN:
            if (down)
                return downVertecies;
            else return ;
    }
}*/

@end

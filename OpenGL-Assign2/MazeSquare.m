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

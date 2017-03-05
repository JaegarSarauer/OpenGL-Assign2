//
//  MazeSquare.h
//  OpenGL-Assign2
//
//  Created by Jaegar Sarauer on 2017-03-03.
//  Copyright © 2017 Jaegar Sarauer. All rights reserved.
//

#ifndef MazeSquare_h
#define MazeSquare_h


#import <GLKit/GLKit.h>

static const int SQUARE_SIDES = 4;
typedef enum {RIGHT = 0, UP, LEFT, DOWN} SIDE;

@interface MazeSquare : NSObject {
@public
    bool right;
    bool up;
    bool left;
    bool down;
    
    GLKMatrix4 upVertecies;
    GLKMatrix3 upNormals;
    
    GLKMatrix4 downVertecies;
    GLKMatrix3 downNormals;
    
    GLKMatrix4 leftVertecies;
    GLKMatrix3 leftNormals;
    
    GLKMatrix4 rightVertecies;
    GLKMatrix3 rightNormals;
}

- (id)init:(bool)r left:(bool)l up:(bool)u down:(bool)d;
//- (GLKMatrix4)getVerteciesOfSide:(enum SIDE)side;

@end


#endif /* MazeSquare_h */

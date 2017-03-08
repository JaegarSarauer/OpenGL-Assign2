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

static const int SQUARE_SIDES = 5;
typedef enum {RIGHT = 0, UP, LEFT, DOWN, FLOOR} SIDE;

typedef enum {FLOOR_SIDE = 0, NO_SIDES, LEFT_SIDE, RIGHT_SIDE, BOTH_SIDES} TEXTURE_TYPE;

@interface MazeSquare : NSObject {
@public
    bool right;
    bool up;
    bool left;
    bool down;
    bool floor;
    
    GLKMatrix4 upVertecies;
    GLKMatrix3 upNormals;
    TEXTURE_TYPE upTex;
    
    GLKMatrix4 downVertecies;
    GLKMatrix3 downNormals;
    TEXTURE_TYPE downTex;
    
    GLKMatrix4 leftVertecies;
    GLKMatrix3 leftNormals;
    TEXTURE_TYPE leftTex;
    
    GLKMatrix4 rightVertecies;
    GLKMatrix3 rightNormals;
    TEXTURE_TYPE rightTex;
    
    GLKMatrix4 floorVertecies;
    GLKMatrix3 floorNormals;
    TEXTURE_TYPE floorTex;
    
    GLKMatrix4 upMinimapVerticies;
    GLKMatrix3 upMinimapNormals;
    
    GLKMatrix4 downMinimapVerticies;
    GLKMatrix3 downMinimapNormals;
    
    GLKMatrix4 leftMinimapVerticies;
    GLKMatrix3 leftMinimapNormals;
    
    GLKMatrix4 rightMinimapVerticies;
    GLKMatrix3 rightMinimapNormals;
}

- (id)init:(bool)r left:(bool)l up:(bool)u down:(bool)d;
//- (GLKMatrix4)getVerteciesOfSide:(enum SIDE)side;

@end


#endif /* MazeSquare_h */

//
//  MazeManager.h
//  OpenGL-Assign2
//
//  Created by Jaegar Sarauer on 2017-03-02.
//  Copyright © 2017 Jaegar Sarauer. All rights reserved.
//

#ifndef MazeManager_h
#define MazeManager_h

#include "MazeSquare.h"

struct MazeStruct;

@interface MazeManager : NSObject {
@private
    struct Maze *maze;
    
@public
    int mazeWidth;
    int mazeHeight;
}

- (MazeSquare *)getMazePosition:(int)x y:(int)y;
- (void)createMaze;

@end

#endif /* MazeManager_h */

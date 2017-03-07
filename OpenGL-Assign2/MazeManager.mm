//
//  MazeManager.m
//  OpenGL-Assign2
//
//  Created by Jaegar Sarauer on 2017-03-02.
//  Copyright © 2017 Jaegar Sarauer. All rights reserved.
//

#import "MazeManager.h"
#include "maze.h"

struct MazeStruct {
    Maze maze;
};

@implementation MazeManager

- (id)init
{
    mazeWidth = 9;
    mazeHeight = 9;
    self = [super init];
    maze = new Maze(mazeWidth, mazeHeight);
    return self;
}

- (MazeSquare *)getMazePosition:(int)x y:(int)y {
    MazeCell sq = maze->GetCell(y, x);
    return [[MazeSquare alloc]init:sq.eastWallPresent left:sq.westWallPresent up:sq.northWallPresent down:sq.southWallPresent];
}

-(void)createMaze {
    maze->Create();
}

/*- (MazeSquare *)getStartPosition {
    //MazeCell sq = maze->mazeSet[0];
}*/

@end

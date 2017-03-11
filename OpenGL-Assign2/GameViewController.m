//
//  GameViewController.m
//  OpenGL-Assign2
//
//  Created by Jaegar Sarauer on 2017-03-02.
//  Copyright © 2017 Jaegar Sarauer. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_MODELVIEW_MATRIX,
    /* more uniforms needed here... */
    UNIFORM_TEXTURE,
    UNIFORM_FLASHLIGHT_POSITION,
    UNIFORM_FLASHLIGHT_DIRECTION,
    UNIFORM_CUTOFF,
    UNIFORM_FOG,
    UNIFORM_DIFFUSE_LIGHT_POSITION,
    UNIFORM_SHININESS,
    UNIFORM_AMBIENT_COMPONENT,
    UNIFORM_DIFFUSE_COMPONENT,
    UNIFORM_SPECULAR_COMPONENT,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[72] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    -0.5f, -0.5f, -0.5f,
    -0.5f, -0.5f,  0.5f,
    0.5f, -0.5f,  0.5f,
    0.5f, -0.5f, -0.5f,
    -0.5f,  0.5f, -0.5f,
    -0.5f,  0.5f,  0.5f,
    0.5f,  0.5f,  0.5f,
    0.5f,  0.5f, -0.5f,
    -0.5f, -0.5f, -0.5f,
    -0.5f,  0.5f, -0.5f,
    0.5f,  0.5f, -0.5f,
    0.5f, -0.5f, -0.5f,
    -0.5f, -0.5f, 0.5f,
    -0.5f,  0.5f, 0.5f,
    0.5f,  0.5f, 0.5f,
    0.5f, -0.5f, 0.5f,
    -0.5f, -0.5f, -0.5f,
    -0.5f, -0.5f,  0.5f,
    -0.5f,  0.5f,  0.5f,
    -0.5f,  0.5f, -0.5f,
    0.5f, -0.5f, -0.5f,
    0.5f, -0.5f,  0.5f,
    0.5f,  0.5f,  0.5f,
    0.5f,  0.5f, -0.5f,
};
GLfloat gWallVertexData[72] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.40f, -0.5f, -0.5f,
    0.40f, -0.5f,  0.5f,
    0.5f, -0.5f,  0.5f,
    0.5f, -0.5f, -0.5f,
    0.40f,  0.5f, -0.5f,
    0.40f,  0.5f,  0.5f,
    0.5f,  0.5f,  0.5f,
    0.5f,  0.5f, -0.5f,
    0.40f, -0.5f, -0.5f,
    0.40f,  0.5f, -0.5f,
    0.5f,  0.5f, -0.5f,
    0.5f, -0.5f, -0.5f,
    0.40f, -0.5f, 0.5f,
    0.40f,  0.5f, 0.5f,
    0.5f,  0.5f, 0.5f,
    0.5f, -0.5f, 0.5f,
    0.40f, -0.5f, -0.5f,
    0.40f, -0.5f,  0.5f,
    0.40f,  0.5f,  0.5f,
    0.40f,  0.5f, -0.5f,
    0.5f, -0.5f, -0.5f,
    0.5f, -0.5f,  0.5f,
    0.5f,  0.5f,  0.5f,
    0.5f,  0.5f, -0.5f,
};

GLfloat gCubeNormalData[72] = {
    0.0f, -1.0f, 0.0f,
    0.0f, -1.0f, 0.0f,
    0.0f, -1.0f, 0.0f,
    0.0f, -1.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, 0.0f, -1.0f,
    0.0f, 0.0f, -1.0f,
    0.0f, 0.0f, -1.0f,
    0.0f, 0.0f, -1.0f,
    0.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 1.0f,
    0.0f, 0.0f, 1.0f,
    -1.0f, 0.0f, 0.0f,
    -1.0f, 0.0f, 0.0f,
    -1.0f, 0.0f, 0.0f,
    -1.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
};

GLfloat gCubeTexData[48] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
    1.0f, 0.0f,
    1.0f, 1.0f,
    0.0f, 1.0f,
    0.0f, 0.0f,
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 0.0f,
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};

GLuint cubeIndices[36] =
{
    0, 2, 1,
    0, 3, 2,
    4, 5, 6,
    4, 6, 7,
    8, 9, 10,
    8, 10, 11,
    12, 15, 14,
    12, 14, 13,
    16, 17, 18,
    16, 18, 19,
    20, 23, 22,
    20, 22, 21
};

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    NSMutableArray *squares;
    
    float _rotation;
    
    //render data
    GLuint _vertexArray;
    GLuint _vertexBoxArray;
    GLuint _vertexBuffer;
    GLuint _vertexBoxBuffer;
    GLuint _normalBuffer;
    GLuint _textureBuffer;
    GLuint _indexBuffer;
    
    GLuint floorTexture;
    GLuint bothSideTexture;
    GLuint leftSideTexture;
    GLuint rightSideTexture;
    GLuint crateTexture;
    
    //shader data
    GLKVector3 flashlightPosition;
    GLKVector3 flashlightDirection;
    float cutOff;
    bool fog;
    GLKVector3 diffuseLightPosition;
    GLKVector4 diffuseComponent;
    float shininess;
    GLKVector4 specularComponent;
    GLKVector4 ambientComponent;
    
    GLKMatrix4 rotatingCubeVertecies;
    GLKMatrix3 rotatingCubeNormals;
    GLfloat cubeRotation;
    
    BOOL isDay;
    BOOL isFlashlight;
    
    MazeManager *maze;
    
    int mazeXPos;
    int mazeYPos;
    float mazeViewRotate;
    float mazeViewRotateTo;
    
    bool showConsole;
    __weak IBOutlet UIView *ConsoleElement;
    __weak IBOutlet UILabel *PlayerDataLabel;
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (GLuint *)getCorrectTexture:(TEXTURE_TYPE)tex;
- (void) drawShape:(GLuint)tex array:(GLuint)vArray vertecies:(GLKMatrix4)vert normals:(GLKMatrix3)norm;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    mazeXPos = 0;
    mazeYPos = 2;
    mazeViewRotate = 180;
    mazeViewRotateTo = 180;
    
    maze = [[MazeManager alloc]init];
    [maze createMaze];
    
    squares = [NSMutableArray arrayWithCapacity:maze->mazeWidth * maze->mazeHeight];
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            [squares addObject:[maze getMazePosition:x y:y]];
        }
    }
    
    isDay = true;
    isFlashlight = false;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(_program, "texture");
    uniforms[UNIFORM_FLASHLIGHT_POSITION] = glGetUniformLocation(_program, "flashlightPosition");
    uniforms[UNIFORM_FLASHLIGHT_DIRECTION] = glGetUniformLocation(_program, "flashlightDirection");
    uniforms[UNIFORM_CUTOFF] = glGetUniformLocation(_program, "cutOff");
    uniforms[UNIFORM_FOG] = glGetUniformLocation(_program, "fog");
    uniforms[UNIFORM_DIFFUSE_LIGHT_POSITION] = glGetUniformLocation(_program, "diffuseLightPosition");
    uniforms[UNIFORM_SHININESS] = glGetUniformLocation(_program, "shininess");
    uniforms[UNIFORM_AMBIENT_COMPONENT] = glGetUniformLocation(_program, "ambientComponent");
    uniforms[UNIFORM_DIFFUSE_COMPONENT] = glGetUniformLocation(_program, "diffuseComponent");
    uniforms[UNIFORM_SPECULAR_COMPONENT] = glGetUniformLocation(_program, "specularComponent");
    
    flashlightPosition = GLKVector3Make([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, 0.0);
    flashlightDirection = GLKVector3Make(0.0, 1.0, 0.0);
    cutOff = 300.0;
    fog = true;
    diffuseLightPosition = GLKVector3Make(0.0, 1.0, 0.0);
    diffuseComponent = GLKVector4Make(.3, .2, .2, 1.0);
    shininess = 100.0;
    specularComponent = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    ambientComponent = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_normalBuffer);
    glGenBuffers(1, &_textureBuffer);
    glGenBuffers(1, &_indexBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 72, gWallVertexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 72, gCubeNormalData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, _textureBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 48, gCubeTexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int) * 36, cubeIndices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    
    
    glGenVertexArraysOES(1, &_vertexBoxArray);
    glBindVertexArrayOES(_vertexBoxArray);
    
    glGenBuffers(1, &_vertexBoxBuffer);
    glGenBuffers(1, &_normalBuffer);
    glGenBuffers(1, &_textureBuffer);
    glGenBuffers(1, &_indexBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBoxBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 72, gCubeVertexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 72, gCubeNormalData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, _textureBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 48, gCubeTexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int) * 36, cubeIndices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
    
    // Load in and set texture
    /* use setupTexture to create crate texture */
    bothSideTexture = [self setupTexture:@"textures/both_sides.png"];
    floorTexture = [self setupTexture:@"textures/floor.png"];
    leftSideTexture = [self setupTexture:@"textures/side_left.png"];
    rightSideTexture = [self setupTexture:@"textures/side_right.png"];
    crateTexture = [self setupTexture:@"textures/crate.jpg"];
    glActiveTexture(GL_TEXTURE0);
    //glBindTexture(GL_TEXTURE_2D, crateTexture);
    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);

    
    //GOODBYE THERE
    
    
    
    
    
    
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_vertexBoxBuffer);
    glDeleteBuffers(1, &_normalBuffer);
    glDeleteBuffers(1, &_textureBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    glDeleteVertexArraysOES(1, &_vertexBoxArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    //used in real world viewing
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(70), aspect, 0.001f, 100.0f);
    
    //used in minimap viewing
    GLKMatrix4 orthoMatrix = GLKMatrix4MakeOrtho(-maze->mazeWidth * aspect, maze->mazeWidth * aspect, -maze->mazeHeight, maze->mazeHeight, 0.001f, 100.0f);
    

    self.effect.transform.projectionMatrix = projectionMatrix;
    
    //GLKMatrix4 boxStart = GLKMatrix4MakeTranslation(mazeXPos, 0.0f, mazeYPos - 1);
    //boxStart = GLKMatrix4Scale(boxStart, 2.0f, 2.0f, 4.0f);
    
    GLKMatrix4 boxMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    boxMatrix = GLKMatrix4Rotate(boxMatrix, GLKMathDegreesToRadians(mazeViewRotate), 0.0f, 1.0f, 0.0f);
    boxMatrix = GLKMatrix4Translate(boxMatrix, (mazeXPos), 0.0f, (mazeYPos - 1));
    boxMatrix = GLKMatrix4Rotate(boxMatrix, GLKMathDegreesToRadians(cubeRotation), 1.0f, 1.0f, 1.0f);
    boxMatrix = GLKMatrix4Scale(boxMatrix, .2f, .2f, .2f);
    
    //boxMatrix = GLKMatrix4Multiply(boxStart, boxMatrix);
    
    rotatingCubeVertecies = GLKMatrix4Multiply(projectionMatrix, boxMatrix);
    rotatingCubeNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(boxMatrix), NULL);
    
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            for (int s = 0; s < SQUARE_SIDES; s++) {
                //for (int = 0; i < MazeSquare.SIDE)
                //real position
                GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation( mazeXPos + x, 0.0f, mazeYPos + y);
                GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(-(mazeXPos + x), 0.0f, -(mazeYPos + y));
                modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, baseModelViewMatrix);
                
                GLKMatrix4 rotateMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(mazeViewRotate), 0.0f, 1.0f, 0.0f);
                GLKMatrix4 finalMatrix =GLKMatrix4Multiply(rotateMatrix, baseModelViewMatrix);
                if (s == SQUARE_SIDES - 1) {//floor
                    finalMatrix = GLKMatrix4Rotate(finalMatrix, GLKMathDegreesToRadians(270), 0.0f, 0.0f, 1.0f);
                    finalMatrix = GLKMatrix4Rotate(finalMatrix, GLKMathDegreesToRadians(90), 1.0f, 0.0f, 0.0f);
                } else
                    finalMatrix = GLKMatrix4Rotate(finalMatrix, GLKMathDegreesToRadians(s * 90), 0.0f, 1.0f, 0.0f);
                
                //minimap
                GLKMatrix4 minimapFinal = GLKMatrix4Identity;
                if (!ConsoleElement.hidden) {
                    GLKMatrix4 baseMinimapViewMatrix = GLKMatrix4MakeTranslation(-ceil(maze->mazeWidth / 2) + x, -10.0f, -ceil(maze->mazeHeight / 2) + y);
                    GLKMatrix4 minimapViewMatrix = GLKMatrix4MakeTranslation(-(-ceil(maze->mazeWidth / 2) + x), 10.0f, -(-ceil(maze->mazeHeight / 2) + y));
                    minimapViewMatrix = GLKMatrix4Multiply(minimapViewMatrix, baseMinimapViewMatrix);
                    
                    GLKMatrix4 minimapRotate = GLKMatrix4Rotate(minimapViewMatrix, GLKMathDegreesToRadians(0), 0.0f, 1.0f, 0.0f);
                    minimapRotate = GLKMatrix4Rotate(minimapRotate, GLKMathDegreesToRadians(90), 1.0f, 0.0f, 0.0f);//debug
                    minimapFinal = GLKMatrix4Multiply(minimapRotate, baseMinimapViewMatrix);
                    minimapFinal = GLKMatrix4Rotate(minimapFinal, GLKMathDegreesToRadians(s * 90), 0.0f, 1.0f, 0.0f);
                }

                
                MazeSquare *a = [squares objectAtIndex:(x * maze->mazeHeight) + y];
                switch((SIDE)s) {
                    case (SIDE)LEFT:
                        if (a->left) {
                            a->leftNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->leftVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                            if (!ConsoleElement.hidden) {
                                a->leftMinimapNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(minimapFinal), NULL);
                                a->leftMinimapVerticies = GLKMatrix4Multiply(orthoMatrix, minimapFinal);
                            }
                        }
                        break;
                    case (SIDE)UP:
                        if (a->up) {
                            a->upNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->upVertecies = GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                            if (!ConsoleElement.hidden) {
                                a->upMinimapNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(minimapFinal), NULL);
                                a->upMinimapVerticies = GLKMatrix4Multiply(orthoMatrix, minimapFinal);
                            }
                        }
                        break;
                    case (SIDE)RIGHT:
                        if (a->right) {
                            a->rightNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->rightVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                            if (!ConsoleElement.hidden) {
                                a->rightMinimapNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(minimapFinal), NULL);
                                a->rightMinimapVerticies = GLKMatrix4Multiply(orthoMatrix, minimapFinal);
                            }
                        }
                        break;
                    case (SIDE)DOWN:
                        if (a->down) {
                            a->downNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->downVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                            if (!ConsoleElement.hidden) {
                                a->downMinimapNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(minimapFinal), NULL);
                                a->downMinimapVerticies = GLKMatrix4Multiply(orthoMatrix, minimapFinal);
                            }
                        }
                        break;
                    case (SIDE)FLOOR:
                        if (a->floor) {
                            a->floorNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->floorVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                        }
                        break;
                }
            }
        }
    }
    
    if (mazeViewRotate < mazeViewRotateTo) {
        mazeViewRotate += 15;
    } else if (mazeViewRotate > mazeViewRotateTo) {
        mazeViewRotate -= 15;
    }
    
    cubeRotation += 5;
    
    PlayerDataLabel.text = [NSString stringWithFormat: @"Player Position: x: %d  y: %d \nPlayer Rotation: %f", mazeXPos, mazeYPos, mazeViewRotate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    // Render the object with GLKit
    //[self.effect prepareToDraw];
    
    //glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    //draw the rotating cube
    [self drawShape:crateTexture array:_vertexBoxArray vertecies:rotatingCubeVertecies normals:rotatingCubeNormals];
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            for (int s = 0; s < SQUARE_SIDES; s++) {
                MazeSquare *a = [squares objectAtIndex:(x * maze->mazeHeight) + y];
                //NSLog(@"X: %d Y: %d Right: %d Up: %d Left: %d Down: %d ", x, y, a->right, a->up, a->left, a->down);
                switch((SIDE)s) {
                    case (SIDE)LEFT:
                        if (a->left) {
                            [self drawShape:*[self getCorrectTexture:a->leftTex] array:_vertexArray vertecies:a->leftVertecies normals:a->leftNormals];
                            if (!ConsoleElement.hidden) {
                                [self drawShape:*[self getCorrectTexture:a->upTex] array:_vertexArray vertecies:a->leftMinimapVerticies normals:a->leftMinimapNormals];
                            }
                        }
                        break;
                    case (SIDE)UP:
                        if (a->up) {
                            [self drawShape:*[self getCorrectTexture:a->upTex] array:_vertexArray vertecies:a->upVertecies normals:a->upNormals];
                            if (!ConsoleElement.hidden) {
                                [self drawShape:*[self getCorrectTexture:a->upTex] array:_vertexArray vertecies:a->upMinimapVerticies normals:a->upMinimapNormals];
                            }
                        }
                        break;
                    case (SIDE)RIGHT:
                        if (a->right) {
                            [self drawShape:*[self getCorrectTexture:a->rightTex] array:_vertexArray vertecies:a->rightVertecies normals:a->rightNormals];
                            if (!ConsoleElement.hidden) {
                                [self drawShape:*[self getCorrectTexture:a->upTex] array:_vertexArray vertecies:a->rightMinimapVerticies normals:a->rightMinimapNormals];
                            }
                        }
                        break;
                    case (SIDE)DOWN:
                        if (a->down) {
                            [self drawShape:*[self getCorrectTexture:a->downTex] array:_vertexArray vertecies:a->downVertecies normals:a->downNormals];
                            if (!ConsoleElement.hidden) {
                                [self drawShape:*[self getCorrectTexture:a->upTex] array:_vertexArray vertecies:a->downMinimapVerticies normals:a->downMinimapNormals];
                            }
                        }
                        break;
                    case (SIDE)FLOOR:
                        if (a->floor) {
                            [self drawShape:floorTexture array:_vertexArray vertecies:a->floorVertecies normals:a->floorNormals];
                        }
                        break;
                }
                
            }
        }
    }
    
}

- (void) drawShape:(GLuint)tex array:(GLuint)vArray vertecies:(GLKMatrix4)vert normals:(GLKMatrix3)norm {
    glBindVertexArrayOES(vArray);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, vert.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, norm.m);
    glBindTexture(GL_TEXTURE_2D, tex);
    glUniform3fv(uniforms[UNIFORM_FLASHLIGHT_POSITION], 1, flashlightPosition.v);
    glUniform3fv(uniforms[UNIFORM_FLASHLIGHT_DIRECTION], 1, flashlightDirection.v);
    glUniform1f(uniforms[UNIFORM_CUTOFF], cutOff);
    glUniform1f(uniforms[UNIFORM_FOG], fog);
    glUniform3fv(uniforms[UNIFORM_DIFFUSE_LIGHT_POSITION], 1, diffuseLightPosition.v);
    glUniform4fv(uniforms[UNIFORM_DIFFUSE_COMPONENT], 1, diffuseComponent.v);
    glUniform1f(uniforms[UNIFORM_SHININESS], shininess);
    glUniform4fv(uniforms[UNIFORM_SPECULAR_COMPONENT], 1, specularComponent.v);
    glUniform4fv(uniforms[UNIFORM_AMBIENT_COMPONENT], 1, ambientComponent.v);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
}

- (GLuint *)getCorrectTexture:(TEXTURE_TYPE)tex {
    switch (tex) {
        case FLOOR_SIDE:
        case NO_SIDES:
            return &(floorTexture);
        case LEFT_SIDE:
            return &leftSideTexture;
        case RIGHT_SIDE:
            return &rightSideTexture;
        case BOTH_SIDES:
            return &bothSideTexture;
            
    }
}


#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoordIn");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
- (IBAction)OnTap:(UITapGestureRecognizer *)sender {
    ConsoleElement.hidden = !ConsoleElement.hidden;
        
}
- (IBAction)SwipeRight:(UISwipeGestureRecognizer *)sender {
    mazeViewRotateTo += 90;
}
- (IBAction)SwipeLeft:(UISwipeGestureRecognizer *)sender {
    mazeViewRotateTo -= 90;
}
- (IBAction)SwipeUp:(UISwipeGestureRecognizer *)sender {
    switch((int)mazeViewRotate % 360) {
        case 0:
            mazeYPos += 1;
            break;
        case 90:
        case -270:
            mazeXPos -= 1;
            break;
        case 180:
        case -180:
            mazeYPos -= 1;
            break;
        case 270:
        case -90:
            mazeXPos += 1;
            break;
    }
}
- (IBAction)SwipeDown:(UISwipeGestureRecognizer *)sender {
    switch((int)mazeViewRotate % 360) {
        case 0:
            mazeYPos -= 1;
            break;
        case 90:
        case -270:
            mazeXPos += 1;
            break;
        case 180:
        case -180:
            mazeYPos += 1;
            break;
        case 270:
        case -90:
            mazeXPos -= 1;
            break;
    }
}
- (IBAction)DoubleTap:(UITapGestureRecognizer *)sender {
    mazeXPos = 0;
    mazeYPos = 2;
    mazeViewRotate = 180;
    mazeViewRotateTo = 180;
}
- (IBAction)DayNightSwitch:(UISwitch *)sender {
    isDay = sender.isOn;
    if (isDay) {
        diffuseComponent = GLKVector4Make(.3, .2, .2, 1.0);
        ambientComponent = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    } else {
        diffuseComponent = GLKVector4Make(0.8, 0.8, 0.8, 1.0);
        ambientComponent = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    }
}
- (IBAction)FlashlightSwitch:(UISwitch *)sender {
    isFlashlight = sender.isOn;
    if (isFlashlight) {
        cutOff = 300.0;
    } else {
        cutOff = 0.0;
    }
}
- (IBAction)FogSwitch:(UISwitch *)sender {
    fog = sender.isOn;
}




// Load in and set up texture image (adapted from Ray Wenderlich)
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

@end

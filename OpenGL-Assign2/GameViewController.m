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

GLfloat gCubeVertexData[216] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.49f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    0.49f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    0.49f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    0.49f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    0.49f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    0.49f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    0.49f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.49f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.49f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    0.49f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.49f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.49f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    0.49f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.49f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.49f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    NSMutableArray *squares;
    
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    MazeManager *maze;
    
    int mazeXPos;
    int mazeYPos;
    float mazeViewRotate;
    
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
    
    
    maze = [[MazeManager alloc]init];
    [maze createMaze];
    
    squares = [NSMutableArray arrayWithCapacity:maze->mazeWidth * maze->mazeHeight];
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            [squares addObject:[maze getMazePosition:x y:y]];
        }
    }
    
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
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
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
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(120), aspect, 0.001f, 100.0f);
    

    self.effect.transform.projectionMatrix = projectionMatrix;
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            for (int s = 0; s < SQUARE_SIDES; s++) {
                //for (int = 0; i < MazeSquare.SIDE)
                //real position
                GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(mazeXPos + x, -6.0f, mazeYPos + y);

                GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(-(mazeXPos + x), 6.0f, -(mazeYPos + y));
                modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, baseModelViewMatrix);
                GLKMatrix4 rotateMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(mazeViewRotate), 0.0f, 1.0f, 0.0f);
                rotateMatrix = GLKMatrix4Rotate(rotateMatrix, GLKMathDegreesToRadians(90), 1.0f, 0.0f, 0.0f);//debug

                GLKMatrix4 finalMatrix =GLKMatrix4Multiply(rotateMatrix, baseModelViewMatrix);
                finalMatrix = GLKMatrix4Rotate(finalMatrix, GLKMathDegreesToRadians(s * 90), 0.0f, 1.0f, 0.0f);
                
                MazeSquare *a = [squares objectAtIndex:(x * maze->mazeHeight) + y];
                switch((SIDE)s) {
                    case (SIDE)LEFT:
                        if (a->left) {
                            a->leftNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->leftVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                        }
                        break;
                    case (SIDE)UP:
                        if (a->up) {
                            a->upNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->upVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                        }
                        break;
                    case (SIDE)RIGHT:
                        if (a->right) {
                            a->rightNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->rightVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                        }
                        break;
                    case (SIDE)DOWN:
                        if (a->down) {
                            a->downNormals = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(finalMatrix), NULL);
                            a->downVertecies= GLKMatrix4Multiply(projectionMatrix, finalMatrix);
                        }
                        break;
                }
            }
        }
    }
    
    PlayerDataLabel.text = [NSString stringWithFormat: @"Player Position: x: %d  y: %d \nPlayer Rotation: %f", mazeXPos, mazeYPos, mazeViewRotate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    //[self.effect prepareToDraw];
    
    //glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    for (int x = 0; x < maze->mazeWidth; x++) {
        for (int y = 0; y < maze->mazeHeight; y++) {
            for (int s = 0; s < SQUARE_SIDES; s++) {
                MazeSquare *a = [squares objectAtIndex:(x * maze->mazeHeight) + y];
                //NSLog(@"X: %d Y: %d Right: %d Up: %d Left: %d Down: %d ", x, y, a->right, a->up, a->left, a->down);
                switch((SIDE)s) {
                    case (SIDE)LEFT:
                        if (a->left) {
                            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, a->leftVertecies.m);
                            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, a->leftNormals.m);
                        }
                        break;
                    case (SIDE)UP:
                        if (a->up) {
                            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, a->upVertecies.m);
                            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, a->upNormals.m);
                        }
                        break;
                    case (SIDE)RIGHT:
                        if (a->right) {
                            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, a->rightVertecies.m);
                            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, a->rightNormals.m);
                        }
                        break;
                    case (SIDE)DOWN:
                        if (a->down) {
                            glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, a->downVertecies.m);
                            glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, a->downNormals.m);
                        }
                        break;
                }
                
                glDrawArrays(GL_TRIANGLES, 0, 36);
            }
        }
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
    mazeViewRotate += 90;
}
- (IBAction)SwipeLeft:(UISwipeGestureRecognizer *)sender {
    mazeViewRotate -= 90;
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

@end
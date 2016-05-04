//
//  Sprite.swift
//  Raptor
//
//  Created by Jordan Davis on 4/24/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import GLKit

class Sprite {
    
    //MARK: - OpenGL
    static private var _program: GLuint = 0
    
    static private let _quad: [Float] = [
        -0.5, -0.5,
        0.5, -0.5,
        -0.5, 0.5,
        0.5, 0.5
    ]
    
    static private let _quadTextureCoordinates: [Float] = [
        0.0, 1.0,
        1.0, 1.0,
        0.0, 0.0,
        1.0, 0.0
    ]
    
    private static func setUp() {
        //create vertex shader
        let vertexShaderSource: NSString = "" +
            "attribute vec2 position; \n" +
            "attribute vec2 textureCoordinate; \n" +
            "uniform vec2 translate; \n" +
            "uniform vec2 scale; \n" +
            "varying vec2 textureCoordinateInterpolated; \n" +
            "void main() \n" +
            "{ \n" +
            "     gl_Position = vec4(position.x * scale.x + translate.x, position.y * scale.y + translate.y, 0.0, 1.0); \n" +
            "   textureCoordinateInterpolated = textureCoordinate; \n" +
            "} \n"

        
        //create fragment shader
        let fragmentShaderSource: NSString = "" +
            "uniform highp vec4 color; \n" +
            "uniform sampler2D textureUnit; \n" +
            "varying highp vec2 textureCoordinateInterpolated; \n" +
            "void main() \n" +
            "{ \n" +
            "     gl_FragColor = texture2D(textureUnit, textureCoordinateInterpolated); \n" +
            "} \n"
        
        //compile vertex shader
        let vertexShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        var vertexShaderSourceUTF8 = vertexShaderSource.UTF8String
        glShaderSource(vertexShader, 1, &vertexShaderSourceUTF8, nil)
        glCompileShader(vertexShader)
        var vertexShaderCompileStatus = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexShaderCompileStatus)
        if vertexShaderCompileStatus == GL_FALSE {
            let vertexShaderCompileLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &vertexShaderCompileStatus)
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.alloc(Int (vertexShaderCompileLength))
            glGetShaderInfoLog(vertexShader, vertexShaderCompileLength, nil, vertexShaderLog)
            let vertexShaderLogString: NSString? = NSString(UTF8String: vertexShaderLog)
            print ("Vertex Shader Compile Error: \(vertexShaderLogString)")
            //TODO: Prevent drawing
        }
        
        //compile fragment shader
        let fragmentShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        var fragmentShaderSourceUTF8 = fragmentShaderSource.UTF8String
        glShaderSource(fragmentShader, 1, &fragmentShaderSourceUTF8, nil)
        glCompileShader(fragmentShader)
        var fragmentShaderCompileStatus = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatus)
        if fragmentShaderCompileStatus == GL_FALSE {
            let fragmentShaderCompileLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &fragmentShaderCompileStatus)
            let fragmentShaderLog = UnsafeMutablePointer<GLchar>.alloc(Int (fragmentShaderCompileLength))
            glGetShaderInfoLog(fragmentShader, fragmentShaderCompileLength, nil, fragmentShaderLog)
            let fragmentShaderLogString: NSString? = NSString(UTF8String: fragmentShaderLog)
            print ("Fragment Shader Compile Error: \(fragmentShaderLogString)")
            //TODO: Prevent drawing
        }
        
        
        //Link shaders into a full program
        _program = glCreateProgram()
        glAttachShader(_program, vertexShader)
        glAttachShader(_program, fragmentShader)
        
        glBindAttribLocation(_program, 0, "position")
        glBindAttribLocation(_program, 1, "textureCoordinate")
        
        glLinkProgram(_program)
        var programLinkStatus: GLint = GL_FALSE
        glGetProgramiv(_program, GLenum(GL_LINK_STATUS), &programLinkStatus)
        if programLinkStatus == GL_FALSE {
            var programLogLength: GLint = 0
            glGetProgramiv(_program, GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            let linkLog = UnsafeMutablePointer<GLchar>.alloc(Int(programLogLength))
            glGetProgramInfoLog(_program, programLogLength, nil, linkLog)
            let linkLogString: NSString? = NSString(UTF8String: linkLog)
            print("Program Link Failed Error: \(linkLogString)")
            
        }
        
        // Redefine OpenGL defaults (may need to be moved to draw() method)
        // TODO: What changes will other OpenGL users in the program make??
        //setup square
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glUseProgram(_program)
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _quad)
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, _quadTextureCoordinates)

    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////


    //MARK: - Sprite
    var position: Vector = Vector()
    var width: Float = 1.0
    var height: Float = 1.0
    var texture: GLuint = 0
    var _movementSpeed: Float = 0.01
    
    
    func draw() {
        if Sprite._program == 0 {
            Sprite.setUp()
        }
        
        //Draw a square
        glUniform2f(glGetUniformLocation(Sprite._program, "translate"), position.x, position.y)
        glUniform2f(glGetUniformLocation(Sprite._program, "scale"), width , height)
        glUniform1i(glGetUniformLocation(Sprite._program, "textureUnit"), 0)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
    
    func getRadius() -> Double{
        let squareInches: Double = (Double(self.width) * Double(self.width)) * 2.0
        let root: Double = sqrt(squareInches)
        return (root / 2)
    }
    
    func moveLeft(){
        if(position.x > -0.45){
            position.x -= _movementSpeed / 2
        }
    }
    
    func moveRight(){
        if(position.x < 0.45){
            position.x += _movementSpeed / 2
        }
    }
    
    func moveUp(){
        if(position.y < 0.30){
            position.y += _movementSpeed / 2
        }
    }
    
    func moveDown(){
        if(position.y > -0.75){
            position.y -= _movementSpeed / 2
        }
    }
    
    func moveUpRight(){
        if(position.y < 0.30){
            position.y += _movementSpeed / 2.25
        }
        if(position.x < 0.45){
            position.x += _movementSpeed / 2.25
        }
    }
    func moveUpLeft(){
        if(position.y < 0.30 ){
            position.y += _movementSpeed / 2.25
        }
        if(position.x > -0.45){
            position.x -= _movementSpeed / 2.25
        }
    }
    func moveDownRight(){
        if(position.y > -0.75){
            position.y -= _movementSpeed / 2.25
        }
        if (position.x < 0.45){
            position.x += _movementSpeed / 2.25
        }
    }
    func moveDownLeft(){
        if(position.y > -0.75){
            position.y -= _movementSpeed / 2.25
        }
        if(position.x > -0.45){
            position.x -= _movementSpeed / 2.25
        }
    }
}


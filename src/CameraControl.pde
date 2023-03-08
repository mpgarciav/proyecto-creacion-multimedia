public class CameraControl {
  final float MOVE_SPEED = 16;
  final float ROTATION_SPEED = 0.04;
  
  PApplet parent;

  CameraControl(PApplet parent) {
    this.parent = parent;
    try {
      parent.registerMethod("dispose", this);
      parent.registerMethod("pre", this);
    } 
    catch (Exception e) {
    }
  }

  public void dispose() {
    parent.unregisterMethod("dispose", this);
    parent.unregisterMethod("pre", this);
  }

  public void pre() {
    // If you don't wont to run automatically, comment out this line and call keyControl() in the draw() instead.
    keyControl();
  }

  public void keyControl() {
    if ( !parent.keyPressed ) return;

    // Matrix that modifies the camera matrix
    PMatrix3D M = new PMatrix3D();

    if ( parent.key == 'w' ) {
      M.translate( 0, 0, MOVE_SPEED );
    } else if ( parent.key == 's' ) {
      M.translate( 0, 0, -MOVE_SPEED );
    } else if ( parent.key == 'a' ) {
      M.translate( MOVE_SPEED, 0, 0 );
    } else if ( parent.key == 'd' ) { 
      M.translate( -MOVE_SPEED, 0, 0 );
    } else if ( parent.key == 'e' ) { 
      M.translate( 0, MOVE_SPEED, 0 );
    } else if ( parent.key == 'c' ) { 
      M.translate( 0, -MOVE_SPEED, 0 );
    } else if ( parent.key == PConstants.CODED ) {
      if ( parent.keyCode == PConstants.UP ) {     
        M.rotateX(ROTATION_SPEED);
      } else if ( parent.keyCode == PConstants.DOWN ) {  
        M.rotateX(-ROTATION_SPEED);
      } else if ( parent.keyCode == PConstants.RIGHT ) { 
        M.rotateY(ROTATION_SPEED);
      } else if ( parent.keyCode == PConstants.LEFT ) {  
        M.rotateY(-ROTATION_SPEED);
      }
    }

    // Modify the current camera matrix
    PMatrix3D C = ((PGraphicsOpenGL)(this.parent.g)).camera.get(); // copy
    C.preApply(M);

    // Correction to make the up vector to (0,1,0)
    C.invert();
    float ex = C.m03;
    float ey = C.m13;
    float ez = C.m23;
    float cx = -C.m02 + ex;
    float cy = -C.m12 + ey;
    float cz = -C.m22 + ez;
    parent.camera( ex, ey, ez, cx, cy, cz, 0, 1, 0 );
  }
}

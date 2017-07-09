import peasy.*;

int floorWidth = 400;
int floorLength = 800;


int baseWidth = 8;
int baseLength = 15;
int baseHeight = 2;
int baseX = 0;
int baseY = baseLength / 2;
int baseZ = baseHeight / 2;
float cannonHorizontalAngle = 90;
boolean decreaseHorizontalAngle = false;
boolean increaseHorizontalAngle = false;

float cannonLength = 12;
float cannonVerticalAngle = 0;
boolean decreaseVerticalAngle = false;
boolean increaseVerticalAngle = false;
float angleSensitivity = .5;

boolean projectileFired = false;
PVector projectilePositionVector;
PVector projectileVelocityVector;
float projectileRadius = 1;
float projectileVelocity = 10;

PVector gravity = new PVector(0, 0, -.25);

PeasyCam cam;
int camLookAtX = 100;
int camLookAtY = -50;
int camLookAtZ = -1 * floorLength / 2;


void setup() {
  size(1920, 1080, P3D);
  smooth();
  cam = new PeasyCam(this, camLookAtX, camLookAtY, camLookAtZ, 500);
  cam.setYawRotationMode();
}

void draw() {
  background(100);
  setPerspective();
  cam.lookAt(camLookAtX, camLookAtY, 0);
  drawFloor();
  drawBase();
  drawCannon(10, 1, cannonLength);
  updateCannon();
  updateProjectile();
  drawHUD();
}

void setPerspective() {
  scale(1, -1);
  rotateX(-PI/2);
}

void drawFloor() {
  fill(51);
  noStroke();
  rect(-floorWidth / 2, 0, floorWidth, floorLength);
}

void drawBase() {
  noStroke();
  fill(182, 155, 76);
  pushMatrix();
  rotateZ(radians(cannonHorizontalAngle - 90));
  translate(baseX, baseY, baseZ);
  box(baseWidth, baseLength, baseHeight);
  popMatrix();
}

void drawCannon(int sides, float radius, float length) {
  fill(255);
  pushMatrix();
  translate(0, 0, baseHeight * 2);
  rotateZ(radians(cannonHorizontalAngle - 90));
  rotateX(radians(cannonVerticalAngle - 90));
  float angle = 360 / sides, circleX, circleY;
  beginShape();
  for (int i = 0; i < sides; i++) {
    circleX = cos(radians( i * angle)) * radius;
    circleY = sin(radians(i*angle)) * radius;
    vertex(circleX, circleY, 0);
  }
  endShape(CLOSE);

  beginShape();
  for (int i = 0; i < sides; i++) {
    circleX = cos(radians( i * angle)) * radius;
    circleY = sin(radians(i*angle)) * radius;
    vertex(circleX, circleY, length);
  }
  endShape(CLOSE);

  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    circleX = cos(radians(i * angle)) * radius;
    circleY = sin(radians(i * angle)) * radius;
    vertex(circleX, circleY, length);
    vertex(circleX, circleY, 0);
  }
  endShape(CLOSE);
  popMatrix();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      increaseHorizontalAngle = true;
    } else if (keyCode == RIGHT) {
      decreaseHorizontalAngle = true;
    } else if (keyCode == UP) {
      increaseVerticalAngle = true;
    } else if (keyCode == DOWN) {
      decreaseVerticalAngle = true;
    }
  } else if (key == ' ') {
    fire();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      increaseHorizontalAngle = false;
    } else if (keyCode == RIGHT) {
      decreaseHorizontalAngle = false;
    } else if (keyCode == UP) {
      increaseVerticalAngle = false;
    } else if (keyCode == DOWN) {
      decreaseVerticalAngle = false;
    }
  }
}

void updateCannon() {
  if (increaseHorizontalAngle && cannonHorizontalAngle < 180) cannonHorizontalAngle += angleSensitivity;
  if (decreaseHorizontalAngle && cannonHorizontalAngle > 0) cannonHorizontalAngle -= angleSensitivity;
  if (increaseVerticalAngle && cannonVerticalAngle < 90) cannonVerticalAngle += angleSensitivity;
  if (decreaseVerticalAngle && cannonVerticalAngle > 0) cannonVerticalAngle -= angleSensitivity;
}

void fire() {
  projectilePositionVector = new PVector(cos(radians(cannonHorizontalAngle)) * Math.abs(cos(radians(cannonVerticalAngle))), sin(radians(cannonHorizontalAngle)) * cos(radians(cannonVerticalAngle)), sin(radians(cannonVerticalAngle)));
  projectileVelocityVector = new PVector(projectilePositionVector.x, projectilePositionVector.y, projectilePositionVector.z);
  projectileVelocityVector.mult(projectileVelocity);
  projectileFired = true;
}

void updateProjectile() {
    float endOfCannonX = (cannonLength - projectileRadius / 2) * (cos(radians(cannonHorizontalAngle)) * cos(radians(cannonVerticalAngle)));
    float endOfCannonY = (cannonLength - projectileRadius / 2) * (cos(radians(cannonVerticalAngle)) * sin(radians(cannonHorizontalAngle)));
    float endOfCannonZ = (cannonLength - projectileRadius / 2) * sin(radians(cannonVerticalAngle)) + baseHeight * 2;
  if (projectileFired) {
    if (projectilePositionVector.z >= - endOfCannonZ + 1) {
      projectilePositionVector.add(projectileVelocityVector);
      projectileVelocityVector.add(gravity);
    } else {
      projectileFired = false; 
    }
    pushMatrix();
    translate(endOfCannonX + projectilePositionVector.x, endOfCannonY + projectilePositionVector.y, endOfCannonZ + projectilePositionVector.z);
    sphere(projectileRadius);
    popMatrix();
  }
}

void drawHUD() {
  cam.beginHUD();
  textSize(15);
  text("my text", 10, 20);
  cam.endHUD();
}
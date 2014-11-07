/*
Copyright (C) 2014 Birger Schulze
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 */
 
 /*
 TODO:
 - Calibration of the speed formula
 */
float difficulty = 1000;
final float maxDifficulty = 10000;
final float maxSpeed = 20;
float imageWidth, imageHeight;

class Bug {
  float xPos, yPos;
  PImage sprite;
  float speed = 2;
  float direction = 0;

  Bug(float x, float y, String imageName) {
    this(x, y, imageName, 20, 40);
  }

  Bug(float x, float y, String imageName, float w, float h) {
    xPos = x;
    yPos = y;
    sprite = loadImage(imageName);
    imageWidth = w;
    imageHeight = h;
    replace();
  }

  boolean outOfScreen() {
    return !(xPos >= 0 && xPos <= width && yPos >= 0 && yPos <= height);
  }

  void update() {
    resetMatrix();
    translate(xPos, yPos);
    rotate(direction);
    translate(0, -speed);
    xPos = screenX(0, 0);
    yPos = screenY(0, 0);
    float distance = dist(mouseX, mouseY, xPos, yPos);
    float newSpeed = speedFormula(distance);
    speed = (newSpeed <= maxSpeed)?newSpeed:maxSpeed;
    direction += radians((this.outOfScreen())?180:random(-20, 20));
  }

  void display() {
    resetMatrix();
    translate(xPos, yPos);
    rotate(direction);
    image(sprite, 0, 0, imageWidth, imageHeight);
  }

  private float speedFormula(float dist) {
    return difficulty/100+1/(dist/difficulty);
  }

  boolean hit() {
    return mouseInCircle(xPos, yPos, 50);
  }

  void replace() {
    resetMatrix();
    translate(random(width), random(height));
    direction = random(TWO_PI);
  }
}

int scrWidth = 640;
int scrHeight = 480;
int scrDiag = 0;
PImage blood;
String roachImage = "kakerlake.png";
String bloodImage = "blutfleck.png";
int bgColor = 255;
float fps = 30;
int aaLevel = 8;

Bug testBug;

ArrayList<PVector> squished;

void setup() {
  squished = new ArrayList<PVector>();
  scrDiag = scrHeight*scrWidth/2;
  size(scrWidth, scrHeight);
  background(bgColor);
  blood = loadImage(bloodImage);
  imageMode(CENTER);
  testBug = new Bug(100, 100, roachImage);
  frameRate(fps);
  pushMatrix();
  cursor(CROSS);
}

void draw() {
  background(bgColor);
  fill(0);
  text("Roaches squished: " + squished.size(), 0.0, 10.0);
  text("Difficulty: " + difficulty/100, 0.0, 22.0);
  noStroke();
  fill(255, 0, 0);
  for (PVector p : squished) {
    image(blood, (float)p.x, (float)p.y, imageHeight, imageHeight);
  }
  testBug.update();
  testBug.display();
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    difficulty += (difficulty + 100 <= maxDifficulty)?1000:0;
  } else if (mouseButton == CENTER) {
  } else {
  }
}

boolean mouseInCircle(float x, float y, float radius) {
  return dist(x, y, mouseX, mouseY) <= radius;
}

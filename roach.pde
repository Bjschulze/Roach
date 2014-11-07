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
 
 */


int scrWidth = 640;
int scrHeight = 480;
int scrDiag = 0;
PVector center;
PImage blood;
String roachImage = "kakerlake.png";
String bloodImage = "blutfleck.png";
int bgColor = 255;
float fps = 30;
int aaLevel = 8;

float difficulty = 1;
final float maxDifficulty = 10;
final float maxSpeed = 20;
float imageWidth, imageHeight;

class Bug {
  float xPos, yPos;
  PImage sprite;
  float speed = 2;
  float direction = 0;

  Bug(String imageName) {
    this(imageName, 20, 40);
  }

  Bug(String imageName, float w, float h) {
    sprite = loadImage(imageName);
    imageWidth = w;
    imageHeight = h;
    replace();
  }

  float getX() {
    return xPos;
  }

  float getY() {
    return yPos;
  }

  private boolean outOfScreen() {
    return !(xPos >= 0 && xPos <= width && yPos >= 0 && yPos <= height);
  }

  private boolean isStuck(float tolerance) {
    return !(xPos >= -tolerance && xPos <= width+tolerance && yPos >= -tolerance && yPos <= height+tolerance);
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
    speed = 1.5* ((newSpeed <= maxSpeed)?newSpeed:maxSpeed);
    if (this.outOfScreen()) {
      if (isStuck(30)) {
        println("Stuck!");
        replace();
      }
      direction += radians(180);
    } else
      direction += radians(random(-20, 20));
  }

  void display() {
    resetMatrix();
    translate(xPos, yPos);
    rotate(direction);
    image(sprite, 0, 0, imageWidth, imageHeight);
  }

  private float speedFormula(float dist) {
    return 1+1/(dist/(difficulty*100));
  }

  boolean hit() {
    return mouseInCircle(xPos, yPos, 50);
  }

  void replace() {
    resetMatrix();
    xPos = random(width);
    yPos = random(height);
    direction = random(TWO_PI);
  }
}

ArrayList<PVector> squished;
ArrayList<Bug> active;

void setup() {
  size(scrWidth, scrHeight);
  scrDiag = scrHeight*scrWidth/2;
  center = new PVector(width/2, height/2);
  squished = new ArrayList<PVector>();
  active = new ArrayList<Bug>();
  active.add(new Bug(roachImage));
  active.add(new Bug(roachImage));
  active.add(new Bug(roachImage));
  active.add(new Bug(roachImage));
  background(bgColor);
  blood = loadImage(bloodImage);
  imageMode(CENTER);
  frameRate(fps);
  cursor(CROSS);
}

void draw() {
  background(bgColor);
  fill(0);
  text("Roaches squished: " + squished.size(), 0.0, 10.0);
  text("Difficulty: " + difficulty, 0.0, 22.0);
  noStroke();
  fill(255, 0, 0);
  for (PVector p : squished) {
    image(blood, (float)p.x, (float)p.y, imageHeight, imageHeight);
  }
  for (Bug b : active) {
    b.update();
    b.display();
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    difficulty += (difficulty + 1 <= maxDifficulty)?1:0;
  } else if (mouseButton == CENTER) {
  } else {
    for (int i = 0; i < active.size (); i++) {
      if (active.get(i).hit()) {
        squished.add(new PVector(active.get(i).getX(), active.get(i).getY()));
        //println("hit");
        active.remove(i);
      }
    }
  }
}

boolean mouseInCircle(float x, float y, float radius) {
  return dist(x, y, mouseX, mouseY) <= radius;
}


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

float direction = 0;
float xPos = 0;
float yPos = 0;
float speed = 2;
float boost = 1;
float maxBoost = 10;
int scrWidth = 640;
int scrHeight = 480;
int scrDiag = 0;
PImage roach;
PImage blood;
String roachImage = "kakerlake.png";
String bloodImage = "blutfleck.png";
float imageWidth = 20;
float imageHeight = 40;
int bgColor = 255;
float fps = 60;
int aaLevel = 8;
float distance = 0;
float oldDistance = 0;
float maxDifficulty = 1000;
float difficulty = 100;

ArrayList<PVector> squished;

void setup() {
  squished = new ArrayList<PVector>();
  scrDiag = scrHeight*scrWidth/2;
  size(scrWidth, scrHeight);
  background(bgColor);
  roach = loadImage(roachImage);
  blood = loadImage(bloodImage);
  rotate(direction);
  imageMode(CENTER);
  image(roach, 0, 0, imageWidth, imageHeight);
  frameRate(fps);
  pushMatrix();
  replace();
  cursor(CROSS);
}

void draw() {
  background(bgColor);
  text("Roaches squished: " + squished.size(), 0.0, 10.0);
  text("Difficulty: " + difficulty/100, 0.0, 22.0);
  noStroke();
  fill(255, 0, 0);
  for (PVector p : squished) {
    image(blood, (float)p.x, (float)p.y, imageHeight, imageHeight);
  }
  popMatrix();
  float movement = -1*speed*((boost <= maxBoost)?boost:maxBoost);
  translate(0, movement);
  xPos = screenX(0, 0);
  yPos = screenY(0, 0);
  updateDistance();
  rotate(radians(updateDirection()));
  updateBoost(); 
  image(roach, 0, 0, imageWidth, imageHeight);
  stroke(0);
  fill(0);
  pushMatrix();
}

boolean outOfScreen() {
  return !(xPos >= 0 && xPos <= scrWidth && yPos >= 0 && yPos <= scrHeight);
}

float updateDirection() {
  float diff = random(-20, 20);
  if (outOfScreen()) {
    diff = 180;
  }
  direction += diff;
  return diff;
}

float updateDistance() {
  oldDistance = distance;
  distance = dist(mouseX, mouseY, xPos, yPos);
  return abs(oldDistance - distance);
}

float updateBoost() {
  return boost = 0.5+1/(distance/difficulty);
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    difficulty += (difficulty + 100 <= maxDifficulty)?100:0;
  } else if (mouseButton == CENTER) {
    replace();
  } else {
    if (mouseInCircle(xPos, yPos, 50)) {
      squished.add(new PVector(xPos, yPos));
      replace();
    }
  }
}

boolean mouseInCircle(float x, float y, float radius) {
  return dist(x, y, mouseX, mouseY) <= radius;
}

void replace() {
  popMatrix();
  resetMatrix();
  translate(random(width), random(height));
  rotate(random(radians(360)));
  pushMatrix();
}

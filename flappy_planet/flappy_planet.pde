/* Created by Jukniz(Chin Ho) and Màrius Mòra */

import ddf.minim.*;
Planet earth;
Player player;
PImage backg;
float gravity = 0.1;
Generator generator;
AudioPlayer music;
AudioPlayer explosionSound, coinSound;
Minim minim;
boolean gameOver;
PImage gameOverImage;
ScoreLabel scoreLabel;


void setup(){
  frameRate(120);
  textSize(18);
  size(768,768);
  backg=loadImage("SpaceBG.png");
  gameOverImage=loadImage("gameover.png");
  earth = new Planet();
  player = new Player(earth);
  generator = new Generator();
  scoreLabel=new ScoreLabel(0);
  gameOver=false;
    if (minim==null) {
    minim = new Minim(this);
    }
   if (music==null) {
    music = minim.loadFile("starwars.mp3", 2048);
    music.play();
    music.loop();
  }
  if(explosionSound==null){
  explosionSound = minim.loadFile("explosion.mp3", 2048);
  }
   if(coinSound==null){
  coinSound = minim.loadFile("coin.mp3", 2048);
  }
}


void tintAnimation(){
tint(0,255, 255);
}

void draw(){
  if(!gameOver){
  background(backg);
  earth.update();
  player.update();
   generator.update();
     scoreLabel.update();
  }else{
      image(gameOverImage, width/2-gameOverImage.width/2, height/2-gameOverImage.height);
       textSize(32);
    textAlign(CENTER);
    text("Press Enter to Restart", width/2, height/2+64);
     textSize(18);
      textAlign(LEFT);
      if (keyCode == ENTER) {
      setup();
    }
  }

}




class Player{
  Planet planet;
  PVector coord; 
  PImage rocket;
  boolean isAlive; 
  float distanceToEarth;
  float angle;
  float angleView;
  float radius;
  float maxDistance, minDistance;
  
  Player(Planet planet){
    this.rocket = loadImage("rocket.png");
    this.isAlive = true;
    this.angle = 0.02;
    this.planet = planet;
    this.angleView=0;
       this.maxDistance=350;
       this.radius = rocket.width;
    this.minDistance=planet.radius;
    this.coord = new PVector(planet.coord.x, planet.coord.y-planet.radius);
    this.distanceToEarth = sqrt(pow(coord.x-planet.coord.x, 2) + pow(coord.y-planet.coord.y,2));
  
  }
  
  void update(){
    if (keyPressed) {
      
        if (keyCode == UP || key == ' ') {
           setDistanceToEarth(distanceToEarth+2);
      
    }
         }else{
     setDistanceToEarth(distanceToEarth-2);
    }
    updateCoord();
    updateAngleView();
    pushMatrix();
    translate(coord.x,  coord.y);
    rotate(angleView);
  image(rocket,  -rocket.width/2, -rocket.height/2);
  popMatrix();
  
  
  }
  
  void updateCoord(){
  float s = sin(angle);
  float c = cos(angle);

  // translate point back to origin:
  coord.x -= planet.coord.x;
  coord.y -= planet.coord.y;

  // rotate point
  float xnew = coord.x * c - coord.y * s;
  float ynew = coord.x * s + coord.y * c;

  // translate point back:
  coord.x = xnew + planet.coord.x;
  coord.y = ynew + planet.coord.y;
    
 
  }
  
  boolean isCollide(PVector otherCoord, float otherRadius){
     float dx = otherCoord.x - coord.x;
    float dy = otherCoord.y - coord.y;
    float distance = sqrt(dx*dx + dy*dy);
    float minDist = otherRadius + radius;
    if (distance <= minDist) { 
      return true;
    } else {
      return false;
    }
  }
  
  void setDistanceToEarth(float newDistanceToEarth){
   if(distanceToEarth<maxDistance && newDistanceToEarth>distanceToEarth ||  distanceToEarth>minDistance && newDistanceToEarth<distanceToEarth ){
    distanceToEarth=newDistanceToEarth;
    float dx = planet.coord.x -  coord.x;
            float dy =  planet.coord.y - coord.y;
          float angleTemp =  atan(dy / dx);
   float dxf = cos(angleTemp) * this.distanceToEarth;
    float dyf = sin(angleTemp) * this.distanceToEarth;
    if (dx > 0) {
                dxf = dxf * -1;
                dyf = dyf * -1;
            }
   coord.x= planet.coord.x +dxf;
    coord.y= planet.coord.y +dyf;
   // println(coord.x, coord.y, this.distanceToEarth);
    }
  }
  
  void updateAngleView(){
  float dx = planet.coord.x -  coord.x;
            float dy =  planet.coord.y - coord.y;
             angleView = atan(dy / dx);
               
            if (dx <= 0) {
                angleView = radians(degrees(angleView)+180);
            }
  
  }
  
  
}

class Planet{
  
  PVector coord;
  PImage earthImage;
  float radius;
   
  Planet(){
  this.earthImage = loadImage("earth.png");
  this.coord = new PVector(width/2, height/2);
  this.radius = earthImage.width/2;
  }
  
  void update(){
  
    image(earth.earthImage, earth.coord.x-earthImage.width/2, earth.coord.y - earthImage.height/2);
  
  }
  
}


class Asteroid{
  PVector coord;
  PImage asteroidImage;
  float radius;
  PVector velocity;
    Asteroid(PVector coord, PVector velocity){
  this.asteroidImage = loadImage("asteroid.png");
  this.coord = coord;
  this.velocity = velocity;
  this.radius = asteroidImage.width/5;
  }
  
    void update(){
      move();
    image(asteroidImage, coord.x-asteroidImage.width/2, coord.y - asteroidImage.height/2);
  }
  
  void move(){
  coord.x += velocity.x;
  coord.y += velocity.y;
  }
  
}

class Astronaut{
  PVector coord;
  PImage astronautdImage;
  float radius;
  PVector velocity;
    Astronaut(PVector coord, PVector velocity){
  this.astronautdImage = loadImage("astronaut.png");
  this.coord = coord;
  this.velocity = velocity;
  this.radius = astronautdImage.width/2;
  }
  
    void update(){
      move();
    image(astronautdImage, coord.x-astronautdImage.width/2, coord.y - astronautdImage.height/2);
  }
  
  void move(){
  coord.x += velocity.x;
  coord.y += velocity.y;
  }
}

class Generator{
  ArrayList<Asteroid> aAsteroid;
    ArrayList<Asteroid> aAsteroidToDestroy;
     ArrayList<Astronaut> aAstronaut;
   ArrayList<Astronaut> aAstronautToDestroy;
    Timer timer;
  Generator(){
    aAsteroid= new ArrayList<Asteroid>();
    aAsteroidToDestroy= new ArrayList<Asteroid>();
       aAstronaut= new ArrayList<Astronaut>();
    aAstronautToDestroy= new ArrayList<Astronaut>();
    addAsteroids();
    timer = new Timer(5000);
    timer.start();
  }
  
  void update(){
     if (timer.isFinished()) {
    addAsteroids();
    addAstronaust();
     timer.start();
     }
    for(Asteroid asteroid : aAsteroid){
      asteroid.update();
      if(asteroid.coord.x+asteroid.radius<0-300 || asteroid.coord.x-asteroid.radius>width+300 || asteroid.coord.y+asteroid.radius<0-300 || asteroid.coord.y-asteroid.radius>height+300){
        aAsteroidToDestroy.add(asteroid);
      }
      
      if(player.isCollide(asteroid.coord, asteroid.radius)){
        gameOver=true;
        explosionSound.play(1);
      }
    }
    
     for (Asteroid asteroid : aAsteroidToDestroy) {
      aAsteroid.remove(asteroid);    
    }
    
    
    for(Astronaut astronaut : aAstronaut){
      astronaut.update();
      if(astronaut.coord.x+astronaut.radius<0-300 || astronaut.coord.x-astronaut.radius>width+300 || astronaut.coord.y+astronaut.radius<0-300 || astronaut.coord.y-astronaut.radius>height+300){
        aAstronautToDestroy.add(astronaut);
      }
      
      if(player.isCollide(astronaut.coord, astronaut.radius)){
        scoreLabel.score++;
        aAstronautToDestroy.add(astronaut);
        coinSound.play(1);
      }
    }
    
     for (Astronaut astronaut : aAstronautToDestroy) {
      aAstronaut.remove(astronaut);    
    }

    aAstronautToDestroy.clear();

  }
  
  void addAsteroids(){
    aAsteroid.add(new Asteroid(new PVector(random(-200, -100), random(0, height)), new PVector(random(0.1, 2), random(-2, 2))));
    aAsteroid.add(new Asteroid(new PVector(random(width+100, width+200), random(0, height)), new PVector(random(-2, -0.1), random(-2, 2))));
    aAsteroid.add(new Asteroid(new PVector(random(0, width), random(-200, -100)), new PVector(random(-2, 2), random(0.1, 2))));
    aAsteroid.add(new Asteroid(new PVector(random(0, width), random(height+100, height+200)), new PVector(random(-2, 2), random(-2, 0.1))));
  }
  
  
  void addAstronaust(){
    aAstronaut.add(new Astronaut(new PVector(random(-200, -100), random(0, height)), new PVector(random(0.1, 2), random(-2, 2))));
    aAstronaut.add(new Astronaut(new PVector(random(width+100, width+200), random(0, height)), new PVector(random(-2, -0.1), random(-2, 2))));
    aAstronaut.add(new Astronaut(new PVector(random(0, width), random(-200, -100)), new PVector(random(-2, 2), random(0.1, 2))));
    aAstronaut.add(new Astronaut(new PVector(random(0, width), random(height+100, height+200)), new PVector(random(-2, 2), random(-2, 0.1))));
  }
}

class ScoreLabel {
  int score;
  ScoreLabel(int score) {
    this.score = score;
  }

  void update() {
    fill(255);
    text("Score: "+score, 20, 35);
  }
}

class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}

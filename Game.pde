import processing.serial.*;


Controller myController;
Serial myPort;

void setup() {
  size(1000, 750);
  //Adjust frame rate so that the game state is refreshed 100 times per second
  frameRate(100);
  //Following the API defined at https://www.processing.org/reference/libraries/serial/Serial.html the Serial constructor must be declared within
  //the setup() method so we create a new instance of type Serial here and pass it to our controller
  //myPort = new Serial(this, Serial.list()[0], 9600);
  //myController = new Controller(myPort);
  myController = new Controller();
}

void draw() {
  myController.run();
}

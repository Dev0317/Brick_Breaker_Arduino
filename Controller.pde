class Controller {
  
  private Model model;
  private View view;
  private int level;
  private Serial port;
  
  Controller() {
    this.level = START_LEVEL;
    this.view = new View();
    //this.port = port;  
    //Pass this object of type Conroller to the Model constructor so Model can interact with  Controller API
    this.model = new Model(this, this.level);
  }
  
  // The function checks for user input and moves the paddle
  //public void buttonPress() {
  //  if (this.port.available() > 0) {
  //    char c = this.port.readChar();
  //    if (c == 'r') {
  //      this.model.paddle.moveRight();
  //    } else if (c == 'l') {
  //      this.model.paddle.moveLeft();
  //    }
  //  }
  //}
  
  public void buttonPress(char k) {
    if (k == 'd' || k == 'D') {
      this.model.paddle.moveRight();
    } else if (k == 'a' || k == 'A') {
      this.model.paddle.moveLeft();
    }
  }
  
  // The function resets the game state by simply creating new objects for the model and the view
  public void restart() {
    this.level = 1;
    this.model = new Model(this, this.level);
    this.view = new View();
  }
  
  public void nextLevel() {
    this.level++;
    this.model = new Model(this, this.level);
    this.view = new View();
  }
  
  // Called every frame to update game state
  void run() {
    this.view.initBackground();
    this.model.update();
  }
  
  // Functions below represent Model facing API that is used to pass data from the game model to the view
  
  public void registerBricks(ArrayList<ArrayList<Brick>> bricks) {
    for (ArrayList<Brick> row : bricks) {
      for (Brick brick : row) {
        this.view.registerBrick(brick);
      }
    }
  }
  
  public void registerPaddle(Paddle paddle) {
    this.view.registerPaddle(paddle);
  }
  
  public void registerBall(Ball ball) {
    this.view.registerBall(ball);
  }
  
  public void registerLives(int lives) {
    this.view.registerLives(lives);
  }
  
  public void registerLevel(int level) {
    this.view.registerLevel(level);
  }
  
}

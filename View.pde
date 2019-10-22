public class View {
  
  private PImage paddleSprite;
  private PFont f;
  
  View() {
    this.paddleSprite = loadImage("paddle.png");
    this.f = createFont("Arial",16,true);
  }
  
  // Controller facing API, the methods draw the background & game objects on the canvas when invoked by the controller
  
  public void initBackground() {
    background(35, 78, 245);
  }
  
  public void registerBrick(Brick brick) {
    fill(127,0,0);
    rect(brick.getX(), brick.getY(), brick.getObjectWidth(), brick.getObjectHeight());
  }
  
  public void registerBall(Ball ball) {
    fill(255, 0, 0);
    ellipse(ball.getX(), ball.getY(), ball.getObjectWidth(), ball.getObjectHeight());
  }
  
  public void registerPaddle(Paddle paddle) {
    image(paddleSprite,paddle.getX(),paddle.getY());
  }
  
  public void registerLives(int lives) {
    fill(255, 0, 0);
    for (int i = 0; i < 30*lives; i+= 30) {
      ellipse(HORIZONTAL_MARGIN + i * 2, 700, 30, 30);
    }
  }
  
  public void registerLevel(int level) {
    textFont(f,32);                 
    fill(0);        
    text("LEVEL: " + level, HORIZONTAL_MARGIN, 50);
  }
  
}

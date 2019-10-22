import java.util.ArrayList;
import java.util.Iterator;

public class GameObject {
  
  // Protected access modifier permits subclasses to access the field
  protected int xCoord;
  protected int yCoord;
  protected int objectHeight;
  protected int objectWidth;
  
  GameObject(int xCoord, int yCoord, int objectHeight, int objectWidth) {
    this.xCoord = xCoord;
    this.yCoord = yCoord;
    this.objectHeight = objectHeight;
    this.objectWidth = objectWidth;
  }
  
  public int getX() {
    return this.xCoord;
  }
  
  public int getY() {
    return this.yCoord;
  }
  
  public int getObjectWidth() {
    return this.objectWidth;
  }
  
  public int getObjectHeight() {
    return this.objectHeight;
  }
  
  public void setX(int x) {
    this.xCoord = x;
  }
  
  public void setY(int y) {
    this.yCoord = y;
  }
  
}

// Bricks, the paddle and the ball are all game objects - they all have a position in the coordinate system, height and width

public class Brick extends GameObject {
  
  private int centreX;
  private int centreY;
  
  Brick(int xCoord, int yCoord, int objectHeight, int objectWidth) {
    super(xCoord, yCoord, objectHeight, objectWidth);
    this.centreX = xCoord + objectWidth/2;
    this.centreY = yCoord + objectHeight/2;
  }
  
  public int getCentreX() {
    return this.centreX;
  }
  
  public int getCentreY() {
    return this.centreY;
  }
  
}

public class Paddle extends GameObject {
  
  Paddle(int xCoord, int yCoord, int objectHeight, int objectWidth) {
    super(xCoord, yCoord, objectHeight, objectWidth);
  }
  
  public void moveLeft() {
    if (this.xCoord > 0) {
      this.xCoord -= PADDLE_SPEED;   
    }
  }
  
  public void moveRight() {
    if (this.xCoord < CANVAS_WIDTH - this.objectWidth) {
      this.xCoord += PADDLE_SPEED;
    }
  }
  
}

public class Ball extends GameObject {
  
  private int xVelocity;
  private int yVelocity;
  
  Ball(int xCoord, int yCoord, int objectHeight, int objectWidth, int xVelocity, int yVelocity) {
    super(xCoord, yCoord, objectHeight, objectWidth);
    this.xVelocity = xVelocity;
    this.yVelocity = yVelocity;
  }
  
  public void setXVelocity(int xVelocity) {
    this.xVelocity = xVelocity;
  }
  
  public void setYVelocity(int yVelocity) {
    this.yVelocity = yVelocity;
  }
  
  public int getXVelocity() {
    return this.xVelocity;
  }
  
  public int getYVelocity() {
    return this.yVelocity;
  }
  
  public void move() {
    this.xCoord += xVelocity;
    this.yCoord += yVelocity;
  }
  
  public Boolean isInsideBrick(Brick brick) {
    if (abs(brick.getCentreX() - this.xCoord) <= brick.getObjectWidth()/2 + this.objectWidth/2 && 
    abs(brick.getCentreY() - this.yCoord) <= brick.getObjectHeight()/2 + this.objectHeight/2) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isInsidePaddle(Paddle paddle) {
    // The png image for the paddle sprite has got some vertical padding above the paddle, hence the offset in the y axis
    if (this.xCoord <= paddle.getX() + paddle.getObjectWidth() && this.xCoord >= paddle.getX()
    && this.yCoord + this.objectHeight/2 >= paddle.getY() + 45 && this.yCoord + this.objectHeight/2 < paddle.getY() + 55) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isInsideRightOfPaddle(Paddle paddle) {
    if (isInsidePaddle(paddle) && this.xCoord > paddle.getX() + paddle.getObjectWidth()/2) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isInsideLeftOfPaddle(Paddle paddle) {
    if (isInsidePaddle(paddle) && this.xCoord <= paddle.getX() + paddle.getObjectWidth()/2) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isBelowCanvas() {
    if (this.yCoord > CANVAS_HEIGHT) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isAgainstSideOfCanvas() {
    if (this.xCoord + this.objectWidth/2 >= CANVAS_WIDTH || this.xCoord - this.objectWidth/2 <= 0) {
      return true;
    } else {
      return false;
    }
  }
  
  public Boolean isAgainstTopOfCanvas() {
    if (this.yCoord - this.objectHeight/2 <= 0) {
      return true;
    } else {
      return false;
    }
  }
  
}

public class Model {
  
  private Controller controller;
  private Ball ball;
  private Paddle paddle;
  private ArrayList<ArrayList<Brick>> bricks;
  private int level;
  private int lives;
  
  Model(Controller controller, int level) {
    this.controller = controller;
    this.lives = STARTING_LIVES;
    this.level = level;
    // Pin the speed of the ball to the level so that it becomes faster every level
    this.ball = new Ball(CANVAS_WIDTH / 2, CANVAS_HEIGHT - 300, 30, 30, BALL_VELOCITYX*level, BALL_VELOCITYY*level);
    this.paddle = new Paddle(CANVAS_WIDTH /2 - 74, CANVAS_HEIGHT - 150, 125, 148);
    this.bricks = new ArrayList<ArrayList<Brick>>();
    createBricks(this.level);
  }
  
  //Initialize elements within matrix representing wall of bricks
  private void createBricks(int level) {
    for (int i = 0; i < 5 + level - 1; i++) {
      this.bricks.add(new ArrayList<Brick>());
      for (int j = 0; j < 8; j++) {
        this.bricks.get(i).add(new Brick(HORIZONTAL_MARGIN + 17*(j + 1) + 90*j, VERTICAL_MARGIN + 17*(i + 1) + 30*i, 30, 90));
      }
    }
  }
  
  // Function resets position of ball to starting position
  private void respawnBall() {
    this.ball.setX(this.paddle.getX() + this.paddle.getObjectWidth() / 2);
    this.ball.setY(CANVAS_HEIGHT - 300);
  }
  
  private void checkBall() {
    // Checks if ball has made contact with bricks, if so, removes brick from list
    for (ArrayList<Brick> row : bricks) {
      // Iterator allows elements to be removed from the list during iteration safely
      for (Iterator<Brick> it = row.iterator(); it.hasNext();) {
        Brick brick = it.next();
        if (this.ball.isInsideBrick(brick)) {
          // Change direction of ball in the y axis
          this.ball.setYVelocity(this.ball.getYVelocity() * -1);
          it.remove();
        }
      }
    }
    
    if (this.ball.isAgainstSideOfCanvas()) {
      // Cause the ball to experience wall bounce by reversing its direction in the x axis
      this.ball.setXVelocity(this.ball.getXVelocity() * -1);
    }
    
    if (this.ball.isInsidePaddle(this.paddle) || this.ball.isAgainstTopOfCanvas()) {
      this.ball.setYVelocity(this.ball.getYVelocity() * -1);
    }
    
    // If the ball is travelling left and it hits the right side of the paddle, reverse its direction of travel
    if (this.ball.isInsideRightOfPaddle(this.paddle) && this.ball.getXVelocity() < 0) {
      this.ball.setXVelocity(this.ball.getXVelocity() * -1);
    }
    
    // If the ball is travelling right and it hits the left side of the paddle, reverse its direction of travel
    if (this.ball.isInsideLeftOfPaddle(this.paddle) && this.ball.getXVelocity() > 0) {
      this.ball.setXVelocity(this.ball.getXVelocity() * -1);
    }
    
    if (this.ball.isBelowCanvas()) {
      this.lives--;
      if (this.lives == 0) {
        restart();
      } else {
        respawnBall();
      }
    }
  }
 
 private void restart() {
   this.controller.restart();
 }
 
 private void hasWon() {
   for (ArrayList<Brick> row: this.bricks) {
     if (row.size() > 0) {
       return;
     }
   }
   next_level();
 }
 
 private void next_level() {
   this.controller.nextLevel();
 }
 
 // Function used to update the game view based on the game state through the controller
 
 private void registerGameObjects() {
   this.controller.registerBall(this.ball);
   this.controller.registerBricks(this.bricks);
   this.controller.registerLives(this.lives);
   this.controller.registerLevel(this.level);
   this.controller.registerPaddle(this.paddle);
 }
 
 // The function below represents the Controller facing API through which the game state is modified
 
 public void update() {
   this.ball.move();
   checkBall();
   hasWon();
   if (keyPressed) {
     this.controller.buttonPress(key);
   }
   registerGameObjects();
 }
  
}

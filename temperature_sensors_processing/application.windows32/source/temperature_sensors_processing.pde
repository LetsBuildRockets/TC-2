import processing.serial.*;
import java.util.Date;

Serial arduino;
PrintWriter output; 
PFont f;

float angleX = 0 ;
float angleY = 0 ;
float angleZ = 0 ;

void setup() {
  size(1200, 600) ;
  
  arduino = new Serial(this, Serial.list()[1], 9600);
  arduino.bufferUntil('\n');
  
  output = createWriter("temp " + mydate(0) + ".txt"); 
  
  f = createFont("Arial", 16, true);
  
  frameRate(4);
}

double seconds = 0;
void draw() {
  background(255);  
  textFont(f, 32);
  textAlign(CENTER);
  
  translate(width/6, height/2);
  fill(0);
  text (angleX+"\u00b0C", 0, 200);
  fill(255);
  stroke(0, 0, 0);
  ellipse(0, 0, height/2, height/2);
  strokeWeight(2);
  stroke(255, 0, 0) ;
  guage(height/4, angleX);

  translate(width/3, 0);
  fill(0);
  text (angleY+"\u00b0C", 0, 200);
  fill(255);
  stroke(0, 0, 0);
  ellipse(0, 0, height/2, height/2);
  stroke(255, 0, 0);
  guage(height/4, angleY);
  
  translate(width/3, 0);
  fill(0);
  text (angleZ+"\u00b0C", 0, 200);
  fill(255);
  stroke(0, 0, 0);
  ellipse(0, 0, height/2, height/2);
  stroke(255, 0, 0);
  guage(height/4, angleZ);

  String values = seconds + "\t" + angleX + "\t" + angleY + "\t" + angleZ;
  
  println(values);
  output.println(values);
  
  seconds += 0.25;
}

String mydate(int offset) {
  Date d = new Date();
  long timestamp = d.getTime() + (86400000 * offset);
  String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH mm ss").format(timestamp);
  return date;
}

void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

void serialEvent (Serial arduino)
{
  //get the ASCII strings:
  angleX = float(trim(arduino.readStringUntil('\t')));
  angleY = float(trim(arduino.readStringUntil('\t')));
  angleZ = float(trim(arduino.readStringUntil('\n')));
}

void guage(float r, float angle) {
  // Conver from Degree -> Rad
  angle = (angle-180)*(PI/180);
  // Convert Polar -> Cartesian
  float x = r * cos(angle);
  float y = r * sin(angle);

  arrow(0, 0, (int)x, (int)y);
}

void arrow(int x1, int y1, int x2, int y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 


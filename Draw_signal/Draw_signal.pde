float PI2= 6.283185;
int AMP =127;
int OFFSET= 128;
int REC_LENGTH= 256;
int LENGTH =256;
int[] wave_I=new int[LENGTH];
int[] wave_Q=new int[LENGTH];
import processing.serial.*;
float TC=50.0;
float x=exp(-1/TC);
float a=1-x;
float b=x;
float norm_max=700;
int linefeed = 10;      // linefeed in ASCII
Serial myPort;          // The serial port
float filter_out = 0;
float old_filter=0;// the value from the sensor
int graphPosition = 0;  // the horizontal position of the latest
  float prev_filter=0;                     // line to be drawn on the graph
int mix=0;

void setup() {
  size(800,700);
  background(0);
  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my Mac
  // is always my  Arduino, so I open Serial.list()[4].
  // Open whatever port is the one you're using (the output
  // of Serial.list() can help; the are listed in order
  // starting with the one that corresponds to [4]).


  // read bytes into a buffer until you get a linefeed (ASCII 10):

 myPort=new Serial(this, Serial.list()[4],9600);
 myPort.bufferUntil(linefeed);
 
 for (int i=0;i<LENGTH;i++){
    float REF_I=(AMP*cos(2*PI2/LENGTH*i));
    wave_I[i]=int(REF_I+OFFSET); //add offset to make positive
    float REF_Q=(AMP*sin(2*PI2/LENGTH*1));
    wave_Q[i]=int(REF_I+OFFSET);
  }
 println(x);
 println(a);
 println(b);
}

void draw (){

 
}

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil(linefeed);
  // if you got any bytes other than the linefeed:
  if (myString != null) {
    //trim off the carriage return and convert the string to an integer:
    signal = int(trim(myString));
    // print it;
    //println(mix);
   PSD();
  }
} 
void keyReleased()
    {
      if(key=='z'||key=='Z')
        {
          TC--;
          println(TC);
        }
      if(key=='x'||key=='X')
        {
        TC++;
        println(TC);
      }  
      if(key=='a'||key=='A')
      {
        norm_max=norm_max-10;
        println(norm_max);
      }
      if (key=='s'||key=='S')
      {
        norm_max=norm_max+10;
       
        println(norm_max);
      }
  
  }
void PSD(){
  x=exp(-1/TC);
  a=1-x;
  b=x;
  
   prev_filter=filter_out;
   //filter_out=mix;
//filter_out=a*mix+b*prev_filter;
 filter_out=map(a*mix+b*prev_filter,0,norm_max,0,height);
println(filter_out);
 //println(filter_out);
 drawGraph(); 
 // println(filter_out);
}
void drawGraph() {
  smooth();
  fill(20);
  stroke(0,255,100);
  strokeWeight(2);
//  beginShape(LINES);
//  
//    vertex(graphPosition-1, prev_filter);
//    vertex(graphPosition,filter_out);
//  endShape();
line(graphPosition-1,prev_filter,graphPosition, filter_out);
 if (graphPosition>=width)
 {
  graphPosition=0;
  background(0);
  } 
  else {
    
    graphPosition++;
  }
}

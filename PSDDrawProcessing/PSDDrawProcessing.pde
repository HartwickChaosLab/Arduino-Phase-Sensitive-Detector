// {PSDDrawProcessing.}
//    Copyright (C) {2014}  Kevin D. Schultz
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
import processing.serial.*;
float TC=200.0;
float x=exp(-1/TC);
float a=1-x;
float b=x;

int linefeed = 10;      // linefeed in ASCII
Serial myPort;          // The serial port
float filter_out = 0;
float old_filter=0;// the value from the sensor
int graphPosition = 0;  // the horizontal position of the latest
  float prev_filter=0;                     // line to be drawn on the graph
int mix[];
float mix_I;
float mix_Q;
PFont myFont;
int fontSize=18;
float phase;
int choice=0;
void setup() {
  size(512,256);
  background(0);
  // List all the available serial ports
  printArray(Serial.list());
 
  // I know that the first port in the serial list on my Mac
  // is always my  Arduino, so I open Serial.list()[4].
  // Open whatever port is the one you're using (the output
  // of Serial.list() can help; the are listed in order
  // starting with the one that corresponds to [4]).


  // read bytes into a buffer until you get a linefeed (ASCII 10):

 myPort=new Serial(this, Serial.list()[1],38400);
 myPort.bufferUntil('\n');
}


void serialEvent(Serial myPort) { 
  // read the serial buffer
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
    myString = trim(myString);
 
    // split the string at the commas
    // and convert the sections into integers:
    mix = int(split(myString, ','));
   
    
     PSD(choice);
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
      if(key=='i'||key=='I')
        {
          choice=1;
          
        }
      if(key=='m'||key=='M')
        {
          choice=0;
         
        }
      if(key=='p'||key=='P')
        {
          choice=3;
        }
        if(key=='q'||key=='Q')
        {
          choice=2;
          
        }
  
    } 
void PSD(int option){
  x=exp(-1/TC);
  a=1-x;
  b=x;
  
   mix_I = map(mix[0], 0,64000,height,0);
    println("mixI= "+mix_I);
      mix_Q = map(mix[1], 0,64000,height,0);
   
      if (mix[0]>0){
      phase=atan(1.*mix[0]/mix[1]);
      }
      else{phase=1.;}
      
  switch(option){
   case 0:
     prev_filter=filter_out;
     filter_out=a*sqrt(mix_I+mix_Q)+b*prev_filter;
     //println("mag");
     break;
    case 1:
      prev_filter=filter_out;
      filter_out=a*mix_I+b*prev_filter;
      //println("in phase");
      break;
    case 2:
      prev_filter=filter_out;
      filter_out=a*mix_Q+b*prev_filter;
      //println("Quadature");
      break;
    case 3:
      prev_filter=filter_out;
      filter_out=phase+b*prev_filter;
      //println("phase");
      break;
  }
     
  
 drawGraph();
 myPort.write("A"); 
 // println(filter_out);
}
void drawGraph() {
  smooth();
  fill(20);
  stroke(0,255,100);
  strokeWeight(2);

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

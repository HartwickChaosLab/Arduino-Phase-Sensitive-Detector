/*Get user input from keyboard and mouse
 Copyright (C) {2014}  Kevin D. Schultz
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

/*
 Modifyed by FLE 20220130
 Broken into tabs 20220130.

*/

void serialEvent(Serial myPort) { 
  // read the serial buffer
  myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);      // if you got any bytes other than the linefeed:
    gotString = true; 
  }// end not null
}// end serialEvent()

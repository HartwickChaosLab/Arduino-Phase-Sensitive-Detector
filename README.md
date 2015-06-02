Arduino-Phase-Sensitive-Detector
================================

Arduino and Processing Code GPLv3
Talk CC-BY-SA 4.0

To use this software:
  Download: PSDArduino.ino from the PSDArduino folder and load onto your Arduino
  Download: PSDDrawProcessing.pde from the PSDDrawProcessing folder onto your computer
  
With your arduino running PSDArduino and connected to your computer, run PSDDrawProcessing.pde in the Processing environment

To use the PSD follow PSD_schematic_phase_schem.pdf found in the PSD-Talk folder.

To test the PSD with a phase-shifting circuit follow PhaseShift.pdf in the PSD-Talk folder. The input of the ciruit is attached to the Arduino port supplying the reference signal, the output goes to the Arduino input grabbing the signal. The resistors in the inverting branch should be roughly equal to provide 1V/V gain. I used 10k resistors. The pot in the non-inverting branch was 10k and the capacitor was chosen to create a 90 degree phase shift at the reference frequency, which occurs at 1/(2*pi*R*C). The reference frequency is determined by the Arduino code by fr=(TCNT2 rate)/(OCR2A * wavetable length)

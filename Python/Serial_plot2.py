#!/usr/bin/env python

from threading import Thread
import serial
import time
import collections
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import struct
import pandas as pd
from os.path import exists
import numpy as np


class serialPlot:
    def __init__(self, serialPort = 'COM10', serialBaud = 115200, plotLength = 100, dataNumBytes = 2):
        self.port = serialPort
        self.baud = serialBaud
        self.plotMaxLength = plotLength
        self.dataNumBytes = dataNumBytes
        self.rawData = ""
        self.data0 = collections.deque([0.0] * plotLength, maxlen=plotLength)
        self.data1 = collections.deque([0.0] * plotLength, maxlen=plotLength)
        self.data2 = collections.deque([0.0] * plotLength, maxlen=plotLength)
        self.isRun = True
        self.isReceiving = False
        self.thread = None
        self.plotTimer = 0
        self.previousTimer = 0
        self.message = "sample"+'\n'
        
        filePathCount = 0
        while ( exists("Data\data"+str(filePathCount)+".txt") ): filePathCount += 1
        self.filePath = "Data\data"+str(filePathCount)+".txt"
        print('Stored data file path is: '+self.filePath)
        # self.csvData = []

        print('Trying to connect to: ' + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')
        try:
            self.serialConnection = serial.Serial(serialPort, serialBaud, timeout=4)
            print('Connected to ' + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')
            time.sleep(2)
            
        except:
            print("Failed to connect with " + str(serialPort) + ' at ' + str(serialBaud) + ' BAUD.')

    def readSerialStart(self):
        if self.thread == None:
            self.thread = Thread(target=self.backgroundThread)
            self.thread.start()
            # Block till we start receiving values
            while self.isReceiving != True:
                time.sleep(0.1)
                

    def getSerialData(self, frame, line0, line1, line2, lineLabel, timeText, avgText):
        if self.rawData == "" :
            return
        temp = self.rawData.split(',')
        currents = [float(temp[0]),float(temp[1]),float(temp[2])]
        timestamp = (float(temp[3])*500)/1000

        currentTimer = timestamp
        self.plotTimer = currentTimer - self.previousTimer    # the first reading will be erroneous
        self.previousTimer = timestamp
        
        # we get the latest data point and append it to our array and calibrate for indevidual sensors
        self.data0.append(currents[0] * 0.98) #black
        self.data1.append(currents[1] * 0.93) #brown
        self.data2.append(currents[2] * 0.90) #red
        
        #apply average 
        nextCurrent0 = np.mean(self.data0)
        nextCurrent1 = np.mean(self.data1)
        nextCurrent2 = np.mean(self.data2)
        
        timeText.set_text('Plot Interval = ' + str(self.plotTimer) + 'ms')
        avgText.set_text('Bk: '+"{:.2f}".format(nextCurrent0)+', Br: '+"{:.2f}".format(nextCurrent1)+', Rd: '+"{:.2f}".format(nextCurrent2))
        
        line0.set_data(range(self.plotMaxLength), self.data0)
        line1.set_data(range(self.plotMaxLength), self.data1)
        line2.set_data(range(self.plotMaxLength), self.data2)
        # self.csvData.append(self.data0[-1])

    def backgroundThread(self):    # retrieve data
        time.sleep(1.0)  # give some buffer time for retrieving data
        self.serialConnection.reset_input_buffer()
        while (self.isRun):
            self.serialConnection.write(bytes(self.message, 'utf-8'))
            time.sleep(0.1)
            ret = True
            data = ""
            timeout = 0
            while ret or timeout>5:
                temp = self.serialConnection.read().decode("utf-8")
                if temp == '\n':
                    ret = False
                elif temp == '' :
                    timeout += 1
                elif not temp == '\r':
                    data += temp
            if timeout>5 :
                print("Response timeout!")
                return
            self.rawData = data
            self.isReceiving = True
            time.sleep(0.1)
            #write data to file for storage
            file = open(self.filePath, "a")
            file.write(self.rawData+"\n")
            file.close()
            #print(self.rawData)

    def close(self):
        self.isRun = False
        self.thread.join()
        self.serialConnection.close()
        print('Disconnected...')
        # df = pd.DataFrame(self.csvData)
        # df.to_csv('/home/rikisenia/Desktop/data.csv')


def main():
    # portName = 'COM5'     # for windows users
    portName = 'COM5'
    baudRate = 115200
    maxPlotLength = 1000
    dataNumBytes = 4        # number of bytes of 1 data point
    s = serialPlot(portName, baudRate, maxPlotLength, dataNumBytes)   # initializes all required variables
    s.readSerialStart()                                               # starts background thread

    # plotting starts below
    pltInterval = 50    # Period at which the plot animation updates [ms]
    xmin = 0
    xmax = maxPlotLength
    ymin = -1
    ymax = 5
    fig = plt.figure()
    ax = plt.axes(xlim=(xmin, xmax), ylim=(float(ymin - (ymax - ymin) / 10), float(ymax + (ymax - ymin) / 10)))
    ax.set_title('Stimulation Sensing Over Time')
    ax.set_xlabel("time (ms)")
    ax.set_ylabel("Current (mA)")

    lineLabel = 'Current Values'
    timeText = ax.text(0.50, 0.95, '', transform=ax.transAxes)
    avgText = ax.text(0.50, 0.9, '', transform=ax.transAxes)
    line0 = ax.plot([], [], label='Sensor Black', color='k')[0]
    line1 = ax.plot([], [], label='Sensor Brown', color='brown')[0]
    line2 = ax.plot([], [], label='Sensor Red', color='r')[0]
    anim = animation.FuncAnimation(fig, s.getSerialData, fargs=(line0, line1, line2, lineLabel, timeText, avgText), interval=pltInterval)    # fargs has to be a tuple

    plt.legend(loc="upper left")
    plt.show()

    s.close()


if __name__ == '__main__':
    main()
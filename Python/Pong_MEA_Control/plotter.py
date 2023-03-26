#!/usr/bin/env python

from threading import Thread
import serial
import time
import collections
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import struct
import pandas as pd
import config
from os.path import exists
from datetime import date
import numpy as np;

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
        
        #moving average
        avgWind = 5
        self.data0Stack = collections.deque([0.0] * avgWind, maxlen=avgWind)
        self.data1Stack = collections.deque([0.0] * avgWind, maxlen=avgWind)
        self.data2Stack = collections.deque([0.0] * avgWind, maxlen=avgWind)
        
        #setup file path
        filePathCount = 0
        while ( exists("Data\senseData_"+str(date.today())+"_"+str(filePathCount)+".txt") ): filePathCount += 1
        self.filePath = "Data\senseData_"+str(date.today())+"_"+str(filePathCount)+".txt"
        print('Stored sense data file path is: '+self.filePath)
        
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
                

    def getSerialData(self, frame, line0, line1, line2, lineLabel, timeText, avgText, timeTotalText):
        if self.rawData == "" :
            return
        temp = self.rawData.split(',')
        currents = [float(temp[0]),float(temp[1]),float(temp[2])]
        timestamp = float(temp[3])

        currentTimer = timestamp
        self.plotTimer = currentTimer - self.previousTimer    # the first reading will be erroneous
        self.previousTimer = timestamp
        
        #moving window
        self.data0Stack.append(currents[0])
        self.data1Stack.append(currents[1])
        self.data2Stack.append(currents[2])
        
        #apply moving average and calibrate for indevidual sensors
        nextCurrent0 = np.mean(self.data0Stack) * 0.98 #black
        nextCurrent1 = np.mean(self.data1Stack) * 0.93 #brown
        nextCurrent2 = np.mean(self.data2Stack) * 0.90 #red
        
        # we get the latest moving average data point and append it to our array
        self.data0.append(nextCurrent0)
        self.data1.append(nextCurrent1)
        self.data2.append(nextCurrent2)
        
        config.SenseQ = "{:.2f}".format(nextCurrent0)+','+"{:.2f}".format(nextCurrent1)+','+"{:.2f}".format(nextCurrent2)+','+str(temp[3])
        
        timeText.set_text('Plot Interval = ' + str(self.plotTimer) + 'ms')
        avgText.set_text('Bk: '+"{:.2f}".format(np.mean(self.data0))+', Br: '+"{:.2f}".format(np.mean(self.data1))+', Rd: '+"{:.2f}".format(np.mean(self.data2)))
        timeTotalText.set_text('Time = ' + "{:.2f}".format(timestamp/1000) + 's')
        

        line0.set_data(range(self.plotMaxLength), self.data0)
        line1.set_data(range(self.plotMaxLength), self.data1)
        line2.set_data(range(self.plotMaxLength), self.data2)
        # self.csvData.append(self.data0[-1])

    def backgroundThread(self):    # retrieve data
        time.sleep(1.0)  # give some buffer time for retrieving data
        self.serialConnection.reset_input_buffer()
        while (self.isRun):
            self.message = config.RelayQ +'\n'
            #print("Sending: " + config.RelayQ)
            self.serialConnection.write(bytes(self.message, 'utf-8'))
            #print(self.message)
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
                print("Serial response timeout!")
                return
            self.rawData = data
            #config.SenseQ = data
            #print("Receving: " + data)
            self.isReceiving = True
            
            time.sleep(0.1)
            #write data to file for storage
            file = open(self.filePath, "a")
            file.write(config.RelayQ+':'+self.rawData+"\n")
            file.close()
            #print(self.rawData)

    def close(self):
        self.isRun = False
        self.thread.join()
        self.serialConnection.write(bytes('0,0,0,0,0,0'+'\n', 'utf-8'))
        self.serialConnection.close()
        print('Disconnected Serial...')
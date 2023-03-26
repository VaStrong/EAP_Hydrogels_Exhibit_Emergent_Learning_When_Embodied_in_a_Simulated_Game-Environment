from threading import Thread
from pong import Pong
from plotter import serialPlot
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import time
import time
from screen_recorder_sdk import screen_recorder
from os.path import exists
from datetime import date
import numpy


def main():
    portName = 'COM5'#5
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
    timeTotalText = ax.text(0.50, 0.85, '', transform=ax.transAxes)
    line0 = ax.plot([], [], label='Sensor Black', color='k')[0]
    line1 = ax.plot([], [], label='Sensor Brown', color='brown')[0]
    line2 = ax.plot([], [], label='Sensor Red', color='r')[0]
    anim = animation.FuncAnimation(fig, s.getSerialData, fargs=(line0, line1, line2, lineLabel, timeText, avgText, timeTotalText), interval=pltInterval)    # fargs has to be a tuple

    plt.legend(loc="upper left")
    
    #setup and run the pong thread
    pong = Pong((1000, 1000))
    gameThread = Thread(target=pong.gameLoop)
    gameThread.start()
    
    #setup file path
    filePathCount = 0
    while ( exists("Data\pongVideo_"+str(date.today())+"_"+str(filePathCount)+".mp4") ): filePathCount += 1
    filePath = "Data\pongVideo_"+str(date.today())+"_"+str(filePathCount)+".mp4"
    print('Stored video file path is: '+filePath)
    
    #start video recording
    #screen_recorder.enable_dev_log()
    params = screen_recorder.RecorderParams()
    screen_recorder.init_resources (params)
    screen_recorder.start_video_recording (filePath, 30, 8000000, True)
    
    #open the plot
    plt.show()
    
    #stop video recording close the serial and pong thread once the plot is closed
    screen_recorder.stop_video_recording()
    screen_recorder.free_resources()
    
    s.close()
    pong.close()
    gameThread.join()
    sys.exit()
    
if __name__ == '__main__':
    main()

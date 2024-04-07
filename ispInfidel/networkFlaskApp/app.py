from flask import Flask, render_template

app = Flask(__name__)
historicSpeedD = []
historicSpeedU = []

@app.route("/")
def hello_world():
    lines = []
    with open('output.txt','r') as f:
        lines = f.readlines()

    date=lines[0]
    uname=lines[1]

    outputMap = {}
    serverMap = {}
    clientMap = {}
    serverCoords = []
    clientCoords = []
    chunkName = ""
    for line in lines[2:]:
        splitLine = line.split('\t')
        if(len(splitLine) == 3):
            if(chunkName == "server"):
                serverMap[splitLine[1]] = splitLine[2].strip()
                if(splitLine[1] == "lat" or splitLine[1] == "lon"):
                    serverCoords.append(splitLine[2].strip())
            elif(chunkName == "client"):
                clientMap[splitLine[1]] = splitLine[2].strip()
                if(splitLine[1] == "lat" or splitLine[1] == "lon"):
                    clientCoords.append(splitLine[2].strip())
        elif(len(splitLine) == 2):
            if(splitLine[0] == "download" or splitLine[0] == "upload"):
                splitLine[1] = splitLine[1].strip()
                tmp = str(float(splitLine[1]) / 1000000.0 )
                splitLine[1] = tmp
                outputMap[splitLine[0]] = splitLine[1]
                if(splitLine[0] == "download"):
                    historicSpeedD.append(float(tmp))
                elif(splitLine[0] == "upload"):
                    historicSpeedU.append(float(tmp))
            else:
                outputMap[splitLine[0]] = splitLine[1].strip()
        elif(len(splitLine) == 1):
            chunkName = splitLine[0].strip()
            #printStr = printStr + "<h2>" + splitLine[0] + "</h2>"
    #return (printStr)
    if(len(historicSpeedD) >= 15):
        historicSpeedD.pop(0)

    if(len(historicSpeedU) >= 15):
        historicSpeedU.pop(0)

    print(historicSpeedD)
    print(historicSpeedU)
    return render_template('home.html',
        date=date,
        uname=uname,
        outputMap=outputMap,
        clientMap=clientMap,
        serverMap=serverMap,
        downL=historicSpeedD,
        upL=historicSpeedU,
        hrL=[x for x in range(0,14)],
        serverCoords=serverCoords,
        clientCoords=clientCoords)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9090, debug=True)

# Python 3
import random

class lineData(object):
        def __init__(self, uniqueID=None, speakerID=None, content=[], linkTos=[], commands=[]):
                self.uniqueID = int(uniqueID)
                self.speakerID = speakerID.rstrip().lstrip()
                self.content = content.rstrip().lstrip().split("/")
                self.linkTos = linkTos.rstrip().lstrip().split("/")
                self.commands = commands.rstrip().lstrip().split("/")

                self.endNow = False

        def giveContent(self, printIt=False):
                # Print or return the content of line. If options, randomly pick
                optionNum = len(self.content)
                if printIt:
                        print(self.content[random.randint(0, optionNum-1)])
                else:
                        return self.content[random.randint(0, optionNum-1)]

        def giveReplyOptions(self):
                # Print all reply options, format as numbered replies
                optionCounter = 1
                outputArrayOfObjects = []
                for i in self.linkTos:
                        replyStatement = self.compareAndFinder(i, lineObjects).giveContent()
                        print(str(optionCounter) + ') ' + replyStatement)
                        outputArrayOfObjects.append(self.compareAndFinder(i, lineObjects))
                        optionCounter += 1
                return outputArrayOfObjects

        def findBySpeakerID(self, given):
                # Returns true if SpeakerID matches "given"
                if self.speakerID == given:
                        return True, self
                else:
                        return False, 0

        def compareAndFinder(self, key, listObject, findWhat='speakerID'):
                # Iterates over list of objects to return matching object
                for i in listObject:
                        if i.findBySpeakerID(key)[0]:
                                return i.findBySpeakerID(key)[1]

        def checkCommands(self):
                # Check for commands. Currently only the end functionality is included
                if 'END' in self.commands:
                        self.endNow = True
                # self.endNow = True



class convoController(object):
        def __init__(self):
                # Helper to begin conversation
                self.convoRunning = True
                self.switchCurrentObject(lineObjects[0])

                # Do first line
                print('Niklas says:', self.currentObject.giveContent())
                # Read first line nexts in
                self.nextUps = self.currentObject.giveReplyOptions()      


        def continueConversation(self, nextUp):
                # Helper to move on to the next statement
                # nextUps actually gives the line the player says
                # so we need to move on to the one that the player statement links to
                self.switchCurrentObject(self.nextUps[int(nextUp) - 1])
                if self.currentObject.endNow is True:
                        self.endConversation()
                else:
                        print('You said:', self.currentObject.giveContent(printIt=False))
                        # This is the reply that comes back
                        self.switchCurrentObject(self.currentObject.compareAndFinder(self.currentObject.linkTos[0], lineObjects))
                        if self.currentObject.endNow is True:
                                self.endConversation()
                        else:
                                print('Niklas says:', self.currentObject.giveContent())
                                # Read next line nexts in
                                self.nextUps = self.currentObject.giveReplyOptions()    

        def endConversation(self):
                # Helper to end the conversation
                self.convoRunning = False
                if self.currentObject.speakerID[0] == "0":
                        print('Niklas says:', self.currentObject.giveContent())
                else:
                        print('You said:', self.currentObject.giveContent())
                print('END')

        def takeNumericalUserInput(self):
                # Helper to take validated user input
                inputAccepted = False
                upperLimit = len(self.currentObject.linkTos)
                while not inputAccepted:
                        userInput = input('>> ')
                        try:
                                userInput = int(userInput)
                        except ValueError:
                                pass
                        if (type(userInput) == int) and (userInput >= 0) and (userInput <= upperLimit):
                                inputAccepted = True
                                return userInput
                        else:
                                print('Bad input try again')

        def switchCurrentObject(self, new):
                # Helper to switch the current object and execute all necessary code then
                self.currentObject = new
                self.currentObject.checkCommands()
                return 1


lineObjects = []

with open('testchat', "r") as infile:
        # Read the testchat files into the program
        for line in infile:
                info = line.split("|")
                currObj = lineData(info[0], info[1], info[2], info[3], info[4])
                lineObjects.append(currObj)

convoController = convoController()
while convoController.convoRunning:
        nextOne = convoController.takeNumericalUserInput()
        convoController.continueConversation(nextOne)
        
        # convoController.endConversation()

                        

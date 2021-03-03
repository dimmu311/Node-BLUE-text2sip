# Node-BLUE-text2sip
a small collection to make text2sip call with node blue

to use this do the following steps:
- install ttspico and sox
    `sudo apt-get install libttspico-utils sox`
- install sipcmd
**NOTE**
**you have to use modified version from Woersty. He added some code to get the DTMF-Code entered at the phone. maybe you need to install some dependencies first. see the reedme.**
```
sudo git clone https://github.com/Woersty/sipcmd.git
sudo cd sipcmd
sudo make
sudo cp sipcmd /bin/sipcmd
```
- download text2sip.sh from this repository.
- make text2sip.sh excutable
- import flow.json to node blue
- setup a sipproxy
- in node blue edit config text2sip node to fit to your setup. See the informations at the bottom.
- in node blue edit text2sip node to the path where text2sip.sh is located.

thats it.

some info about config text2sip:
there must be the following fields like in this example. After the END command there must be a new Line. The Comments in this Example are only for Explanation.
```
CALLING_USER_NUMBER=homegear //the user or number to registrate with at the sipproxy
CALLING_USER_PASSWORD=1234abcd5678 //the passwort to registrate with at the sipproxy
SIP_PROXY=192.168.1.1 //the ip address of the sipproxy
CALLED_USER=11  //the phone number to call
PAUSE_BEFORE=10000  //time to wait bevor tts is played after answering the call
PAUSE_AFTER=30000 //time to wait after tts was played till call gets rejected
CALL_TIMEOUT=60 //call timeout
LANGUAGE=de-DE  //language for tts. see ttspico for more details
MESSAGE="some Text" //the message that should be played
END // shows that config is done
       //new line must be there
```

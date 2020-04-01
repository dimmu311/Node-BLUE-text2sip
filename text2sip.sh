#!/bin/bash
IFS="="
while read -r name value
do
        case $name in
                "MESSAGE") MESSAGE="${value//\"/}";;
                "LANGUAGE") LANGUAGE="${value//\"/}";;
                "CALLING_USER_NUMBER") CALLING_USER_NUMBER="${value//\"/}";;
                "CALLING_USER_PASSWORD") CALLING_USER_PASSWORD="${value//\"/}";;
                "SIP_PROXY") SIP_PROXY="${value//\"/}";;
                "CALLED_USER") CALLED_USER="${value//\"/}";;
                "PAUSE_BEFORE") PAUSE_BEFORE="${value//\"/}";;
                "PAUSE_AFTER") CALL_PAUSE_AFTER_GUIDE="${value//\"/}";;
                "CALL_TIMEOUT") CALL_TIMEOUT="${value//\"/}";;
				"END") break;;
                *) echo "unknow command";;
        esac
done

echo "generate wav File in Language $LANGUAGE";
pico2wave -l $LANGUAGE -w "/tmp/myTextMessage.wav" "$MESSAGE";
echo "convert wav to new Format";
sox "/tmp/myTextMessage.wav" -t wav -b 16 -r 8000 "/tmp/myNewTextMessage.wav";
rm "/tmp/myTextMessage.wav";
echo "try calling"

append=false;
code="";
sipcmd -m "G.711*" -T "$CALL_TIMEOUT" -P sip -u "$CALLING_USER_NUMBER" -c "$CALLING_USER_PASSWORD" -w "$SIP_PROXY" -x "c$CALLED_USER;w$PAUSE_BEFORE;v/tmp/myNewTextMessage.wav;w$CALL_PAUSE_AFTER_GUIDE;" |while read DTMF_LINE;
do
	DTMF_CODE=`echo $DTMF_LINE |grep "receive DTMF:"|cut -c16`;
	#echo "DTMF_CODE=$DTMF_CODE";
	case $DTMF_CODE in
		"#")
			echo "DTMF_CODE=$DMF_CODE";
			append=true;
			code="${code}$DTMF_CODE";
			echo "WHOLE_DTMF_CODE=$code";;
		"*")
			echo "DTMF_CODE=$DTMF_CODE"
			append=false;
			code="${code}$DTMF_CODE";
			echo "WHOLE_DTMF_CODE=$code";
			echo "FINISHED_DTMF_CODE=$code";;
		[1234567890])
			echo "DTMF_CODE=$DTMF_CODE";
			if $append; then
				code="${code}$DTMF_CODE";
				echo "WHOLE_DTMF_CODE=$code";
			fi;;
	esac
done
rm "/tmp/myNewTextMessage.wav"

#!/bin/bash

function usage () {
    echo "usage: stream-wrecker.sh -i <u3m8 address>"
}

while getopts "i:" opt; do
    case $opt in

        i)
            u3m8=$OPTARG
            echo "u3m8 address: ${OPTARG}" >&2
            ;;
        \?)
            echo "ERROR: Invalid option: -${OPTARG}" >&2
            usage
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
            exit
            ;;
    esac
done

if [ "$OPTIND" -eq 1 ]; then
    echo "No options were passed EXITING";
fi

shift $((OPTIND-1))

outputPath="$HOME/Videos/"

streamName=$(echo "$u3m8" | grep -oP 'amlst:\K[^-]*')
outputFile="$outputPath${streamName}_$(date +"%d_%m_%Y-%H-%M-%S").mkv"

watch -n2 ffmpeg -i "$u3m8" -c copy -bsf:a aac_adtstoasc "$outputFile" > /dev/null 2>&1 < /dev/null

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
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

if [ "$OPTIND" -eq 1 ]; then
    echo "No options were passed. EXITING";
    usage
    exit 1
fi

shift $((OPTIND-1))

OUTPUTDIR="/mnt/Crucial2TB/.Videos"

[ -d "$OUTPUTDIR" ] && mkdir -p "$OUTPUTDIR"

# Extract username from the URL (adjust pattern as needed for your case)
username=$(echo "$u3m8" | grep -oP 'amlst:\K[^-]*')
if [ -z "$username" ]; then
    exit 1
fi

while true; do
    OUTPUT="${username}_$(date +"%d_%m_%Y-%H-%M-%S")"
    outputFile="$OUTPUTDIR/$OUTPUT.mkv"

    ffmpeg -i "$u3m8" -c copy -bsf:a aac_adtstoasc "$outputFile" > /dev/null 2>&1 < /dev/null

    echo "Stream not interrupted. Retrying in 5 seconds..."
    sleep 5
done


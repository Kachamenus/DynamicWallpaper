#!/bin/bash

# Directory containing your images
IMAGE_DIR="/home/alex/Nextcloud/Photos/minecraftwallpaper"
IMAGES=("$IMAGE_DIR"/*.png)

# Ensure exactly 24 images exist
if [ ${#IMAGES[@]} -ne 24 ]; then
    echo "Error: You need exactly 24 images in the directory $IMAGE_DIR."
    exit 1
fi

# Latitude and Longitude for your location
LATITUDE="49.2414"
LONGITUDE="-123.1422"

# Fetch sunrise and sunset times
API_RESPONSE=$(curl -s "https://api.sunrise-sunset.org/json?lat=$LATITUDE&lng=$LONGITUDE&date=today&tzid=America/Vancouver&formatted=0")
SUNRISE=$(echo $API_RESPONSE | jq -r '.results.sunrise')
SUNSET=$(echo $API_RESPONSE | jq -r '.results.sunset')

echo Sunrise: $SUNRISE
echo Sunset: $SUNSET

# Convert times to seconds since epoch
SUNRISE_SECONDS=$(date -d "$SUNRISE" +%s)
echo $SUNRISE_SECONDS

SUNSET_SECONDS=$(date -d "$SUNSET" +%s)
echo $SUNSET_SECONDS

SUNRISE_MINUTES=$((SUNRISE_SECONDS / 60))

echo Sunrise Minutes after epoch: $SUNRISE_MINUTES

SUNSET_MINUTES=$((SUNSET_SECONDS / 60))

echo Sunset Minutes: $SUNSET_MINUTES

NOW=$(date +%s)

# Calculate intervals
DAY_DURATION=$((SUNSET_MINUTES - SUNRISE_MINUTES))
echo DAY_DURATION : $DAY_DURATION

NIGHT_DURATION=$((1440 - DAY_DURATION))
echo NIGHT_DURATION : $NIGHT_DURATION

DAY_INTERVAL=$((DAY_DURATION / 12))
echo DAY_INTERVAL: $DAY_INTERVAL

NIGHT_INTERVAL=$((NIGHT_DURATION / 12))
echo NIGHT_INTERVAL: $NIGHT_INTERVAL

if [ $NOW -ge $SUNRISE_SECONDS ] && [ $NOW -lt $SUNSET_SECONDS ]; then
    # It's daytime
    DAY_DURATION=$((SUNSET_SECONDS - SUNRISE_SECONDS))
    DAY_INTERVAL=$((DAY_DURATION / 12))

    # Calculate which daytime image to use
    IMAGE_INDEX=$(((NOW - SUNRISE_SECONDS) / DAY_INTERVAL))
else
    # It's nighttime
    NIGHT_DURATION=$((86400 - (SUNSET_SECONDS - SUNRISE_SECONDS)))
    NIGHT_INTERVAL=$((NIGHT_DURATION / 12))

    if [ $NOW -lt $SUNRISE_SECONDS ]; then
        # Before sunrise (early morning)
        TIME_SINCE_MIDNIGHT=$((NOW - $(date -d "00:00:00" +%s)))
        IMAGE_INDEX=$((12 + TIME_SINCE_MIDNIGHT / NIGHT_INTERVAL))
    else
        # After sunset (evening)
        TIME_SINCE_SUNSET=$((NOW - SUNSET_SECONDS))
        IMAGE_INDEX=$((12 + TIME_SINCE_SUNSET / NIGHT_INTERVAL))
    fi
fi

echo Image Index $IMAGE_INDEX.

DISPLAY=:0 feh --bg-scale $IMAGE_DIR/$IMAGE_INDEX.png 

#echo Daytime:
## Set daytime images
#for i in {0..11}; do
#    IMAGE="${IMAGES[$i]}"
#    TIME=$(((SUNRISE_SECONDS - NOW) / 60 + i * DAY_INTERVAL))
#    feh --bg-scale $IMAGE_DIR/$i.png | at now +$TIME minutes
#done
#
#echo Nighttime: 
## Set nighttime images
#for i in {12..23}; do
#    IMAGE="${IMAGES[$i]}"
#    TIME=$(((SUNSET_SECONDS - NOW) / 60 + (i - 11) * NIGHT_INTERVAL))
#    # Handle wrapping to the next day
#    if [ $TIME -ge $(date -d "tomorrow 00:00:00" +%s) ]; then
#        TIME=$((TIME - 1440))
#    fi
#    feh --bg-scale $IMAGE_DIR/$i.png | at now +$TIME minutes
#done




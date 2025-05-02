DIRNAME="datasets"
URL1="https://github.com/ddantas/visiongl_images/raw/refs/heads/master/mitosis.zipX"
URL2="https://imagej.net/ij/images/5d.zip"
FILENAME="mitosis.zip"
ERROR=1


echo "This script tries to download the image dataset from URL
$URL1

In case of error, tries from URL
$URL2


If successful, there will be 336 TIF images in folder \"$DIRNAME\" with names

mitosis-5d0000.tif
mitosis-5d0001.tif
...
mitosis-5d0334.tif
mitosis-5d0335.tif
"

if [ -d $DIRNAME ]; then
  #echo "File $FILE exists."
  :
else
  #echo "File $FILE does not exist."
  mkdir $DIRNAME  
fi

cd $DIRNAME

wget_output=$(wget -q "$URL1" -O $FILENAME)
if [ $? -ne 0 ]; then
  echo "Error downloading from $URL1"
  echo "Trying $URL2"
else
  ERROR=0
  echo "Unzipping..."
  unzip -j $FILENAME
  rm $FILENAME
fi

if [ $ERROR -ne 0 ]; then
  wget_output=$(wget -q "$URL2" -O $FILENAME)
  if [ $? -ne 0 ]; then
    echo "Error downloading from $URL2"
  else
    echo "Unzipping..."
    unzip -j $FILENAME
    rm $FILENAME
    convert mitosis-5d.tif[0-355] mitosis-5d%04d.tif
    rm mitosis-5d.tif
  fi
fi

cd ..

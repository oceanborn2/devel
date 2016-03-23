#!/bin/bash

for file in *.bmp;
do
	convert $file $file.png
done


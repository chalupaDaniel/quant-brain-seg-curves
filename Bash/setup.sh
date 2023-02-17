#!/bin/sh

mkdir ../ext
cd ../ext

# TODO: use sparse checkout once that git version is everywhere (v2.25)
git clone https://github.com/freesurfer/freesurfer.git --depth 1

wget http://www.eos.ubc.ca/~rich/m_map1.4.tar.gz
tar -xf m_map1.4.tar.gz
rm m_map1.4.tar.gz
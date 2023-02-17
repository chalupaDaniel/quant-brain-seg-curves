#! /bin/bash
# This takes a csv file as and input and writes a csv file with existing data

data_root=/mnt/e/ADNI/MPRAGE
image_type=MPRAGE

while IFS="," read -r image_id subject_id date sex
do
    filemask=$data_root/$subject_id*/$image_type/$date*/
    existing_file=$(find $filemask -name *.nii.gz)
    if [[ -z "$existing_file" ]]; then
        echo "$existing_file no bueno!"
    else
        echo "${image_id},${subject_id},${date},${sex}" >> $2
        echo "$existing_file exists!"
    fi
done < $1
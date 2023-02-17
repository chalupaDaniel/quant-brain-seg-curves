#! /bin/bash

data_root=/mnt/e/ADNI/MPRAGE
image_type=MPRAGE

thread_array=()

while IFS="," read -r image_id subject_id date sex
do
    filemask=$data_root/$subject_id*/$image_type/$date*/*.nii*
    existing_file=$(find $filemask -name *.nii.gz)
    if [[ -z "$existing_file" ]]; then
        echo "$existing_file no bueno!"
    else
        while [ $(jobs -r | wc -l) -ge 4 ]; do
            sleep 10
        done

        ( recon-all -all -threads 4 -openmp 4 -parallel -s "${subject_id}_${date}" -i $existing_file && echo "$existing_file" >> $2 ) &
        thread_array+=($!)
    fi
done < $1

for pid in "${thread_array[@]}"; do
  wait $pid
done
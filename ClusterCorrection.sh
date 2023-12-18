#!/bin/bash


homedir='{/Path/Directory}'
znum='2' ##number of contrasts
cdt="3.3" ##cluster defining threshold / voxel-wise uncorrected threshold
df="599" ##degrees of freedom




cd ${homedir}
	
		for i in $( seq 1 ${znum}); do

			out=$(smoothest -d "${df}" -r "res4d.nii.gz" -m "/u/project/lucina/shared/Final_data/AllResampled_GreyMask_02_91x109x91.nii")
			echo $out
			vol=$(echo $out | awk {'print $4'})
			dlh=$(echo $out | awk {'print $2'})
			echo $vol
			echo $dlh

			cluster --in="zstat${i}.nii.gz" --volume="${vol}" --dlh="${dlh}" --thresh="${cdt}" \
            			    --pthresh=0.05 -o "zstat${i}_thr${cdt}.nii.gz"

		done
	
fslmaths zstat1_thr3.3.nii.gz -add zstat2_thr3.3.nii.gz clustermasked.nii.gz 

fslmaths zstat1.nii.gz -mas clustermasked.nii.gz zstats_clustermasked.nii.gz
		
	done
done


  

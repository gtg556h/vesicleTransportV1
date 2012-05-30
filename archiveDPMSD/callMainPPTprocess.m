%% Call and save mainPPTprocessFunc....

cd /home/brian/data1/projects/vesicleTransport/experiment/040512_Aplysia_data
	
filename{1} = '2_00min_control_pdms_200fps_data.mat'
filename{2} = '2_00min_control_pdms_200fps_1_data.mat'
filename{3} = '2_00min_control_pdms_200fps_1_data.mat'
filename{4} = '2_02min_compress20_pdms_200fps_data.mat'
filename{5} = '2_05min_compress20_pdms_200fps_data.mat'
filename{6} = '2_10min_compress20_pdms_200fps_data.mat'
filename{7} = '2_20min_compress20_pdms_200fps_data.mat'
filename{8} = '2_30min_compress20_pdms_200fps_data.mat'
filename{9} = '2_38min_compress0_pdms_200fps_data.mat'
filename{10} = '2_40min_compress0_pdms_200fps_data.mat'
filename{11} = '2_50min_compress0_pdms_200fps_data.mat'
filename{12} = '2_60min_compress0_pdms_200fps_data.mat'
filename{13} = '2_70min_compress0_pdms_200fps_data.mat'
filename{14} = '2_80min_compress0_pdms_200fps_data.mat'
filename{15} = '2_90min_compress0_pdms_200fps_data.mat'
filename{16} = '2_100min_compress0_pdms_200fps_data.mat'
filename{17} = '2_110min_compress0_pdms_200fps_data.mat'


for ii = 1:length(filename)
	load(filename{ii})
	[nParticles, pData, xPos, yPos, radius] = mainPPTprocessFunc(dataPPT);
	lengthStr = length(filename{ii});
	fileShort = filename{ii}(1:(lengthStr-8));
	cd ..
	cd ..
	cd extractedData/040512_Aplysia_extracted
	save(strcat(fileShort, 'extrac.mat'))
	cd ..
	cd ..
	cd experiment/040512_Aplysia_data
	clear nParticles pData xPos yPos radius lengthStr fileShort
end


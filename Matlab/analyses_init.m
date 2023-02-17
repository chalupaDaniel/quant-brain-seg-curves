%% Subjects

CNList = sort(["068_S_0210"; "002_S_4262"; "116_S_4855"; "073_S_4559"; "014_S_4401"
          "035_S_4464"; "035_S_0156"; "137_S_4587"; "073_S_4552"; "941_S_4376"
          "068_S_0473"; "137_S_4520"; "010_S_4345"; "012_S_4545"; "137_S_4466"
          "009_S_4388"; "006_S_4485"; "022_S_4291"; "023_S_4164"; "037_S_4410"
          "100_S_0069"; "033_S_4179"; "006_S_4357"; "114_S_0416"; "130_S_0969"
          "022_S_4320"; "011_S_0021"; "011_S_4278"; "002_S_4262"; "041_S_4200"
          "153_S_4151"; "037_S_0454"; "023_S_4020"; "018_S_0055"; "037_S_0467"
          "002_S_0413"; "041_S_4060"; "018_S_4313"; "037_S_4028"; "100_S_1286"
]);

ADList = sort(["023_S_4501"; "130_S_4641"; "135_S_4676"; "130_S_4660"; "018_S_4696"
          "019_S_4477"; "053_S_5070"; "051_S_5005"; "019_S_5019"; "130_S_4982"
          "006_S_4867"; "130_S_4984"; "067_S_5205"; "116_S_4195"; "024_S_4905"
          "036_S_5210"; "036_S_4894"; "009_S_5037"; "130_S_5059"; "135_S_5275"
          "036_S_5112"; "037_S_4770"; "011_S_4845"; "130_S_5231"; "067_S_5205"
          "053_S_5208"; "130_S_4730"; "067_S_4728"; "009_S_5027"; "130_S_5006"
          "068_S_5146"; "130_S_5059"
]);

MCIList = sort(["041_S_0679"; "041_S_1418"; "037_S_0150"; "100_S_0296"; "037_S_1078"
           "141_S_1052"; "137_S_0994"; "009_S_1030"; "137_S_0800"; "137_S_0668"
           "137_S_1414"; "037_S_0501"; "037_S_0150"; "035_S_0292"; "073_S_0746"
           "037_S_0377"; "003_S_1122"; "053_S_0919"; "137_S_0800"; "023_S_0887"
           "137_S_1414"; "041_S_0679"; "023_S_0331"; "037_S_0501"; "023_S_0126"
           "013_S_1186"; "018_S_0142"; "016_S_1326"; "003_S_0908"; "141_S_1052"
           "037_S_1078"; "023_S_0042"; "141_S_1004"; "023_S_0887"; "051_S_1072"
           "051_S_1331"; "137_S_0800"; "137_S_0668"; "137_S_1414"; "002_S_0729"
]);

warning("================================HARDCODE ALERT==============================")
warning("Beware that everything expects folders in ../../data/subjects/{CN,AD,MCI} to follow the lists in analyses_init.m")

%% Labels
dataLabels = ["Curvature" "Area" "Volume" "Labels"];
segTypeLabelsShort = ["P", "N"];
segTypeLabels = ["Positive Curvature", "Negative Curvature"];
hemisphereLabels = ["R", "L"];
distributionLabels = ["normal","lognormal","GeneralizedPareto","weibull"];
modelLabels = [ "Gauss6", "Gauss5", "Gauss4", "Gauss3", "Gauss2", "Poly9", "Poly8", "Poly7", "Poly6", "Poly5", "Poly4", "Poly3", "Fourier8", "Fourier7", "Fourier6", "Fourier5", "Fourier4", "Fourier3", "Weibull" ];
featureLabels = [ "Sum", "Px cnt", "Mean", "Std dev", "Median"];

annotationLabels = [ "unknown", "bankssts", "caudalanteriorcingulate", "caudalmiddlefrontal", "corpuscallosum", ...
 "cuneus", "entorhinal", "fusiform", "inferiorparietal", "inferiortemporal", "isthmuscingulate", "lateraloccipital", ...
 "lateralorbitofrontal", "lingual", "medialorbitofrontal", "middletemporal", "parahippocampal", "paracentral", ...
 "parsopercularis", "parsorbitalis", "parstriangularis", "pericalcarine", "postcentral", "posteriorcingulate", ...
 "precentral", "precuneus", "rostralanteriorcingulate", "rostralmiddlefrontal", "superiorfrontal", "superiorparietal", ...
 "superiortemporal", "supramarginal", "frontalpole", "temporalpole", "transversetemporal", "insula" ];

annotationIdx = [ 1639705,2647065,10511485,6500,3294840,6558940,660700,9231540,14433500,7874740,9180300,9182740, ...
    3296035,9211105,4924360,3302560,3988500,3988540,9221340,3302420,1326300,3957880,1316060,14464220,14423100, ...
    11832480,9180240,8204875,10542100,9221140,14474380,1351760,6553700,11146310,13145750,2146559 ];
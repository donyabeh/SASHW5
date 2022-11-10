*1a;
filename MEPSfile "/home/u62368731/my_shared_file_links/ulund/STAT 330/Data/Homework/H224.DAT"; 
 
data meps2020; 
  infile MEPSfile; 
  input dupersID $ 11-20 age20x 182-183 sex 192 oftsmk53 635-636 totexp20 2703-2709; 
run; 
 
 
data mepsUse; 
  set meps2020; 
   
  * Restrict to adults with known smoking status; 
  if age20x >= 18 and oftsmk53 >= 1; 
   
  currSmoke = 0; 
  if oftsmk53 in (1,2) then currSmoke = 1; 
   
  if      18 <= age20x <= 34 then ageGrp = 1; 
  else if 35 <= age20x <= 64 then ageGrp = 2; 
  else if       age20x >= 65 then ageGrp = 3; 
   
  if          totexp20  =    0 then expGrp = 1; 
  else if 0 < totexp20 <= 1000 then expGrp = 2; 
  else if     totexp20 >  1000 then expGrp = 3; 
run; 
*Lines 16-17 identifies an observation in the data set as a current smoker (given by the value 1) if they
smoke every day or some days. Otherwise, an observation is not identified as a current smoker (given by the value of 0);

*1b;
proc freq data = mepsUse;
	tables currSmoke * expGrp;
run;
*The non-smokers (currSmoke = 0) group is more likely to have a high expenditure total than the current-smoker group.
50.24% of non-smokers have an expenditure total greater than 1000, compared to 7.04% of smokers having 
an expenditure total greater than 1000;

*1c;
proc means data = mepsUse
n mean median min max std maxdec = 3;
	var totexp20;
	class currSmoke;
run;
*The mean of total expenditures for the non-smoking group is 7244.330. The median of 
total expenditures for the non-smoking group is 1578.000. The mean of total expenditures for 
the smoking group is 7414.296. The median of total expenditures for the smoking group is 1212.000;

*1d;
proc means data = mepsUse
n mean median min max std maxdec = 3;
	var totexp20;
run;

*1e;
proc means data = mepsUse
q1 median q3;
	var totexp20;
run;

data meps;
	set mepsUse;
	if totexp20 <= 224 then expQuartile = 1;
	else if totexp20 > 224 and totexp20 <= 1546 then expQuartile = 2;
	else if totexp20 > 1546 and totexp20 <= 5740.5 then expQuartile = 3;
	else if totexp20 > 5740.5 then expQuartile = 4;
run;

*1f;
proc freq data = meps;
	tables ageGrp * expQuartile * currSmoke;
run;
*For younger Americans, 1.41% of current smokers are in the high-expenditure quartile, while 10.47% of non-smokers are;
*For middle-aged Americans, 4.03% of current smokers are in the high-expenditure quartile, while 18.36% of non-smokers are;
*For older Americans, 3.55% of current smokers are in the high-expenditure quartile, while 38.78% of non-smokers are;

*1g;
proc means data = meps median;
	var totexp20;
	class sex;
run;
*Females have a higher expenditure value of 2027.00 compared to the male expediture median value of 1028.00.;

proc means data = meps median;
	var totexp20;
	class ageGrp;
run;
*The older age group has a higher expenditure value of 4243.00 compared to the middle-aged group with 1293.00, and the 
younger age group with 425.50 as their expenditure values;

proc means data = meps median;
	var totexp20;
	class currSmoke;
run;
*The non-smokers have a higher expenditure group of 1578.00, compared to the smokers group with 1212.00 as their expenditure value.;

proc means data = meps mean;
	var totexp20;
	class currSmoke;
run;	
*With the median expenditure value, the smokers have a higher expenditure of 7414.30, compared to the non-smokers
with 7244.33 as their expenditure value;

*1h;
proc format;
	value gender 1 = 'Male'
				 2 = 'Female';
	value age 1 = '18-34'
	          2 = '35-64'
	          3 = '65+';
	value smoker 0 = 'Non-Smoker'
		         1 = 'Smoker';
proc means data = meps n mean median stddev;
	var totexp20;
	class sex ageGrp currSmoke;
	label sex = 'Sex'
	      ageGrp = 'Age'
	      currSmoke = 'Current Smoker'
		  std = "SD";
	format sex gender.
	       ageGrp age.
	       currSmoke smoker.;
	title1 "Total Medical Expenditures by Sex, Age, and Smoking Status"; 
    title2 height=0.10 "US Adults, Medical Expenditure Panel Survey, 2018"; 	  
run;
	
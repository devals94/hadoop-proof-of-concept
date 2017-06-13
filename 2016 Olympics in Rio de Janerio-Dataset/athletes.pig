athletes = LOAD '/input/athletes' using PigStorage(',') AS ( athletesid:chararray, name:chararray, nationality:chararray, sex:chararray, dob:chararray, height:long, weight:int, sport:chararray, gold:int, silver:int, bronze:int);

groupbynationality = GROUP athletes BY nationality;
countbynationality = FOREACH groupbynationality GENERATE group,COUNT(athletes);
dump countbynationality;
store countbynationality into '/output/athletes/AthletesByCountry';

groupbysex = GROUP athletes BY sex;
countbysex = FOREACH groupbysex GENERATE group,COUNT(athletes);
dump countbysex;
store countbysex into '/output/athletes/AthletesByGender';

groupbyboth = GROUP athletes BY (nationality,sex);
countbyboth = FOREACH groupbyboth GENERATE group.nationality, group.sex, COUNT(athletes);
dump countbyboth;
store countbyboth into '/output/athletes/AthletesByCountryGender';

groupbyathletes = GROUP athletes all;
countbygold = FOREACH groupbyathletes GENERATE SUM(athletes.gold);
dump countbygold;
store countbygold into '/output/athletes/GoldCount';
countbysilver = FOREACH groupbyathletes GENERATE SUM(athletes.silver);
dump countbysilver;
store countbysilver into '/output/athletes/SilverCount';

yearsbetween = FOREACH athletes GENERATE name,nationality,sex,sport,YearsBetween(ToDate('08/05/2016','MM/dd/yy'),ToDate(dob,'MM/dd/yy')) AS yr;
olderparticipant = ORDER yearsbetween BY yr desc;
oldest5 = LIMIT olderparticipant 5;
dump oldest5;
store oldest5 into '/output/athletes/Oldest5Athletes';

youngerparticipant = ORDER yearsbetween BY yr ASC;
youngest5 = LIMIT youngerparticipant 5;
dump youngest5;
store youngest5 into '/output/athletes/Youngest5Athletes';

sportbycountry = GROUP athletes BY (nationality,sport);
countbyboth = FOREACH sportbycountry GENERATE group.nationality,group.sport,COUNT(athletes.sport) AS cnt;
countbycountry = ORDER countbyboth BY cnt desc;
top5country = LIMIT countbycountry 5;
dump top5country;
store top5country into '/output/athletes/AthletesByCountrySport';

groupbysport = GROUP athletes BY sport;
countbysport = FOREACH groupbysport GENERATE group,COUNT(athletes);
dump countbysport;
store countbysport into '/output/athletes/AthletesBySport';
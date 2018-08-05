#Merge Presidential JAR

dat<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/prelimGovDat.csv')
dat<-dat[-(which(dat$st=='DC')),-c(1,2)] #remove DC and columns of row number
pjar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/PresidentialJAR/PresJAR.csv')
pjar<-pjar[,-1] #remove column of index
dat1<-merge(dat,pjar, by=c('st', 'year'), all.x = T) #merge with presidential JAR

#---------------------------------------------------------------------------------
gjar<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/BeyleJAR/GovJAR.csv')
gjar<-gjar[,-1]
dat1<-merge(dat1, gjar,  by=c('st', 'year'), all.x = T) #merge with governor JAR

#--------------------------------------------------------------------------------
# merge unemployment from 1995
unemp<-read.csv('C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008/unemployment1995.csv')
unemp<-unemp[,-1]
unemp<-unemp[-(which(unemp$state=="District of Columbia")),] #remove dc
dat2<-merge(dat1, unemp,by=c('state', 'year'), all.x = T)
library(dplyr)
dat2$unemployment<-if_else(is.na(dat2$unemployment), dat2$unemployment.1, dat2$unemployment)
dat2<-dat2[, -ncol(dat2)]

unique(dat2$term_length)
#---------------------------------------------------------------------------------
# Make column for term in office
dat2$term_in_office<-if_else((dat2$limit_type==1 & dat2$lame_duck_last_term==1), 1, 0) #using 0 as a place holder because if_else requires a double for conditions that are false 

#make df of govs with a limit of two terms and 0 (not last term) for lame_duck...
#there are some cases where "lame_duck..." is incorrect, like CA Edmund G Brown Jr
twoterm<-dat2[which(dat2$limit_type==2 & dat2$lame_duck_last_term==0), c('st', 'year', 'govname1','term_length', 'limit_type', 'lame_duck_last_term')]
dat2$term_in_office<-if_else((dat2$limit_type==2 & dat2$lame_duck_last_term==1), 2, dat2$term_in_office)
dat2$term_in_office<-if_else((dat2$limit_type==2 & dat2$lame_duck_last_term==0), 1, dat2$term_in_office)
dat2$term_in_office<-if_else((dat2$limit_type==0 & dat2$lame_duck_last_term==0), 1, dat2$term_in_office)
#---------------------------------------------------------------------
#limit type is not helpful...handcode :(
#---------------------------------------------------------------------
look<-dat2[, c('st', 'year', 'govname1','gub_election','term_length', 'limit_type', 'lame_duck_last_term', 'term_in_office')]
#AL and AK
dat2$term_in_office[c(34:37, 46:49, 73:76, 6:9, 22:25, 42:43, 66:68, 101:104)]<-2
dat2$term_in_office[c(26:29, 81:84)]<-3
dat2$term_in_office[c(120:127, 62:65, 189:192)]<-1
dat2$gub_election[c(67,68, 126,127, 194,195, 262,263, 330,331)]<-0
dat2$limit_type[c(62:68, 121:127, 189:195, 257:263, 352:331)]<-2
dat2$lame_duck_last_term[c(62:65, 121:127, 189:195, 325:328,261:263)]<-0
dat2$lame_duck_last_term[c(66:68, 257:260,329:331 )]<-1
dat2$term_in_office[c(187,188)]<-0

#AZ
dat2$term_in_office[c(128:130, 133, 134, 137,138, 143:146, 153,154, 157:160, 167, 168, 176:184,187:190, 193:195)]<-1
dat2$term_in_office[c(131:132,135, 136, 139,140, 147,148, 161:164, 185,186,191,192)]<-2
dat2$term_in_office[c(141,142, 149:152)]<-3

#AR
dat2$govname1[198]<-dat2$govname1[199]
dat2$govname1[200] <-dat2$govname1[201]
dat2$term_in_office[c(242:244)]<-0 #change back to 0
dat2$term_in_office[c(196:201, 213,214, 217,218, 221,222, 261:263)]<-1
dat2$term_in_office[c(202:203, 215,216, 219,220,223,224,229,230,241, 249:252, 257:260)]<-2
dat2$term_in_office[c(204:205,231,232)]<-3
dat2$term_in_office[c(206:207, 233:236)]<-4
dat2$term_in_office[c(208:209, 237,238)]<-5
dat2$term_in_office[c(210:211)]<-6

#CA
dat2$govname1[c(268, 269)]<-dat2$govname1[270]
dat2$term_in_office[c(277:280, 285:288, 293:296, 301:304, 309:312, 321:324)]<-2
dat2$term_in_office[c(325:328)]<-3
dat2$term_in_office[c(329:331)]<-4
dat2$limit_type[c(325:330)]<-2
#CO
dat2$term_in_office[c(335:336, 341:344, 349:352, 361:364, 373:376, 397:399)]<-2
dat2$term_in_office[c(365:368, 377:380)]<-3
dat2$govname1[337]<-dat2$govname1[338]
dat2$term_in_office[355]<-0
dat2$term_in_office[393:396]<-1
dat2$limit_type[c(393:399)]<-2
dat2$lame_duck_last_term[c(393:396)]<-0
dat2$lame_duck_last_term[c(397:399)]<-1
dat2$gub_election[c(398,399)]<-0
#CT
dat2$term_in_office[c(409,410, 415:418, 429,430, 435:438, 449:453, 465:467)]<-2
dat2$term_in_office[c(439, 440)]<-3
dat2$term_in_office[c(461:464)]<-1
dat2$limit_type[c(461:467)]<-0
dat2$lame_duck_last_term[c(461:467)]<-0

dat2$gub_election[c(466,467)]<-0
#DE
dat2$term_in_office[c(475:478, 491:494, 531:534)]<-2
dat2$term_in_office[c(529, 530,535)]<-1
dat2$gub_election[c(535)]<-0
dat2$gub_election[c(534)]<-1
dat2$limit_type[c(529:534)]<-2
dat2$lame_duck_last_term[c(529,530,534)]<-0
dat2$lame_duck_last_term[c(531:534)]<-1
#FL
dat2$term_in_office[c(597:600)]<-1
dat2$term_in_office[c(601:603)]<-2
dat2$limit_type[c(597:603)]<-2
dat2$lame_duck_last_term[c(597:600)]<-0
dat2$lame_duck_last_term[c(601:603)]<-1
#GA
dat2$term_in_office[c(665:668)]<-1
dat2$term_in_office[c(669:671)]<-2
dat2$lame_duck_last_term[c(665:668)]<-0
dat2$lame_duck_last_term[c(669:671)]<-1
dat2$limit_type[c(665:671)]<-2

#HI and ID
dat2$term_in_office[c(723:730)]<-1
dat2$term_in_office[c(680:683, 692:695, 740:743, 756,757, 764:767,
                      727:775, 784:787, 792:795)]<-2
dat2$term_in_office[c(684:687, 696:699,744:747, 796:798)]<-3
dat2$term_in_office[c(758,759)]<-0
dat2$lame_duck_last_term[c(724:727, 792:798)]<-0
dat2$lame_duck_last_term[c(728:730)]<-1
dat2$limit_type[c(724:730)]<-2
dat2$limit_type[c(792:798)]<-0
#IL
dat2$term_in_office[c(806:809, 814:816, 828:831, 844:847, 856,857)]<-2
dat2$term_in_office[c(817, 858,859)]<-0
dat2$term_in_office[c(832:835)]<-3
dat2$term_in_office[c(836:839)]<-4
dat2$term_in_office[c(860:866)]<-1
dat2$lame_duck_last_term[c(860:866)]<-0
dat2$limit_type[c(860:866)]<-0
dat2$gub_election[c(4865,866)]<-0
#IN
dat2$term_in_office[c(930:934)]<-1
dat2$term_in_office[c(867:869, 926:929)]<-2
dat2$term_in_office[c(920)]<-0
dat2$govname1[c(922:923)]<-dat2$govname1[924]
dat2$lame_duck_last_term[c(930:934)]<-0
dat2$lame_duck_last_term[c(928:929)]<-1
dat2$limit_type[c(928:934)]<-2
#IA
dat2$term_in_office[c(936, 937, 944,945, 950,951, 956, 957, 972:975, 988:991)]<-2
dat2$term_in_office[c(938,939, 952,953, 958,959, 976:979)]<-3
dat2$term_in_office[c(940:941)]<-0
dat2$term_in_office[c(960:963, 980:983)]<-4
dat2$term_in_office[c(964:967)]<-5
dat2$term_in_office[c(996:999)]<-6
dat2$term_in_office[c(1000,1001)]<-7
dat2$term_in_office[c(1002)]<-1
dat2$lame_duck_last_term[c(996:1002)]<-0
dat2$limit_type[c(996:1002)]<-0
#KS
dat2$term_in_office[c(1064:1067)]<-1
dat2$term_in_office[c(1006,1007, 1012,1013, 1036:1039, 1068:1070)]<-2
dat2$term_in_office[c(1020,1021)]<-3
dat2$term_in_office[c(1022,1023)]<-4
dat2$term_in_office[c(1024,1025)]<-5
dat2$term_in_office[c(1026,1027)]<-6
dat2$lame_duck_last_term[c(1064:1067)]<-0
dat2$lame_duck_last_term[c(1068:1070)]<-1
dat2$limit_type[c(1064:1070)]<-2
#KY
dat2$term_in_office[c(1077,1080,1133:1136)]<-2
dat2$term_in_office[c(1132, 1137,1138)]<-1
dat2$limit_type[c(1132:1138)]<-2
dat2$lame_duck_last_term[c(1133:1136)]<-1
dat2$lame_duck_last_term[c(1137,1138)]<-0
dat2$lame_duck_last_term[1132]<-0

#LA
dat2$term_in_office[c(1145:1148, 1201:1204)]<-2
dat2$term_in_office[c(1173:1176)]<-3
dat2$term_in_office[c(1181:1184)]<-4
dat2$term_in_office[c(1205:1206,1200)]<-1
dat2$lame_duck_last_term[c(1204:1206)]<-1
dat2$lame_duck_last_term[c(1200:1203)]<-0
dat2$limit_type[c(1200:1206)]<-2
#ME and MD
dat2$term_in_office[c(1214,1215, 1219, 1336,1337, 1272:1274)]<-2
dat2$term_in_office[c(1294, 1295, 1302, 1338, 1339)]<-0
dat2$term_in_office[c(1339:1342, 1268:1271)]<-1
dat2$limit_type[c(1268:1274,1336:1342 )]<-2
dat2$lame_duck_last_term[c(1268:1271, 1336:1342)]<-0
dat2$lame_duck_last_term[c(1271:1274)]<-1
dat2$gub_election[c(1273:1274, 1341,1342)]<-0

#MA
dat2$term_in_office[c(1348,1349,1352,1353,1358,1359, 1380:1383, 1388, 1389, 1404:1407)]<-2
dat2$term_in_office[c(1360,1361)]<-3
dat2$term_in_office[c(1408:1410)]<-1
dat2$term_in_office[c(1362, 1362, 1390, 1394, 1363, 1391, 1395)]<-0
dat2$gub_election[c(1409,1410)]<-0
dat2$limit_type[c(1404:1410)]<-2
dat2$lame_duck_last_term[c(1404:1410)]<-0

#MI
dat2$term_in_office[c(1430, 1431)]<-0
dat2$term_in_office[c(1430, 1431, 1472:1475)]<-1
dat2$term_in_office[c(1412,1413, 1426,1427, 1436:1439, 1448:1451, 1456:1459, 1476:1478)]<-2
dat2$term_in_office[c(1414,1415, 1428,1429, 1440:1443, 1460:1463)]<-3
dat2$term_in_office[c(1416,1417)]<-4
dat2$term_in_office[c(1418,1419)]<-5
dat2$term_in_office[c(1420,1421)]<-6
dat2$limit_type[c(1472:1478)]<-2
dat2$lame_duck_last_term[c(1472:1475)]<-0
dat2$lame_duck_last_term[c(1476:1478)]<-1

#MN
dat2$term_in_office[c(1480, 1492, 1506,1507)]<-0
dat2$term_in_office[c(1540:1543)]<-1
dat2$term_in_office[c(1482,1483, 1486,1487, 1504, 1505, 1516:1519, 1524:1527, 1536:1539, 1544:1546)]<-2
dat2$term_in_office[c(1488,1489)]<-3
dat2$limit_type[c(1540:1546)]<-0
dat2$lame_duck_last_term[c(1540:1546)]<-0

#MS
dat2$term_in_office[c(1609:1612)]<-1
dat2$term_in_office[c(1549:1552, 1608, 1613,1614)]<-2
dat2$limit_type[c(1608:1614)]<-2
dat2$lame_duck_last_term[c(1609:1612)]<-0
dat2$lame_duck_last_term[c(1608, 1613,1614)]<-1

#MO
dat2$term_in_office[c(1665)]<-0
dat2$term_in_office[c(1676:1677, 1682)]<-1
dat2$term_in_office[c(1678:1681)]<-2
dat2$gub_election[c(1681)]<-1
dat2$gub_election[c(1682)]<-0
dat2$limit_type[c(1676:1682)]<-2
dat2$lame_duck_last_term[c(1678:1681)]<-1
dat2$lame_duck_last_term[c(1676, 1677, 1682)]<-0
#MT
dat2$term_in_office[c(1690:1693, 1712:1713, 1718:1721, 1744, 1745,1750)]<-2
dat2$term_in_office[c(1695:1697)]<-0
dat2$term_in_office[c(1746:1749)]<-1
dat2$limit_type[c(1744:1750)]<-2
dat2$lame_duck_last_term[c(1744,1745, 1750)]<-1
dat2$lame_duck_last_term[c(1746:1749)]<-0
#NE
dat2$term_in_office[c(1758,1759, 1764, 1765)]<-2
dat2$term_in_office[c(1761, 1806,1807)]<-0
dat2$term_in_office[c(1816:1818)]<-1
dat2$term_in_office[c(1766,1767,1812:1815)]<-3
dat2$limit_type[c(1812:1818)]<-2
dat2$lame_duck_last_term[c(1812:1815)]<-1
dat2$lame_duck_last_term[c(1816:1818)]<-0
dat2$gub_election[c(1817,1818)]<-0

#NV
dat2$term_in_office[c(1824:1827, 1832:1835, 1884:1886)]<-2
dat2$term_in_office[c(1880:1883)]<-1
dat2$limit_type[c(1880:1886)]<-2
dat2$lame_duck_last_term[c(1884:1886)]<-1
dat2$lame_duck_last_term[c(1880:1883)]<-0

#NH
dat2$term_in_office[c(1889,1894,1895, 1898,1899, 1902,1903,1908,1909,1912,1913, 1918,1919, 1922,1923,
                      1928,1929, 1932,1933, 1944,1945, 1952,1953)]<-2
dat2$term_in_office[c(1904,1905, 1914,1915, 1924,1925, 1946,1947)]<-3
dat2$term_in_office[c(1948,1949)]<-4
dat2$term_in_office[c(1950,1951, 1954)]<-1

dat2$limit_type[c(1948:1954)]<-0
dat2$lame_duck_last_term[c(1948:1954)]<-0

#NJ
dat2$term_in_office[c(2016:2019)]<-1
dat2$term_in_office[c(1955:1958, 2020:2022)]<-2
dat2$limit_type[c(2016:2022)]<-2
dat2$lame_duck_last_term[c(2020:2022)]<-1
dat2$lame_duck_last_term[c(2016:2019)]<-0

#NM
dat2$term_in_office[c(2030,2031, 2064:2067)]<-3
dat2$term_in_office[c(2034,2035)]<-4
dat2$term_in_office[c(2052:2055, 2088:2090)]<-2
dat2$limit_type[c(2044:2063, 2084:2090)]<-2
dat2$term_in_office[c(2084:2087)]<-1
dat2$lame_duck_last_term[c(2084:2087)]<-0
dat2$lame_duck_last_term[c(2088:2090)]<-1
#NY
dat2$term_in_office[c(2091, 2104:2107, 2119:2123, 2128:2131, 2140:2143, 2156:2158)]<-2
dat2$term_in_office[c(2092:2095, 2108:2111, 2132:2135, 2144:2147)]<-3
dat2$term_in_office[c(2112:2114)]<-4
dat2$term_in_office[c(2149:2151)]<-0
dat2$limit_type[c(2152:2158)]<-0

dat2$gub_election[c(2157,2158)]<-0
dat2$lame_duck_last_term[c(2152:2158)]<-0
#NC
dat2$term_in_office[c(2164:2165)]<-0
dat2$term_in_office[c(2202:2205)]<-3
dat2$term_in_office[c(2206:2209)]<-4
dat2$govname1[2221]<-dat2$govname1[2220]
dat2$limit_type[c(2220:2226)]<-2
dat2$lame_duck_last_term[c(2220:2226)]<-0
dat2$gub_election[c(2225)]<-1

dat2$gub_election[c(2226)]<-0
dat2$term_in_office[c(2220:2225)]<-1

#ND
dat2$term_in_office[c(2230,2231, 2236,2237, 2240,2241, 2254:2257, 2266:2269,
                      2274:2277, 2282:2285)]<-2
dat2$term_in_office[c(2232,2233, 2242:2245, 2286,2287)]<-3
dat2$term_in_office[c(2246:2249)]<-4
dat2$term_in_office[c(2288,2289)]<-0
dat2$term_in_office[c(2290:2294)]<-1

dat2$term_length[c(2285:2294)]<-4
dat2$limit_type[c(2288:2294)]<-0
dat2$lame_duck_last_term[c(2288:2294)]<-0
dat2$gub_election[c(2293)]<-1
dat2$gub_election[c(2294)]<-0

#OH
dat2$term_in_office[c(2295, 2312:2315, 2360:2362)]<-2
dat2$term_in_office[c(2296,2276, 2320:2323)]<-3
dat2$term_in_office[c(2298,2299, 2324:2327)]<-4
dat2$term_in_office[c(2300,2301)]<-5
dat2$term_in_office[c(2356:2359)]<-1
dat2$limit_type[c(2308:2339)]<-0
dat2$limit_type[c(2356:2362)]<-2
dat2$gub_election[c(2361:2362)]<-0
dat2$lame_duck_last_term[c(2356:2359)]<-0
dat2$lame_duck_last_term[c(2360:2362)]<-1

#OK
dat2$lame_duck_last_term[c(2400:2403, 2428:2430)]<-1
dat2$lame_duck_last_term[c(2424:2427)]<-0
dat2$limit_type[c(2424:2430)]<-2
dat2$gub_election[c(2429:2430)]<-0
dat2$term_in_office[c(2400:2403)]<-2
dat2$term_in_office[c(2424:2427)]<-1
dat2$term_in_office[c(2428:2430)]<-2

#OR
#2431:2437
###WTF?
dat2$gub_election[c(2497)]<-1
dat2$gub_election[c(2498)]<-0
dat2$limit_type[c(2492:2498)]<-2
dat2$term_in_office[c(2492:2495)]<-3
dat2$term_in_office[c(2496, 2434,2435, 2437)]<-0
dat2$term_in_office[c(2497:2498, 2431)]<-1
dat2$term_in_office[c(2432,2433)]<-2
dat2$lame_duck_last_term[c(2492:2495)]<-1
dat2$lame_duck_last_term[c(2496:2498)]<-0
#PA
dat2$term_in_office[c(2550:2551)]<-0
dat2$term_in_office[c(2560:2566)]<-1
dat2$limit_type[c(2560:2566)]<-2
dat2$lame_duck_last_term[c(2560:2566)]<-0

#RI
#drop row 2567
dat2$term_in_office[c(2567)]<-0
dat2$term_in_office[c(2570,2571, 2582,2583,2588,2589,2592,2593,
                      2596,2597,2604,2605,2610,2611)]<-2
dat2$term_in_office[c(2572,2573, 2584,2585,2598,2599,2606,2607)]<-3
dat2$term_in_office[c(2574,2575,2600,2601)]<-4
dat2$term_in_office[c(2628:2634)]<-1
dat2$govname1[2632]<-dat2$govname1[2633]
dat2$limit_type[c(2628:2634)]<-2
dat2$lame_duck_last_term[c(2628:2634)]<-0
dat2$gub_election[c(2633,2634)]<-0

#SC
dat2$term_in_office[c(2650, 2651, 2702)]<-0
dat2$term_in_office[c(2696:2699)]<-1
dat2$term_in_office[c(2700:2701)]<-2
dat2$limit_type[c(2696:2702)]<-2
dat2$lame_duck_last_term[c(2696:2699, 2702)]<-0
dat2$lame_duck_last_term[c(2700,2071)]<-1
dat2$gub_election[c(2701, 2702)]<-0

#SD
dat2$term_in_office[c(2703,2706,2707,2710,2711,2716,2717,2720,2721,2726,2727, 2768:2770)]<-2
dat2$term_in_office[c(2728:2730)]<-3
dat2$term_in_office[c(2731, 2746,2747)]<-0
dat2$limit_type[c(2764:2770)]<-2
dat2$lame_duck_last_term[c(2764:2767)]<-0
dat2$lame_duck_last_term[c(2768:2770)]<-1
dat2$term_in_office[c(2764:2767)]<-1
dat2$gub_election[c(2769:2770)]<-0

#TN
dat2$term_in_office[c(2772,2773, 2776:2779, 2788:2791,2836:2838)]<-2
dat2$term_in_office[c(2784:2787)]<-3
dat2$limit_type[c(2832:2838)]<-2
dat2$lame_duck_last_term[c(2832:2835)]<-0
dat2$lame_duck_last_term[c(2836:2838)]<-1
dat2$term_in_office[c(2832:2835)]<-1
dat2$gub_election[c(2837,2838)]<-0

#TX
dat2$term_in_office[c(2840,2841, 2848,2849,2854,2855,
                      2860,2861, 2864:2867, 2876:2879, 2888:2889,
                      2896:2899)]<-2
dat2$term_in_office[c(2842, 2843,2850,2851,2856,2857,
                      2900:2903)]<-3
dat2$term_in_office[c(2844,2845)]<-4
dat2$term_in_office[c(2890,2891)]<-0
dat2$limit_type[c(2900:2906)]<-0
dat2$lame_duck_last_term[c(2900:2906)]<-0
dat2$gub_election[c(2905,2906)]<-0


#UT
dat2$term_in_office[c(2910:2913, 2918:2921, 2926:2929,
                      2938:2941, 2946:2949, 2954:2947, 2966,2974)]<-2
dat2$term_in_office[c(2930:2933, 2958:2960)]<-3
dat2$term_in_office[c(2961, 2967,2968)]<-0
dat2$term_in_office[c(2952, 2953, 2962:2965, 2970:2973)]<-1
dat2$govname1[c(2962,2963)]<-dat2$govname1[2964]
dat2$gub_election[c(2905,2906, 2971, 2973,2974)]<-0
dat2$limit_type[c(2960:2974)]<-0
dat2$lame_duck_last_term[c(2968:2974)]<-0

#VT
dat2$term_in_office[c(2975,2978,2979,2982,2983,2990,2991,
                      2996,2997,3000,3001,3004,3005,3012,
                      3013, 3020, 3021,3030,3031, 3038,3039 )]<-2
dat2$term_in_office[c(2992,2993,3006,3007,3014,3015, 3023,3022, 3032,3033, 3040,3041)]<-3
dat2$term_in_office[c(3008,3009, 3025,3024,3034,3035)]<-4
dat2$term_in_office[c(3027,3026)]<-5
dat2$term_in_office[c(3036,3037, 3042)]<-1
dat2$gub_election[c(3041,3042)]<-0
dat2$limit_type[c(3036:3042)]<-0
dat2$lame_duck_last_term[c(3036:3042)]<-0

dat2$term_in_office[c(3016,3017)]<-0

#VA
dat2$term_in_office[c(3067:3070)]<-2
dat2$term_in_office[c(3104:3110)]<-1
dat2$gub_election[c(3109)]<-0
dat2$gub_election[c(3110)]<-1
dat2$limit_type[c(3104:3110)]<-1
dat2$lame_duck_last_term[c(3104:3110)]<-1

#WA
dat2$term_in_office[c(3111:3113, 3122:3125, 3130:3133, 3150:3153, 3172,3173, 3178)]<-2
dat2$term_in_office[c(3114:3117, 3134:3137)]<-3

dat2$limit_type[c(3172:3178)]<-2
dat2$lame_duck_last_term[c(3172,3173, 3178)]<-1
dat2$lame_duck_last_term[c(3174:3177)]<-0
dat2$gub_election[c(3178)]<-0
dat2$gub_election[c(3177)]<-1

#WV
dat2$term_in_office[c(3214:3217)]<-3
dat2$term_in_office[c(3240:3241)]<-0
dat2$term_in_office[c(3242:3246)]<-1
dat2$gub_election[c(3246)]<-0
dat2$gub_election[c(3245)]<-1
dat2$limit_type[c(3240:3246)]<-2
dat2$lame_duck_last_term[c(3242:3245)]<-1
dat2$lame_duck_last_term[c(3240,3241,3246)]<-0

#WI
dat2$govname1[3247]<-'Rennebohm, Oscar'
dat2$term_in_office[c(3248, 3275, 3299)]<-0
dat2$term_in_office[c(3247, 3251,3250, 3258,3259,3264,3265,3272:3274,
                      3288:3291, 3304:3307, 3312:3314)]<-2
dat2$term_in_office[c(3253,3252,3266,3267,3292:3295)]<-3
dat2$term_in_office[c(3296:3298)]<-4
dat2$term_in_office[c(3308:3311)]<-1
dat2$limit_type[c(3308:3314)]<-0
dat2$gub_election[c(3313,3314, 3381,3382)]<-0
dat2$lame_duck_last_term[c(3308:3314, 3376:3379)]<-0
#WY
dat2$term_in_office[c(3318:3319, 3326,3327)]<-0
dat2$term_in_office[c(3336:3339, 3344:3347, 3356:3359, 3380:3382)]<-2
dat2$term_in_office[c(3348:3351)]<-3
dat2$term_in_office[c(3376:3379)]<-1
dat2$limit_type[c(3376:3382)]<-2
dat2$lame_duck_last_term[c(3380:3382)]<-1
#---------------------------------------
#DF of times a gov appears in the data set
# divide freq by length of term to determine how many terms a gov was in office
govcount<-as.data.frame(table(sort(dat2$govname1)))
names(govcount)<-c('govname1', 'years_in_office')
govcount<-govcount[-1,]

#some governors are the same person with differenet names----------------------
#reconcile these rows: 80/81; 144/145, 157/158; 340;341
#80/81
which(dat2$govname1=='Brown, Edmund G. """"Jerry"""" Jr.')
which(dat2$govname1=='Brown, Edmund G. """"Pat"""" Sr.')
dat2$govname1[which(dat2$govname1=='Brown, Edmund Gerald')]<-'Brown, Edmund G. """"Jerry"""" Jr.' #same as Jr. Re-ran for gov
 
#144/145
dat2$govname1[which(dat2$govname1=='corzine, Jon Stevens')]<-'Corzine, Jon'

#157/158
which(dat2$govname1=='Dalton, John') #VA, 1978
which(dat2$govname1=='Dalton, John M.') #MO, 1963

#340;341
dat2$govname1[which(dat2$govname1=='Kohler, Walter J. Jr.')]<-'Kohler Jr., Walter J.' 


#for rows with split year governors, search "/', 'and', or 'then'
setwd("C:/Users/zoeja/OneDrive/Documents/Summer 2018/GovernorData/StateGovernors1950-2008")
names(dat2)[c(4,5,13:18, 21,33, 35:39)]<-c('gov_name',
                     'gov_party',
                     'state_cpi',
                     'citizen_ideology',
                     'state_ideology',
                     'stimson_mood',
                     'gub_dem_vote_prop',
                     'electoral_competitiveness',
                     'total_gub_votes',
                     'lagged_gsp',
                     'mean_pres_approve',
                     'mean_pres_disapprove',
                     'pres_party',
                     'mean_gub_approve',
                     'mean_gub_disapprove')
names(dat2)
dat2<-dat2[,c(2,1,3,4,#identifiers
              40,5,7,10,11,
            8,9,6,
              12,13,32,33,34,#economic variables
              18,#electoral competitiveness
              14:16,#ideology
              17, 19:24,38,39,#gub votes/approval
              26,28,30,25,27,29,31,35,36,37#pres votes/approval
              )]
write.csv(dat2, 'prelimGovDat1.csv')


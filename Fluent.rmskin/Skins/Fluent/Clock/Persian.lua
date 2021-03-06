function Initialize()
persianWeekdays = { "Yekshanbeh", "Doshanbeh","Seshhanbeh", "Chaharshanbeh","Panjshanbeh", "Jomeh", "Shanbeh"}
persianDayScript = { "یک شنبه","دوشنبه","سه شنبه","چهارشنبه","پنج شنبه","جمعه","شنبه"}
persianMonths = {"Farvardin","Ordibehesht","Khordad","Tir","Mordad","Shahrivar","Mehr","Aban","Azar","Dey","Bahman","Esfand" }
persianMonthScript = { "فروردین","اردیبهشت","خرداد","تیر","مرداد","شهریور","مهر","آبان","آذر","دی","بهمن","اسفند" }
islamicWeekdays = {"al-Ahad","al-Ithnayn","ath-Thalaathaa","al-Arba'aa'","al-Khamis","al-Jumu'ah","as-Sabt"}
islamicMonths = {"Muharam","Safar","Rabi'ul Awal","Rabiul Akhir","Jamadil Awal","Jamadil Akhir","Rajab","Sha'ban","Ramadhan","Shawwal","Dhulka'edah","Dzulhijjah"}
end

function Update()       
          today = os.date('*t')
          Gday = today.day
          Gmonth = today.month
          Gyear = today.year
			jd = math.ceil(  julian( Gyear, Gmonth, Gday ) )	
			SKIN:Bang('!SetOption', 'MtGregorianDate', 'Text', ("Gregorian Date :    "..Gday.." / " ..Gmonth.." / "..Gyear))
			Hyear, Hmonth, Hdate, Hwd = CalcHijriDate( jd )				
			SKIN:Bang('!SetOption', 'MtHijriDate', 'Text', ("Hijri Date :         "..Hdate.." / " ..Hmonth.." / "..Hyear) )			
			SKIN:Bang('!SetOption', 'MtHijriTextDate', 'Text', (" "..islamicWeekdays[Hwd]..": "..Hdate.." "..islamicMonths[Hmonth].." "..Hyear.." AH")  )	
			Pyear, Pmonth, Pdate, Pwd = CalcPersianDate( jd )
			SKIN:Bang('!SetOption', 'MtPersianDate', 'Text', ("Persian Date :         "..Pdate.." / " ..Pmonth.." / "..Pyear) )			
			SKIN:Bang('!SetOption', 'MtPersianTextDate', 'Text', (" "..persianWeekdays[Pwd]..": "..Pdate.." "..persianMonths[Pmonth].." "..Pyear)  )	
			SKIN:Bang('!SetOption', 'measureDateA', 'Formula',  Pdate  )		
			SKIN:Bang('!SetOption', 'measureYear', 'Formula',  Pyear   )
			SKIN:Bang('!SetOption', 'measureDateB', 'Text', (" "..persianDayScript[Pwd].." %1 "..persianMonthScript[Pmonth].." %2")  )	
			return " "..Pdate.."."..Pmonth.."."..Pyear
end

function  julian(year, month, day) --  convert Gregorian date to Julian day
		if (month<=2) then	year = year-1  month = month+12	end
		local A = math.floor(year/ 100)
		local B = 2- A+ math.floor(A/ 4)
		JD = math.floor(365.25* (year+ 4716))+ math.floor(30.6001* (month+ 1))+ day+ B-1524.5
		return JD
end

function persian_to_jd( year, month, day )
    local epbase, epyear, dayspast
	local PERSIAN_EPOCH = 1948320.5
	if (year >= 0)  then epbase = year - 474 else ephase = year - 473 end
	epyear = 474 + (epbase % 2820)
	if  (month <= 7) then dayspast = ((month - 1) * 31) 
			else  dayspast = (((month - 1) * 30) + 6)
	end
	return day + dayspast + 	(math.floor(((epyear * 682) - 110) / 2816) + (epyear - 1) * 365 + math.floor(epbase / 2820) * 1029983 + (PERSIAN_EPOCH - 1)	)		
end

function  CalcPersianDate( jd )   --  Calculate Persian date from Julian day
	local  Pyear, Pmonth, Pdate, Pday, depoch, cycle, cyear, ycycle, aux1, aux2, yday
		depoch = jd - persian_to_jd(475, 1, 1)
		cycle = math.floor(depoch / 1029983)
		cyear = (depoch % 1029983)
		if (cyear == 1029982) then
			ycycle = 2820
			else
				aux1 = math.floor(cyear / 366)
				aux2 = (cyear % 366)
				ycycle = math.floor(((2134 * aux1) + (2816 * aux2) + 2815) / 1028522) + aux1 + 1
		end
		Pyear = ycycle + (2820 * cycle) + 474  -- year
		if (Pyear <= 0) then  Pyear = 0 end
		yday = (jd - persian_to_jd(Pyear, 1, 1) ) + 1	
		if (yday <= 186) then Pmonth= math.ceil(yday / 31) 
				else Pmonth = math.ceil((yday - 6) / 30) 
			end --   month
		Pdate =math.ceil(jd - persian_to_jd( Pyear, Pmonth, 1) )
		Pday =( ((jd+1%7)+7)%7)+1
		return Pyear, Pmonth, Pdate, Pday
end

function intPart(floatNum)      
		if (floatNum< -0.0000001) 
		   then 	 return math.ceil(floatNum-0.0000001)
		   else		return math.floor(floatNum+0.0000001)	
		 end	
end

function CalcHijriDate( jd )	
		local l, n, j, Hyear, Hmonth, Hdate, Hday
		l=jd-1937808
		n=intPart((l-1)/10631)
		l=l-10631*n+354
		j=(intPart((10985-l)/5316))*(intPart((50*l)/17719))+(intPart(l/5670))*(intPart((43*l)/15238))
		l=l-(intPart((30-j)/15))*(intPart((17719*j)/50))-(intPart(j/16))*(intPart((15238*j)/43))+29
		Hmonth=intPart((24*l)/709)    --   month
		Hdate = l-intPart((709*Hmonth)/24)    --   date 
		Hday =( ((jd+1%7)+7)%7)+1   --  weekday number
		Hyear = 30*n+j-30		--  year
		return Hyear, Hmonth, Hdate, Hday
end
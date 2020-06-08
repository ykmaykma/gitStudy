

/**
Constructor
Do not call Function in Constructor.
*/
var MetaInfo = {};

MetaInfo.OrderType = 
{
	'01' : '매도',
	'02' : '매수'
};

// 04는 자유적립식이지만 메리츠에서는 자유적립식을 일정액적립식으로 사용
MetaInfo.PayMthdCode = 
{
	'01' : '임의식',
	'02' : '거치식',
	'03' : '정액적립식',
	'04' : '일정액적립식'
};
MetaInfo.fnGetDateHTxt = function(dateNum)
{
	var returnValue = '';
	
	if(dateNum) 
	{
		dateNum = dateNum+'';
		returnValue = [dateNum.substr(2,2), '년', dateNum.substr(4, 2), '월', dateNum.substr(6,2), '일' ].join('');
	}
	
	return returnValue;
};

MetaInfo.fnGetDateHTxt2 = function(dateNum)
{
	if(!parseInt(dateNum, 10)) return '';
	dateNum+='';
	return dateNum.substring(0,4)+'년 '+dateNum.substring(4,6)+'월 '+dateNum.substring(6,8) + '일'; 
};

//오늘날짜 숫자 리턴
MetaInfo.fnGetToday = function()
{
	var returnValue, 
		arg0 = arguments[0],
		d = new Date(),
  		s =[
			this.leadingZeros(d.getFullYear(), 4), '-',
			this.leadingZeros(d.getMonth()+1, 2), '-',
			this.leadingZeros(d.getDate(), 2)/*, 
			' ',
			this.leadingZeros(d.getHours(), 2), ':',
			this.leadingZeros(d.getMinutes(), 2), ':',
			this.leadingZeros(d.getSeconds(), 2)*/
		].join(''); //0000-00-00
	
	if(!arg0)
	{
		returnValue = s;	
	}
	else
	{	
		if(arg0.toUpperCase()==='DATENUM' || arg0.toUpperCase()==='NUMDATE') 
			returnValue = s.split('-').join(''); //날짜숫자만
		
	}
	
  	return returnValue;
};

MetaInfo.leadingZeros = function(n, digits)
{
	var zero = '';
  	n = n.toString();
  	if (n.length < digits)
	{
    	for (i = 0; i < digits - n.length; i++)
		{
			zero += '0';
		}
  	}
  	return zero + n;
};


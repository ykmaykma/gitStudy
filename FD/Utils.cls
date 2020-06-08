
/**
Constructor
Do not call Function in Constructor.
*/
var Utils = {};
Utils.gridClassArr = ['AGrid','FixedGrid','StockGrid','ArrangeGrid','InvestGrid'];	//그리드객체 종류

//JOSN변환전 스트링 클린업하기
Utils.validJSON = function(s)
{
	s = s.replace(/\\n/g, "\\n")  
               .replace(/\\'/g, "\\'")
               .replace(/\\"/g, '\\"')
               .replace(/\\&/g, "\\&")
               .replace(/\\r/g, "\\r")
               .replace(/\\t/g, "\\t")
               .replace(/\\b/g, "\\b")
               .replace(/\\f/g, "\\f");
	s = s.replace(/[\u0000-\u0019]+/g,""); 
	return s;
};


//숫자인지 체크
Utils.isNumber = function(s) 
{
	var nc = /^[0-9]*$/;
	return nc.test(s);
};

//첫글자만 대문자 변환
Utils.ucfirst = function(str) 
{
	return str.substring(0, 1).toUpperCase() + str.substring(1, str.length).toLowerCase();
};

//문자열 바이트 길이
Utils.lenByte = function(s,b,i,c)
{
	for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
	return b;
};

//문자열 바이트 짜르기
//문자열, 길이제한, 점 표시 유무(..)
Utils.cutByte = function(str, len, dotIs)
{
	var nll = /\u0000/g;	//NULL 허용안함
	var space = /^\s+|\s+$|(\s)\s+/g;	//space 하나만
	
	if(dotIs==null) dotIs = true;
	
	var dots = "";
	str = str.replace(nll, '').replace(space, '$1');
	var strLen = Utils.lenByte(str);
	
	if(dotIs && strLen > len) dots = "...";
	
	for(b=i=0;c=str.charCodeAt(i);)
	{
		b+=c>>7?2:1;
		if (b > len) break;

		i++;
	}

	return str.substring(0,i) + dots;
};


//Object 복사 
Utils.cloneObject = function(obj)
{
    if (obj === null || typeof obj !== 'object') {
        return obj;
    }
 
    var temp = obj.constructor(); // give temp the original obj's constructor
    for (var key in obj) {
        temp[key] = Utils.cloneObject(obj[key]);
    }
 
    return temp;
}; 

//버턴객체 생성
Utils.onCreateBtn = function(paramJson)
{
	/*
	paramJson.THIS	: this
	paramJson.THISCLASSNAME	: this.className
	paramJson.EVENTNAME	: 이벤트명
	paramJson.BTNTEXT	: 버튼 텍스트명
	*/
	
	var inBtnEle = null;
	var inBtn = new AButton();
	inBtn.init();
	inBtn.setText(paramJson.BTNTEXT); 
	inBtn.setWidth('100%');
	inBtn.setHeight('100%');
	inBtn.$ele.css('position','relative').css('font-size','16px').attr('data-listener-click',paramJson.THISCLASSNAME + ':'+paramJson.EVENTNAME).attr('data-speed-button','true');
	inBtn.addEventListener('click', paramJson.THIS, paramJson.EVENTNAME); 
	var cDivViewObj = theApp.onCreateAViewObj('','100%','50%');  	//높이 가운데처리
	cDivViewObj.addComponent(inBtn); 
	
	
	return 	{
				'OBJ': inBtn,
				'ELE': cDivViewObj.$ele
			}; 
};



//뷰객체 데이터 바인딩(기본라벨, 스톡라벨, 등락폭라벨, 기타등등..) - HTML
Utils.onDataBindLabel = function(paramJson)
{
	/*
	paramJson.THIS : this
	paramJson.THISVIEWOBJ	: this.xBasicLabel
	paramJson.TEXTALIGN	: center
	paramJson.VALUES	: {
		'OPTYPE': '상수비교', //[상수비교, 아이템비교, 매도매수구분, 대치, 체결성향, 등락기호, 종목명변환, 회원사명변환, 그룹사명변환, CASE별대치, 종목명변환색상, 해외선물표시가격, STRING_CASE]
		'VALUE': '값',
		'ITEM1': '연산자 아이템',
		'ITEM2': '비교 아이템 또는 상수',
	}
	*/
	
	//afc.log(paramJson.THISVIEWOBJ.setData);
	if(paramJson.THISVIEWOBJ.setData) paramJson.THISVIEWOBJ.setData(paramJson.VALUES);
	
	if(paramJson.TEXTALIGN==null || paramJson.TEXTALIGN=="") paramJson.TEXTALIGN = "center" ;
	
	paramJson.THISVIEWOBJ
	.$ele
	.css({
		'position': 'relative',
		'width': '100%', 
		'top': '50%',
		'left': '0px', 
		'right': '0px',
		'margin': '0 auto',
		'overflow': 'auto', 
		'background': 'transparent',
		'border': '0px solid #ff0000'
	})
	.find('span')
	.css({
		'text-align':paramJson.TEXTALIGN,
		'padding':'0 5px 0 5px'
	});
		
	return $('<div></div>').html(paramJson.THISVIEWOBJ.$ele.clone()).html();
};

// private method for UTF-8 decoding
Utils._utf8_decode = function (utftext)
{
	var string = "";
	var i = 0;
	var c = c1 = c2 = 0;

	while ( i < utftext.length )
	{
		c = utftext.charCodeAt(i);

		if (c < 128)
		{
			string += String.fromCharCode(c);
			i++;
		}
		else if((c > 191) && (c < 224))
		{
			c2 = utftext.charCodeAt(i+1);
			string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
			i += 2;
		}
		else
		{
			c2 = utftext.charCodeAt(i+1);
			c3 = utftext.charCodeAt(i+2);
			string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
			i += 3;
		}
	}
	return string;
}

Utils.makeSpace = function(input, length)
{
	var result = input;
	for(var i=result.length; i<length; i++)
	{
		result += ' ';
	}
	return result;
};

Utils.makeIO = function(input, length)
{
	var result = '';
	for(var i=0; i<input.length; i++)
	{
		result += Utils.makeSpace(input[i], length[i]);
	}
	return result;
};

Utils.makeNUMString = function(input, length)
{
	if (input == '')
	{
		input = 0;
	}
	
	var result = '+';
	for(var i = input.toString().length; i < length-1; i++)
	{
		result += '0';
	}
	result += input.toString();
	
	return result;
}


Utils.validPhone = function(str)
{
	str = str.replace(/[^0-9]/g, '');
	var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	//var regExp = /^\d{2,3}-\d{3,4}-\d{4}$/;
	return regExp.test(str);
};

Utils.validEmail = function(str)
{
	str = str.trim();
	var regExp = /^[0-9a-zA-Zㄱ-ㅎ가-힣]([-_\.]?[0-9a-zA-Zㄱ-ㅎ가-힣])*@[0-9a-zA-Zㄱ-ㅎ가-힣]([-_\.]?[0-9a-zA-Zㄱ-ㅎ가-힣])*\.[a-zA-Z]{2,3}$/i;
	return regExp.test(str);
};

Utils.makeIdNoForm = function(str)
{
	str = str.replace(/[^0-9]/g, '');
	var tmp = '';
	if( str.length < 7){
		return str;
	}else{
		tmp += str.substr(0, 6);
		tmp += '-';
		tmp += str.substr(6);
		return tmp;
	}
	return str;
};

Utils.makePhoneForm = function(str)
{
	str = str.replace(/[^0-9]/g, '');
	var strLen = str.length;
	var tmp = '';
	if( strLen < 2)
	{
		return str;
	}
	else
	{
		//서울일 경우
		if(str.substring(0,2) == '02')
		{
			if(strLen < 4)
			{
				return str;
			}
			else if(strLen < 6)
			{
				tmp += str.substr(0, 2);
				tmp += '-';
				tmp += str.substr(2);		
				return tmp;
			}
			else if(strLen < 10)
			{
				tmp += str.substr(0, 2);
				tmp += '-';
				tmp += str.substr(2, 3);
				tmp += '-';
				tmp += str.substr(5);
				return tmp;
			}
			else
			{
				tmp += str.substr(0, 2);
				tmp += '-';
				tmp += str.substr(2, 4);
				tmp += '-';
				tmp += str.substr(6, 4);
				return tmp;
			}
		}
		//기업 번호일 경우
		else if(str.substring(0,1) != '0')
		{
			if(strLen < 4)
			{
				return str;
			}
			else if(strLen < 9)
			{
				tmp += str.substr(0, 4);
				tmp += '-';
				tmp += str.substr(4);
				return tmp;
			}
			else return str;
		}
		//일반전화 및 핸드폰일 경우
		else
		{
			if( str.length < 4)
			{
				return str;
			}
			else if(str.length < 7)
			{
				tmp += str.substr(0, 3);
				tmp += '-';
				tmp += str.substr(3);
				return tmp;
			}
			else if(str.length < 11)
			{
				tmp += str.substr(0, 3);
				tmp += '-';
				tmp += str.substr(3, 3);
				tmp += '-';
				tmp += str.substr(6);
				return tmp;
			}
			else if(str.length < 12)
			{				
				tmp += str.substr(0, 3);
				tmp += '-';
				tmp += str.substr(3, 4);
				tmp += '-';
				tmp += str.substr(7);
				return tmp;
			}			
			else return str;
		}
		
	}
};

Utils.yyyymmdd = function(date) { var d = new Date(date), month = '' + (d.getMonth() + 1), day = '' + d.getDate(), year = d.getFullYear(); if (month.length < 2) month = '0' + month; if (day.length < 2) day = '0' + day; return [year, month, day].join(''); };

Utils.makeAccForm = function(data) {
	if(!data) return '';
	return [data.substring(0, 3), data.substring(3, 5), data.substring(5)].join('-');
};

Utils.formatDotDate = function(dateNum)
{
	if(!parseInt(dateNum, 10)) return '';
    dateNum+='';
    return dateNum.substring(0,4)+'.'+dateNum.substring(4,6)+'.'+dateNum.substring(6,8); 
};
Utils.makeSubAcc = function(accNo)
{
	if(accNo.trim().length == 14)
		return accNo.substr(11,3);
	else
		return '';
};
Utils.validEnglish = function(str)
{
	var regExp = /[^A-Za-z0-9]/g;
	return str.replace(regExp, '');
}
//만나이 계산기 - 입력포멧: yyyyMMdd, yyyy-MM-dd, yyMMdd
Utils.clalcKoreanAge = function(birth) {                 

    var date = new Date();
    var year = date.getFullYear();
    var month = (date.getMonth() + 1);
    var day = date.getDate();       

    if (month < 10) month = '0' + month;
    if (day < 10) day = '0' + day;

    var monthDay = month + '' + day;
    birth = birth.replace('-', '').replace('-', '');
    if(birth.length == 6) {
        if( parseInt(birth.substr(0, 2), 10) < 20 ) {
            birth = "20" + birth;
        } else {
            birth = "19" + birth;
        }
    }

	var birthdayy = birth.substr(0, 4);
    var birthdaymd = birth.substr(4, 4);
    var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;
    return age;
} 

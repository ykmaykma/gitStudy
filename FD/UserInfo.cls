
/**
Constructor
Do not call Function in Constructor.
*/
@class UserInfo()
{
	this.userObj = new Object();
	//유저 로그인 권한(-1: 비로그인, 0:SNS로그인, 1:ID로그인, 2:공인인증 로그인)
	this.loginState = -1;
}

//유저정보를 가져옴(key)가 없을경우 전체 정보를 가져옴
@function UserInfo:get(key)
{
	if(key) return this.userObj[key];
	else return this.userObj;
};

@function UserInfo:set(key, data)
{
	if(this.userObj) this.userObj[key] = data;
};

//유저정보를 셋팅함
@function UserInfo:setUserData(userObj, value)
{
	//비대면 유저정보 세팅(NFTF)
	if(value){
		var outBlock = this.queryData.getBlockData('OutBlock1')[0];
		var key = userObj;
		
		if(key == 'D1실명확인번호암호화') {
			this.birthdayCipher = value;
			return;
		}
		if(key == 'D1생년월일')
		{
			this.birthday = value;
			return;
		}
		outBlock[key] = value;
	}
	//로그인 유저정보 세팅
	else{
		this.userObj = userObj;
	}
};


//유저정보를 SACMQ633 OutBlock값 통으로 얻어옴.(NFTF)
@function UserInfo:setQueryData(queryData)
{
	this.queryData = queryData;
};


//유저정보를 SACMQ633 의 키값으로 얻어옴.(NFTF)
@function UserInfo:getUserData(key)
{
	var outBlock = this.queryData.getBlockData('OutBlock1')[0];
	
	if(key == 'D1실명확인번호암호화')
	{
		return this.birthdayCipher;
	}
	if(key == 'D1생년월일')
	{
		return this.birthday;
	}
	if(!key) return outBlock;
	else return outBlock[key];
};

//메뉴 권한 키를 가져옴
@function UserInfo:getUserMenuAuthKey()
{
	if(this.userObj) return this.userObj['D1메뉴권한키'];
	else return null;
};

//유저 로그인 권한등급을 가져옴
@function UserInfo:getUserLoginState()
{
	return this.loginState;
};

//SNS로그인 여부를 리턴
@function UserInfo:isSNSLogin()
{
	return (this.loginState == 0);
};

//유저 로그인 권한등급을 셋팅함
@function UserInfo:setUserLoginState(state, autoLogin)
{
	this.loginState = state;
	//자동로그인일 경우 공인인증로그인이 한번이라도 성공했다는 것이므로 1로 셋팅
	if(autoLogin) theApp.prefInfo.get('User')[1] = 1;
	else
	{
		//아이디 패스워드를 눌러 공인인증으로 로그인할 경우 1로 셋팅
		if(state > 1) theApp.prefInfo.get('User')[1] = 1;
		else theApp.prefInfo.get('User')[1] = 0;
	}
};

//로그인 상태 확인
@function UserInfo:isLogin()
{
    return (this.loginState > -1);
};

//영업일을 가져옴
@function UserInfo:getBusinessDay()
{
	if(this.userObj && this.userObj['D1영업일'])
	{
		return this.userObj['D1영업일'];
	}
	else return -1;
};

//출국자 조회
@function UserInfo:isIpOversea(callback, rno)
{
	//헤더에서 ip 받아오기
	var userIP = theApp.accNetManager.getHeaderInfo('PUB_IP');
	
	if(userIP != undefined)
	{
		var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
		userIP += '';  // 숫자를 문자열로 변환
		while (reg.test(userIP))
			userIP = userIP.replace(reg, '$1' + '.' + '$2');

	}	
	
	/* 비동기방식	
	$.getJSON("http://whois.kisa.or.kr/openapi/whois.jsp?query="+userIP+"&key="+Define.WHOIS_API_KEY+"&answer=json",
		function(result) 
		{
    		return result.whois.countryCode;
    	}
    );*/
	
	//동기 방식
	var whoisApiUrl = "http://whois.kisa.or.kr/openapi/whois.jsp?query="+userIP+"&key="+Define.WHOIS_API_KEY+"&answer=json";
	
	
	/*
	var resultPage = new XMLHttpRequest();
    resultPage.open( "GET", whoisApiUrl, false );
    resultPage.send( null );
    
	var resultData = resultPage.responseText;
	*/
	
	var resultObj = null;

    $.ajax(
    {
    	async: false,
		type:"GET",
        url: whoisApiUrl,
        dataType: 'text',
        success: function(resultData)
        {
			resultObj = JSON.parse(resultData);
        },
        
        error: function() 
        {
        	
        }
    });
	
	
	if(resultObj==null) 
	{
		callback.call(thisObj, '9999', 'WHOIS와의 통신이 원활하지 않습니다.');
		return;
	}
	
	
	//해외 ip인지 체크 KR이외의 값은 해외 ip임 -> 출국자 조회
	if(resultObj.whois.countryCode == 'KR') 
	{
		//KR이면 false 리턴
		callback.call(this, '02', '현재 국내IP 주소를 사용중입니다.');
	}
	else
	{
		//해외 ip일 경우 사용자가 출국자인지 조회
		var thisObj = this;

		theApp.accNetManager.sendProcessByName('SACMQ726', null, null, 
		function(queryData, groupName)
		{
			
			var inblock = queryData.getBlockData('InBlock1');
			inblock[0] = {
						  'D1고객명': thisObj.get('D1사용자명'), 	
						  'D1실명확인번호': rno
						 };

			queryData.printQueryData();

		},
		function(queryData, groupName)
		{
			this.printLastError();
			if(queryData)
			{
				queryData.printQueryData();

				var outBlock1 = queryData.getBlockData('OutBlock1')[0];
				//승인코드  -->   00:출국자, 01:미출국자
				if(outBlock1['D1승인코드'] == "00") callback.call(thisObj, '00');
				else if((outBlock1['D1승인코드'] == "01")) callback.call(thisObj, '01');
				else callback.call(thisObj, '02', outBlock1['D1설명1']);
				//D1설명1의 내용은 밑에 응답에러코드와 같음
			}
			else
			{
				callback.call(thisObj, '02', '출국자 정보를 조회할수 없습니다.');
			}
		});
	}
	
/*	응답에러코드
	130 : 데이터포맷 오류입니다.
	150 : 필수항목의 데이터 내용이 누락되었습니다.
	190 : 출입국관리사무소 시스템의 응답이 없습니다.
	200 : 주민등록번호가 잘못되었습니다.
	210 : 한국 국적이 아닙니다.
	220 : 출입국관리사무소 시스템 점검중 입니다.
	800 : 입력된 IP의 국가코드를 확인할 수 없습니다.
	810 : 입력된 IP의 국가코드는 KR입니다.
	820 : 잘못된 OP코드입니다.
	850 : WHOIS와의 통신이 원활하지 않습니다.
	860 : WHOIS 응답 : QUERY IP 정보가 잘못되었습니다.
	890 : 금융결제원 시스템의 응답이 없습니다.*/
};


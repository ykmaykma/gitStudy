
/**
Constructor
Do not call Function in Constructor.
*/
@class PrefInfo()
{
	this.data = 
	{
		//유저 저장정보['아이디저장', '최초로그인여부 0:로그인안함 / 1:공인인증로그인함', '암호화된 비번 저장', '비번 자리수', '보안키패드버전']
		User: ['', 0, '', 0, ''],
		
		LastPage: 'FD0001',

		// 이벤트에서 쓰는 오늘하루보지않기
		EventDate:'',
		
		// 이벤트에서 쓰는 오늘하루보지않기
		EventDate2:'',
		
		// 이벤트에서 쓰는 오늘하루보지않기
		EventDate3:'',
		
		// 카카오팝업 일주일동안보지않기
		KakaoPopDate:'',
		
		// 월적립식 매수절차 팝업
		MonthBuyStepDate:'',
		
		// 이벤트 문자발송 여부 체크값
		SMSSendFlag:'',
		
		//공지사항에서 쓰는 오늘하루보지않기
		NoticeNumber : [0,],

		//저사양폰 알림에서 쓰는 오늘하루보지않기
		LowVersionDate:'',
		
		//펀드매수 높이 세팅 관련 수정
		fundScroll2:''
		
	};
};

//preference 정보 읽어오기
@function PrefInfo:loadInfo()
{
	CallbackDone.begin();
	
	var dataVal = null;
	var prevVal = null;

	var thisObj = this;
	AppManager.getPref('PREF', function(result)
	{
		var tmp = null;
		if(result) tmp = JSON.parse(result);
		for(var p in tmp)
		{
			dataVal = thisObj.data[p];
			prevVal = tmp[p];
			if( (dataVal != undefined) && (prevVal != undefined) )
			{
				thisObj.data[p] = tmp[p];
			}
		}
		CallbackDone.end();
	});
};

//preference 정보 저장하기
@function PrefInfo:saveInfo()
{
	this.get('User')[4]=Define.ENC_PREFIX;
	AppManager.setPref('PREF', JSON.stringify(this.data));
};

//키로 정보 가져오기
@function PrefInfo:get(key)
{
    var resultData = '';
	if(this.data) resultData = this.data[key];
	return resultData;
};

//해당 키로 정보 셋하기
@function PrefInfo:set(key, data)
{
    if(this.data) this.data[key] = data;
	this.saveInfo();
};


//key/value 에서 키만 배열로 가져오기
@function PrefInfo:getKeys(obj)
{
	if (!(typeof obj == "object")) return [];
	var keys = [];
	for (var key in obj) if (obj != null && hasOwnProperty.call(obj, key)) keys.push(key);
	return keys;
};


//해당 키로 Map(key,value) 정보 추가하기
@function PrefInfo:setMap(key, subkey, data)
{
    if(this.data) this.data[key][subkey] = data;
};


//해당 키로 배열 정보 추가하기
//2015/12/30/배경수
@function PrefInfo:add(key, data)
{
    if(this.data) this.data[key].push(data);
};


//값, 배열, 오브젝트 등등 비교 함수
//사용법1: compare( 1, 1 ) = true
//사용법2: compare( "abc", "abc" ) = true
//사용법3: compare( null, null ) = true
//사용법4: compare( false, false ) = true
//사용법5: compare( [5,1], [5,1] ) = true
//사용법6: compare( [5,[1,2],4], [5,[1,2],4] ) = true
//사용법7: compare( {a:[5,[1,2],4],b:3,c:"aaa",d:{a:3,b:5}}, {a:[5,[1,2],4],b:3,c:"aaa",d:{a:3,b:5}}) = true
@function PrefInfo:isCompare(a, b)
{
	var i = 0, j;
	if(typeof a == "object" && a){
		if(Array.isArray(a))
		{
			if(!Array.isArray(b) || a.length != b.length) return false;
			for(j = a.length ; i < j ; i++) if(!this.isCompare(a[i], b[i])) return false;
			return true;
		}else{
			for(j in b) if(b.hasOwnProperty(j)) i++;
			for(j in a) if(a.hasOwnProperty(j)){
				if(!this.isCompare(a[j], b[j])) return false;
				i--;
			}
			return !i;
		}
	}
	return a === b;
};

//최초 로그인상태 가져오기
@function PrefInfo:getFirstLogin()
{
	return this.data.User[1];
};

//최초 로그인상태 변경
@function PrefInfo:setFirstLogin()
{
	this.data.User[1] = 1;
};


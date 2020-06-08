
//설정 객체
@class ConfigInfo()
{
	//설정
	this.config										= null;  		
}

//# 설정 초기화
@function ConfigInfo:initConfigInfo()
{
	//기본정보
	this.config['VER_INFO'] 	= '0.1';						//버전 정보	
	
	//개인정보
	this.config['IDSAVE_ONOFF'] = 'ON';							//아이디 저장 (ON/OFF)
	this.config['IDHIDE_ONOFF'] = 'OFF';						//아이디 숨김 (ON/OFF)
	this.config['PWSAVE_ONOFF'] = 'ON';							//계좌 비밀번호 저장 (ON/OFF)  2020.04.10 추가
	
	//
	//초기화면
	//
	
	//초기화면 설정(TOT:종합화면, INT:관심종목, CUR:현재가화면, LAS:마지막화면)
	this.config['BASIC_SCR'] 	= (theApp.systemInfo.get('FirmFirstPage')) ? theApp.systemInfo.get('FirmFirstPage') : 'CUR';
};


//설정값  - 가져오기
@function ConfigInfo:get(key)
{	
	return this.config[key];
};

//설정값  - 세팅
@function ConfigInfo:set(key, value)
{	
	this.config[key] = value;
};


//설정 정보 읽어오기
@function ConfigInfo:loadInfo()
{
	CallbackDone.begin();

	var thisObj = this;
	AppManager.getPref('CONF', function(result)
	{
		if(result) thisObj.config = JSON.parse(result);
		
		//로드한 값이 없으면
		else
		{
			thisObj.config	= {};
			//설정 초기화[나중에 저장 값 세팅]
			thisObj.initConfigInfo();
		}
		/*
		AppManager.setPref('ATCLS_ONOFF', thisObj.config['ATCLS_ONOFF']);
		AppManager.applyPref();
		*/
		CallbackDone.end();
	});
	
};

//설정 정보 저장하기
@function ConfigInfo:saveInfo()
{
	AppManager.setPref('CONF', JSON.stringify(this.config));
};













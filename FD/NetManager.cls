
/**
Constructor
Do not call Function in Constructor.
*/
@class NetManager(name)
{
	@super();

	this.name = name;
	this.connectCallback = null;
	this.keyCallback = null;
}
@extends QueryManager;


@function NetManager:setConnectCallback(connectCallback)
{
	this.connectCallback = connectCallback;
};

@function NetManager:onConnected(success)
{
	if(success)
		this.addQueryListener(this);
		
	if(this.connectCallback)
	{
		this.connectCallback(success);
		this.connectCallback = null;
	}
	
};

@function NetManager:onClosed()
{
	@super.onClosed();

	this.removeQueryListener(this);
	
	if(!this.selfClose)
		theApp.connectManager.connectAccForOneTime();
};
/*
//전송버퍼에 데이터를 채우기 전에 호출된다.
@function NetManager:beforeInBlockBuffer(queryData, groupName)
{
	//계정계 TR 은 무조건 암호화 함.
	queryData.enableFlag('encFlag');
};
*/

@function NetManager:onSendFail()
{
	if(AppManager.isOltp) AppManager.endNFTFOltp();
	else AppManager.hideNFTFProgress();
	AppManager.hideTextProgress();
	
	if(this.errorData.trName!='EVESF001')
	{
		var win = AWindow.createWindow('FD/window/MS1005_W05.lay', 'MS1005_W05');
		win.infoMsg = '<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">통신 상태가 원활하지 않습니다.<br>다시 시도해 주십시오(C)</span>';
		win.openAsDialog(this);
	}
};

@function NetManager:loginProcess(dataSize)
{

	var svcId = this.rcvBuf.getOriString(OS_TH_SVC_ID, SZ_TH_SVC_ID);
	
	if(svcId=='SCSFINL1')
	{
		//시스템 시간	x(17)
		//공개키 길이	9(4)
		//공개키		binary(가변)
		var keySize = this.rcvBuf.nextParseInt(4);
		var finalKey = this.rcvBuf.getBase64String(this.rcvBuf.getOffset(), keySize);
		var thisObj = this;
		
		//공개키를 세팅하여 암호화 준비 완료
		this.keyFinal(finalKey, function(result)
		{
			if(result == -100)
			{
				thisObj.keyHandShake();
			}
			else
			{
				if(AppManager.isOltp) AppManager.endNFTFOltp();
				else AppManager.hideNFTFProgress();
				AppManager.hideTextProgress();
				
				thisObj.keyCallback(Define.FAIL);
				thisObj.keyCallback = null;
				var win = AWindow.createWindow('FD/window/MS1005_W05.lay', 'MS1005_W05');
			win.infoMsg = '<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">통신 상태가 원활하지 않습니다.<br>다시 시도해 주십시오(H-1)</span>';
			win.openAsDialog(thisObj);
			}
			
		});
	}
	else if(svcId=='SCSFINL2')
	{
		//시스템 시간	x(17)
		//공개키 길이	9(4)
		//공개키		binary(가변)
		var keySize = this.rcvBuf.nextParseInt(4);
		var finalKey = this.rcvBuf.getBase64String(this.rcvBuf.getOffset(), keySize);
		var thisObj = this;
		
		//공개키를 세팅하여 암호화 준비 완료
		this.keyFinal(finalKey, function(result)
		{
			if(result > 0)
			{
				thisObj.keyCallback(Define.SUCCESS);
				thisObj.keyCallback = null;
			}
			else
			{
				thisObj.keyCallback(Define.FAIL);
				thisObj.keyCallback = null;
				
				if(AppManager.isOltp) AppManager.endNFTFOltp();
				else AppManager.hideNFTFProgress();
				AppManager.hideTextProgress();
	
				var win = AWindow.createWindow('FD/window/MS1005_W05.lay', 'MS1005_W05');
				win.infoMsg = '<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">통신 상태가 원활하지 않습니다.<br>다시 시도해 주십시오(H-2)</span>';
				win.openAsDialog(thisObj);
			}
			
		});
	}
};


@function NetManager:keyHandShake(keyCallback)
{
	var svc_id = 'SCSINIT1';
	
	if(keyCallback)
		this.keyCallback = keyCallback;
		
	else svc_id = 'SCSINIT2';

	var thisObj = this;
	this.keyInit(function(initKey)//Base64String
	{
		//--------------------------------------------------
		//Base64String -> Uint8Array
		initKey = Base64.atobArray(initKey);
		
		//--------------------------------------------------
		//	공개키 요청 패킷 전송
		var abuf = thisObj.sndBuf;
		var sendLen = 0;

		abuf.setChar(OS_CH_TG_TP, 'L'); //전문구분 -> L : 로그인 관련
		abuf.setByte(OS_CH_CMPR_TP, 0x30); //압축여부
		abuf.setByte(OS_CH_ENCR_TP, 0x30); //암호화여부
		abuf.setString(OS_CH_FILLER, SZ_CH_FILLER, ''); //데이터 옵셋, 사용 안함
		
		abuf.setString(OS_TH_SVC_ID, SZ_TH_SVC_ID, svc_id);	//서비스코드 -> TR 코드
		abuf.addNumString(4, initKey.length);					//key length
		sendLen = abuf.getOffset();
		abuf.copyBuffer(initKey, sendLen);				//initKey, binary
		
		sendLen += initKey.length;
		abuf.setNumString(OS_CH_TG_LEN, SZ_CH_TG_LEN, sendLen-SZ_CH_TG_LEN); //전문길이 필드를 제외한 길이(6)

		thisObj.sendBufferData(abuf, sendLen);
	});
};

//시뮬레이터 키교환스킵
@function NetManager:keySkip()
{
	//--------------------------------------------------
	//	공개키 요청 패킷 전송
	var abuf = this.sndBuf;
	var sendLen = SZ_COMMON_HEADER+SZ_TH_SVC_ID;

	abuf.setChar(OS_CH_TG_TP, 'L'); //전문구분 -> L : 로그인 관련
	abuf.setByte(OS_CH_CMPR_TP, 0x30); //압축여부
	abuf.setByte(OS_CH_ENCR_TP, 0x30); //암호화여부
	abuf.setOriString(OS_CH_FILLER, SZ_CH_FILLER, ''); //데이터 옵셋, 사용 안함

	abuf.setOriString(OS_TH_SVC_ID, SZ_TH_SVC_ID, '99999999');	//서비스코드 -> TR 코드
	abuf.setNumString(OS_CH_TG_LEN, SZ_CH_TG_LEN, sendLen-SZ_CH_TG_LEN); //전문길이 필드를 제외한 길이(6)

	this.sendBufferData(abuf, sendLen);
};

@function NetManager:onWindowResult(result, awindow)
{

};



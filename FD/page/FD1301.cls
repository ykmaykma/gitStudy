
/**
Constructor
Do not call Function in Constructor.
** 계좌비밀번호 변경 **
*/
@class FD1301()
{
	@super();
	
	//TODO:edit here
	this.stxfNewPwd	=	null;
	this.stxfConfirmPwd	=	null;
	
	this.accDbx = null;
	this.secureTxf = null;
}
@extends BasePage;

@function FD1301:onReady()
{
	@super.onReady();
	
	//계좌번호 비밀번호 로드뷰	
	this.accView = this.findCompById('AccView');
	this.accView.viewLoad('FD/view/FD0000_V00.lay');
	
	//계좌드롭박스
	this.accDbx = this.accView.getLoadView().accDbx;
	this.secureTxf = this.accView.getLoadView().secureTxf;
	
	this.stxfNewPwd	= this.findCompById('STxfNewPwd');
	this.stxfConfirmPwd	= this.findCompById('STxfConfirmPwd');
};

@function FD1301:onWillActive(reload)
{
	@super.onWillActive();

	this.accView.getLoadView().doInitAccInfo(4);
};

@function FD1301:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.stxfNewPwd.setText('');
	this.stxfConfirmPwd.setText('');
};

//공통 계좌필드 비밀번호 입력시
@function FD1301:fnDoSendDataManage()
{				
	if(this.secureTxf.getPwLength() == 0)
	{	
		AToast.show("계좌비밀번호를 입력해주세요.");
		this.secureTxf.addClass('active');
		return;
	}
	this.secureTxf.removeClass('active');
};

//뒤로가기 버튼
@function FD1301:onBackBtnClick(comp, info)
{
	theApp.goPrevPageCheck(false);
};

//확인 버튼
@function FD1301:onBtnModifyPwdClick(comp, info)
{
	if(!this.validForm()){
		return;
	}
	
	this.sendSACMT206();
};

//텍스트필드 값 체크
@function FD1301:validForm(){

	if(!this.secureTxf.getText())
	{
		AToast.show("계좌 비밀번호를 입력하세요.");
		this.secureTxf.addClass('active');
		return false;
	}

	if(!this.stxfNewPwd.getText())
	{
		AToast.show("변경비밀번호를 입력하세요.");
		this.stxfNewPwd.addClass('active');
		return false;
	}

	if(!this.stxfConfirmPwd.getText())
	{
		AToast.show("변경비밀번호 확인을 입력하세요.");
		this.stxfConfirmPwd.addClass('active');
		return false;
	}
	return true;
};

//계좌 비밀번호 변경 서비스
@function FD1301:sendSACMT206(){
	var thisObj = this;
	
	var	strCNewPwd = this.stxfNewPwd.getCipherData();
	var	strCConfirmPwd = this.stxfConfirmPwd.getCipherData();
	
	//계좌
	var strSelAccNo = this.accDbx.getSelectedItemData()['D1계좌번호'];
	var	strCCurPwd = this.secureTxf.getCipherData();
	
	// 전체계좌리스트 가져와서 계좌비밀번호 변경 성공하면 종합계좌에 연결된 비밀번호만 저장된 비밀번호 클리어하기 위해 계좌 정보 가져옴.
	var compInfoAcc = theApp.accInfo.getAccList();
	
	// 계좌번호만 저장하기 위한 배열
	var compareAccArr=[];
	

	// TR 전송
	thisObj.sendData('SACMT206',
	function(queryData, groupName){
		var inBlock1 = queryData.getBlockData('InBlock1')[0];

		inBlock1['D1처리구분'] = '2';
		inBlock1['D1종합계좌번호'] = strSelAccNo
		inBlock1['D1지점비밀번호'] = '';
		inBlock1['D1등록사유내용'] = 'MTS 본인정정';
		inBlock1['D1현재계좌비밀번호'] = afc.isSimulator ? '0423' : strCCurPwd;
		inBlock1['D1변경계좌비밀번호'] = strCNewPwd;
		inBlock1['D1확인계좌비밀번호'] = strCConfirmPwd;
		inBlock1['D1승인요청일'] = '';
		inBlock1['D1승인자추가메시지'] = '';
		inBlock1['D1승인사용자명'] = '';
		inBlock1['D1승인처리ID'] = '';
		inBlock1['D1최종승인자ID'] = '';

		if(!afc.isSimulator){
			queryData.putPwInfo('InBlock1','D1현재계좌비밀번호');
			queryData.putPwInfo('InBlock1','D1변경계좌비밀번호');
			queryData.putPwInfo('InBlock1','D1확인계좌비밀번호');
		}

		queryData.printQueryData();
	},
	function(queryData, groupName){
		if(!queryData)
		{
			thisObj.stxfNewPwd.addClass('active');
			thisObj.stxfConfirmPwd.addClass('active');
			return;
		}

		if(this.getLastError('errCode') == '0000' || this.getLastError('errCode') == '0208' || this.getLastError('errCode') == '208')
		{
			var spacePw = '';

			thisObj.stxfNewPwd.setText('');
			thisObj.stxfConfirmPwd.setText('');

			// 현재 비밀번호 변경을 성공한 계좌를 현재 보여주는 화면에서 계좌에 대한 비밀번호가 표시되지 않도록 클리어하기 위함.
			thisObj.accView.getLoadView().onAccDbxSelect();
			
			thisObj.stxfNewPwd.removeClass('active');
			thisObj.stxfConfirmPwd.removeClass('active');
			
			AToast.show(this.getLastError('errMsg')); //'계좌 비밀번호가 변경되었습니다.'
		}										
		//queryData.printQueryData();
	},strSelAccNo);				
				
};

@function FD1301:onHighLightTextField(comp, info)
{
	var srchTxt = comp.getText();
	if(srchTxt.length == 0)
	{
	}
	else 
	{
		comp.removeClass('active');
	}
};

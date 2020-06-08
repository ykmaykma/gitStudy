
/**
Constructor
Do not call Function in Constructor.
*/


//유형C (미성년자 대리인 인증 + 약관동의 포함)
//menuId = "SMSCERTC"; 
@class FD0200_W04(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD0200_W04.lay';

	//TODO:edit here
		
	this.qryTp = '2'    // 조회 구분 0.실명확인번호 1.고객번호 2.계좌번호
	this.accNo = null; // 실명확인번호 or 고객 번호 or 계좌번호 
	this.phoneNo = null; // 휴대폰 번호 
	this.phoneNoCode = null;  // 통신사 data 코드  [{text:'SKT',data:'1'},{text:'KT',data:'2'},{text:'LGU+',data:'3'},{text:'SKT알뜰폰',data:'5'},{text:'KT알뜰폰',data:'6'},{text:'LGU+알뜰폰',data:'7'}];
	
	this.agntNm = null;
}
@extends BaseWindow;


@function FD0200_W04:onReady()
{

	@super.onReady();
	
	
	this.btnView = this.findCompById('BtnView');
	this.mobileView = this.findCompById('MobileView');
	this.loadView = this.mobileView.loadView; 
	
	
	this.loadView.phoneInfo.phoneNm = this.phoneNo; 
	this.loadView.phoneInfo.noCode = this.phoneNoCode; 
	this.loadView.agntNm = this.agntNm;
		
	this.loadView.accNo = this.accNo;
	this.resetMobileView();

};

@function FD0200_W04:resetMobileView()
{	
		
	this.loadView.resetView();
}


@function FD0200_W04:onCancelBtnClick(comp, info)
{
	this.clearLocalData();
	this.close(0);

};

@function FD0200_W04:onConfirmBtnClick(comp, info)
{
	var mView = this.loadView;
	var thisObj=this;
	

		mView.confirmUser(function(success)
		{
			
			if(success) {				
				thisObj.close(1); 			
			}
			else 
			{
				AToast.show('휴대폰 본인 확인에 실패하였습니다');
			}
		});
	
};



@function FD0200_W04:onCancelWindowBtnClick(comp, info)
{
	this.clearLocalData();
	this.close(0); 

};


@function FD0200_W04:clearLocalData()
{

	this.accNo = null; 
	this.phoneNo = null; 	// 전화번호
	this.phoneNoCode = null;  //통신사	
	this.birthdayTxt= null;
	
	this.resetMobileView();
}
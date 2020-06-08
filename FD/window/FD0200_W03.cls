
/**
Constructor
Do not call Function in Constructor.
*/


//유형B (약관동의 미포함)
//menuId = "SMSCERTB"; 
@class FD0200_W03(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD0200_W03.lay';

	//TODO:edit here
		
	this.qryTp = '2'    // 조회 구분 0.실명확인번호 1.고객번호 2.계좌번호
	this.accNo = null; // 실명확인번호 or 고객 번호 or 계좌번호 
	this.phoneNo = null; // 휴대폰 번호 
	this.noCode = null;  // 통신사 data 코드  [{text:'SKT',data:'1'},{text:'KT',data:'2'},{text:'LGU+',data:'3'},{text:'SKT알뜰폰',data:'5'},{text:'KT알뜰폰',data:'6'},{text:'LGU+알뜰폰',data:'7'}];
	this.isSimpleSMS = true; 
	
}
@extends BaseWindow;


@function FD0200_W03:onReady()
{
	var thisObj = this; 	
	
	@super.onReady();
	this.btnView = this.findCompById('BtnView');
	this.mobileView = this.findCompById('MobileView');
	this.loadView = this.mobileView.loadView; 
	
	
	this.loadView.phoneInfo.phoneNm = this.phoneNo; 
	this.loadView.phoneInfo.noCode = this.phoneNoCode; 
		
	this.loadView.accNo = this.accNo;
		
	if (this.birthdayTxt != null  ){
		this.loadView.birthdayTxtString = this.birthdayTxt; 	  	  }
	this.resetMobileView();

};

@function FD0200_W03:resetMobileView()
{	
	this.loadView.TitleView.show(AComponent.GONE);
	
	//this.loadView.BirthDatView.show(AComponent.GONE);
	this.loadView.TelecomView.show(AComponent.GONE);
	this.loadView.resetView();
}


@function FD0200_W03:onCancelBtnClick(comp, info)
{
	this.resetMobileView();
	this.close(0);

};

@function FD0200_W03:onConfirmBtnClick(comp, info)
{
	var mView = this.loadView;
	var thisObj=this;
	if(mView.agreeValidCheck() && mView.inputValidCheck() )
	{
		mView.confirmUser(function(success)
		{

			if(success) {

				thisObj.resetMobileView();
				thisObj.close(1); //팝업 종료 				
			}
			else 
			{
				AToast.show('휴대폰 본인 확인에 실패하였습니다');
			}
		});
	}
};


@function FD0200_W03:onCancelWindowClick(comp, info)
{
	this.resetMobileView();
	this.close(0);

};

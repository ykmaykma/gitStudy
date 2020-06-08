
/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W10(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W10.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W10:onReady()
{
	@super.onReady();

	//TODO:edit here

};

@function FD3202_W10:onButton1Click(comp, info)
{

	//TODO:edit here
	// 윈도우 창 그냥 닫기
	this.close(0);

};

@function FD3202_W10:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	
	this.checkBox1 = this.findCompById('CheckBox1');
	
	this.btnConfirm = this.findCompById('BtnConfirm');
	
	this.txtRequestMoney = this.findCompById('txtRequestMoney');
	
	this.btnConfirm.enable(false); // // 확인버튼 비활성화		
	
}

@function FD3202_W10:onCheckBox1Click(comp, info)
{

	//TODO:edit here
	
	// 체크박스가 체크될 경우에만 내용팝업 올림
	if(this.checkBox1.getCheck()){
		var win = AWindow.createWindow('FD/window/FD3202_W11.lay','FD320211');

		win.bankInfo = this.bankInfo;
		win.openAsDialog(this);
	}else{
		this.btnConfirm.enable(false); // 확인버튼 비활성화
	}

};

@function FD3202_W10:onWindowResult(result, windowObj)
{
	if(windowObj.containerId == 'FD320211'){
		if(result == 1){
			this.checkBox1.setCheck(true);
			this.btnConfirm.enable(true); // 확인버튼 활성화
		}else{
			this.checkBox1.setCheck(false);
		}
	}
}



@function FD3202_W10:onBtnConfirmClick(comp, info)
{

	//TODO:edit here
	if(this.validCheck()){
		this.sendDataMonRequest();
	}else{
		
	}

};

@function FD3202_W10:sendDataMonRequest(comp, info)
{		
	var thisObj = this
	var cont = thisObj.opener.getContainer() // 연결된 최상위 뷰		
	
	thisObj.txtReqMoney = thisObj.txtRequestMoney.getText();
						
	cont.monthRequestJoin(thisObj, function(oBlock){
		if(oBlock){
			if(oBlock == "0210"){
				theApp.alert(
					[	 
						'월 지급식 약정 등록이 ','<br>',
						'완료되었습니다.','<br>',
						,' '
					].join('')
					,
					function()
					{			
						thisObj.monthPaySuccess();
					}
					,''
				);
			}
		}
	});	
};

// 월 지급식 약정 등록 성공 후 프로세스
@function FD3202_W10:monthPaySuccess()
{
	this.close(1);
};

@function FD3202_W10:validCheck()
{

	//TODO:edit here
	if(!this.txtRequestMoney.getText()){
		AToast.show("신청금액을 입력하세요");
		this.txtRequestMoney.addClass('active');
		return false;
	}
	
	return true;

};

@function FD3202_W10:ontxtRequestMoneyBlur(comp, info)
{

	//TODO:edit here
	this.txtRequestMoney.removeClass('active');
};



/**
Constructor
Do not call Function in Constructor.
*/
@class FD3202_W02(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD3202_W02.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD3202_W02:onReady()
{
	@super.onReady();
	
	this.CheckBox1 = this.findCompById('CheckBox1');	
	this.lblInvestName = this.findCompById('lblInvestName');
	
	this.btnConfirm = this.findCompById('btnConfirm');
	
	// 하단 확인 버튼 비활성화
	this.btnConfirm.enable(false);
	
	this.lblInvestName.setText(theApp.userInfo.get('D1사용자명'));
	//TODO:edit here
	
};

@function FD3202_W02:onWillActive(reload)
{
	@super.onWillActive(reload);				
			
};



@function FD3202_W02:onActiveDone(reload){
	
	@super.onActiveDone(reload);
			
};

@function FD3202_W02:onCheckBox1Click(comp, info)
{
	//TODO:edit here
		
	// 투자자정보확인서 동의 체크에 따른 버튼 활성화
	if(this.CheckBox1.getCheck()){
		this.btnConfirm.enable(true);
	}else{
		this.btnConfirm.enable(false);	
	}

};

@function FD3202_W02:onbtnConfirmClick(comp, info)
{
	//TODO:edit here
	// 동의 확인
	this.close(1);
};

@function FD3202_W02:onButton1Click(comp, info)
{

	//TODO:edit here
	// window close
	this.close(0);
};

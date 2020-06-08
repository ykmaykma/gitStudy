
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W19(containerId)
{
	@super(containerId);

	this.titleText = '안내';
	this.isAppClose = false;
	this.infoMsg = null;
	this.btnText = '확인';
	this.processType = '0';
	this.data = null;
	this.name = '';
	this.birthday = '';
}
@extends BaseWindow;

@function MS1005_W19:setData(data) {
	
	this.data = data;
	

};

@function MS1005_W19:onReady()
{
	@super.onReady();
	
	this.msgLbl = this.findCompById('MsgLbl');
	this.btn = this.findCompById('Button2');
	this.label2 = this.findCompById('Label2');
	this.view4 = this.findCompById('View4');
	
	this.label2.setText(DEFINE_VERSION);
	
	this.name = this.findCompById('Label4');
	this.birthday = this.findCompById('Label6');
	
	if(this.isAppClose) this.label2.show(AComponent.VISIBLE);
	else this.label2.show(AComponent.INVISIBLE);
	this.infoMsg = '<br><div style="float:left; width: 100%; height:100%"><span class="R" style="color:#555; font-size:24px; line-height:141%">인식된 신분증 정보가 실제 신분증<br>정보와 모두 일치합니까?<br></span></div>';
	this.msgLbl.$ele.html(this.infoMsg);

	this.btn.setText(this.btnText);
		
	this.moveToCenter();
	
	
	this.name.setText(this.data[0]);

    this.birthday.setText(this.data[1].substring(0,2) + '.' + this.data[1].substring(2,4) +'.' + this.data[1].substring(4,6));
};


@function MS1005_W19:onButton2Click(comp, info)
{
	this.close(1);
};

@function MS1005_W19:onButtonCancel(comp, info)
{
	this.close(0);
};

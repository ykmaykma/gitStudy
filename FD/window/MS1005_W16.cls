
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W16(containerId)
{
	@super(containerId);

	this.title = "";	
}	
@extends AWindow;


@function MS1005_W16:onReady()
{
	@super.onReady();

	this.labelTitle = this.findCompById('Label1');
	this.labelMsg = this.findCompById('Label2');
	
	this.driveImg = this.findCompById('DriveImg');
	this.driveImg2 = this.findCompById('DriveImg2');
	this.identityImg = this.findCompById('IdentityImg');
	this.identityImg2 = this.findCompById('IdentityImg2');
	
	this.labelTitle.setText(this.title);
	this.labelMsg.setText(this.title+' 항목의 위치를 확인하시기 바랍니다.');
	
	if( this.title == '주민등록증') {
	
		this.driveImg.$ele.hide();
		this.identityImg.$ele.show();
		this.driveImg2.$ele.hide();
		this.identityImg2.$ele.show();
		
	} else if( this.title == '운전면허증' ){
		
		this.driveImg.$ele.show();
		this.identityImg.$ele.hide();
		this.driveImg2.$ele.show();
		this.identityImg2.$ele.hide();
	
	}
	
};

@function MS1005_W16:onCloseBtnClick(comp, info)
{

	this.close(0);
};

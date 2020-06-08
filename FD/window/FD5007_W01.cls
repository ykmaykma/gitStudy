
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5007_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD5007_W01.lay';

	//TODO:edit here

}
@extends BaseWindow;


@function FD5007_W01:onReady()
{
	@super.onReady();

	
};


@function FD5007_W01:onActiveDone(reload)
{
	@super.onActiveDone(reload);
	// Object
	this.cont = this.opener.getContainer();
	
	this.radio1 =  this.findCompById('RdoTrsfBtn01'); 
	this.radio2 =  this.findCompById('RdoTrsfBtn02'); 
	this.radio3 =  this.findCompById('RdoTrsfBtn03'); 
	this.radio4 =  this.findCompById('RdoTrsfBtn04'); 
	this.radio5 =  this.findCompById('RdoTrsfBtn05');
	this.radio6 =  this.findCompById('RdoTrsfBtn06');
	
	this.setButton = this.settingButton;
	
	if(this.setButton == 5){
		this.radio1.setSelect(true);
	}else if(this.setButton == 7){
		this.radio2.setSelect(true);
	}else if(this.setButton == 10){
		this.radio3.setSelect(true);
	}else if(this.setButton == 15){
		this.radio4.setSelect(true);
	}else if(this.setButton == 20){
		this.radio5.setSelect(true);
	}else{
		this.radio6.setSelect(true);
	}
	
};



//X 버튼 
@function FD5007_W01:onBtnCloseClick(comp, info)
{
	this.close(0);
	
};


//확인 버튼 클릭
@function FD5007_W01:onBtnOkClick(comp, info)
{

	//TODO:edit here
	
	if(this.radio1.isSelected == true){
		this.close(1);
	}else if(this.radio2.isSelected == true){
		this.close(2);
	}else if(this.radio3.isSelected == true){
		this.close(3);
	}else if(this.radio4.isSelected == true){
		this.close(4);
	}else if(this.radio5.isSelected == true){
		this.close(5);
	}else if(this.radio6.isSelected == true){
		this.close(6);
	}else{
		AToast.show('버튼을 선택해 주세요')
	}	

};


@function FD5007_W01:onRdoTrsfBtnClick(comp, info)
{

	//TODO:edit here
	
	if(comp.compId == 'RdoTrsfBtn01'){
		this.radio2.setSelect(false);
		this.radio3.setSelect(false);
		this.radio4.setSelect(false);
		this.radio5.setSelect(false);
		this.radio6.setSelect(false);
	}else if(comp.compId== 'RdoTrsfBtn02'){
		this.radio1.setSelect(false);
		this.radio3.setSelect(false);
		this.radio4.setSelect(false);
		this.radio5.setSelect(false);
		this.radio6.setSelect(false);
	}else if(comp.compId == 'RdoTrsfBtn03'){
		this.radio2.setSelect(false);
		this.radio1.setSelect(false);
		this.radio4.setSelect(false);
		this.radio5.setSelect(false);
		this.radio6.setSelect(false);
	}else if(comp.compId== 'RdoTrsfBtn04'){
		this.radio2.setSelect(false);
		this.radio3.setSelect(false);
		this.radio1.setSelect(false);
		this.radio5.setSelect(false);
		this.radio6.setSelect(false);
	}else if(comp.compId == 'RdoTrsfBtn05'){
		this.radio2.setSelect(false);
		this.radio3.setSelect(false);
		this.radio4.setSelect(false);
		this.radio1.setSelect(false);
		this.radio6.setSelect(false);
	}else if(comp.compId == 'RdoTrsfBtn06'){
		this.radio2.setSelect(false);
		this.radio3.setSelect(false);
		this.radio4.setSelect(false);
		this.radio5.setSelect(false);
		this.radio1.setSelect(false);
	}
		

};
